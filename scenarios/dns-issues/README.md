# DNS Resolution Failures

## Scenario Description
Pods cannot resolve DNS names, causing service discovery failures and connectivity issues between services.

## Problem Statement
Applications cannot connect to other services or external resources due to DNS resolution failures.

## Symptoms
- "Name resolution failed" errors
- Timeouts when connecting to services
- Applications cannot find other services
- External API calls fail with DNS errors

## Setup Instructions

1. Apply the DNS test deployment:
```bash
kubectl apply -f dns-test-deployment.yaml
```

2. Test DNS resolution:
```bash
kubectl exec -it <pod-name> -- nslookup kubernetes.default.svc.cluster.local
```

## Troubleshooting Steps

### Step 1: Test Basic DNS Resolution
```bash
# Create a debug pod for testing
kubectl run dns-debug --image=busybox --rm -it --restart=Never -- sh

# Inside the pod, test DNS resolution
nslookup kubernetes.default.svc.cluster.local
nslookup google.com
dig kubernetes.default.svc.cluster.local
```

### Step 2: Check CoreDNS Status
```bash
# Check CoreDNS pods
kubectl get pods -n kube-system -l k8s-app=kube-dns

# Check CoreDNS logs
kubectl logs -n kube-system -l k8s-app=kube-dns

# Describe CoreDNS pods
kubectl describe pods -n kube-system -l k8s-app=kube-dns
```

### Step 3: Verify DNS Configuration
```bash
# Check CoreDNS ConfigMap
kubectl get configmap coredns -n kube-system -o yaml

# Check DNS service
kubectl get svc -n kube-system kube-dns

# Verify DNS endpoints
kubectl get endpoints -n kube-system kube-dns
```

### Step 4: Test from Different Namespaces
```bash
# Test service discovery within same namespace
kubectl run test-pod --image=busybox --rm -it --restart=Never -- nslookup <service-name>

# Test service discovery across namespaces
kubectl run test-pod --image=busybox --rm -it --restart=Never -- nslookup <service-name>.<namespace>.svc.cluster.local

# Test external DNS resolution
kubectl run test-pod --image=busybox --rm -it --restart=Never -- nslookup google.com
```

## Common Issues and Solutions

### Issue 1: CoreDNS Pods Not Running
**Cause**: CoreDNS deployment issues
**Solution**:
```bash
# Check CoreDNS deployment
kubectl get deployment coredns -n kube-system

# Scale CoreDNS if needed
kubectl scale deployment coredns --replicas=2 -n kube-system

# Restart CoreDNS pods
kubectl rollout restart deployment coredns -n kube-system
```

### Issue 2: Incorrect DNS Configuration
**Cause**: Wrong DNS server configuration in pods
**Solution**:
```bash
# Check pod DNS configuration
kubectl get pod <pod-name> -o yaml | grep -A 10 dnsPolicy

# Check /etc/resolv.conf in pod
kubectl exec <pod-name> -- cat /etc/resolv.conf

# Verify DNS service IP
kubectl get svc kube-dns -n kube-system
```

### Issue 3: Network Policy Blocking DNS
**Cause**: Network policies preventing DNS traffic
**Solution**:
```bash
# Check network policies
kubectl get networkpolicies --all-namespaces

# Allow DNS traffic in network policy
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to: []
    ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
```

### Issue 4: CoreDNS Configuration Issues
**Cause**: Incorrect CoreDNS Corefile configuration
**Solution**:
```bash
# Edit CoreDNS ConfigMap
kubectl edit configmap coredns -n kube-system

# Example working Corefile:
.:53 {
    errors
    health {
       lameduck 5s
    }
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       fallthrough in-addr.arpa ip6.arpa
       ttl 30
    }
    prometheus :9153
    forward . /etc/resolv.conf {
       max_concurrent 1000
    }
    cache 30
    loop
    reload
    loadbalance
}
```

### Issue 5: Node DNS Configuration
**Cause**: Node-level DNS issues
**Solution**:
```bash
# Check node DNS configuration
kubectl describe node <node-name> | grep -i dns

# SSH to node and check DNS
cat /etc/resolv.conf
systemctl status systemd-resolved
```

## EKS-Specific DNS Issues

### Check VPC DNS Settings
```bash
# Verify VPC DNS resolution and hostnames are enabled
aws ec2 describe-vpcs --vpc-ids <vpc-id> --query 'Vpcs[0].{DnsResolution:DnsResolution,DnsHostnames:DnsHostnames}'

# Check security groups allow DNS traffic
aws ec2 describe-security-groups --group-ids <sg-id>
```

### Route 53 Integration
```bash
# Check if using Route 53 for private DNS
aws route53resolver list-resolver-endpoints

# Verify DNS forwarding rules
aws route53resolver list-resolver-rules
```

## Advanced Debugging

### DNS Query Tracing
```bash
# Enable CoreDNS debug logging
kubectl patch configmap coredns -n kube-system --type merge -p '{"data":{"Corefile":".:53 {\n    log\n    errors\n    health {\n       lameduck 5s\n    }\n    ready\n    kubernetes cluster.local in-addr.arpa ip6.arpa {\n       pods insecure\n       fallthrough in-addr.arpa ip6.arpa\n       ttl 30\n    }\n    prometheus :9153\n    forward . /etc/resolv.conf {\n       max_concurrent 1000\n    }\n    cache 30\n    loop\n    reload\n    loadbalance\n}"}}'

# Watch CoreDNS logs for DNS queries
kubectl logs -f -n kube-system -l k8s-app=kube-dns
```

### Network Connectivity Testing
```bash
# Test UDP connectivity to DNS service
kubectl run netshoot --rm -it --image nicolaka/netshoot -- nc -u <dns-service-ip> 53

# Test TCP connectivity
kubectl run netshoot --rm -it --image nicolaka/netshoot -- nc <dns-service-ip> 53
```

## Resolution Verification

1. DNS resolution should work:
```bash
kubectl run test --image=busybox --rm -it --restart=Never -- nslookup kubernetes.default.svc.cluster.local
```

2. Service discovery should work:
```bash
kubectl run test --image=busybox --rm -it --restart=Never -- nslookup <service-name>
```

3. External DNS should work:
```bash
kubectl run test --image=busybox --rm -it --restart=Never -- nslookup google.com
```

## Prevention Tips

- Monitor CoreDNS health and performance
- Set appropriate DNS policies for pods
- Configure proper network policies for DNS traffic
- Regular testing of service discovery
- Monitor DNS query patterns and performance
- Keep CoreDNS updated
- Configure appropriate DNS caching policies
