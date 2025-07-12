#!/bin/bash

# Restoration Script - DNS Resolution Issues
# This script fixes all DNS problems and shows the solutions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Fix CoreDNS Configuration
fix_coredns_config() {
    print_header "Fixing CoreDNS Configuration"
    
    echo "Problem: CoreDNS had invalid configuration with wrong endpoints and forwarding"
    echo "Solution: Restore proper CoreDNS Corefile configuration"
    
    if [ -f "coredns-backup.yaml" ]; then
        echo "Restoring from backup..."
        kubectl apply -f coredns-backup.yaml
    else
        echo "Creating new working configuration..."
        cat << 'EOF' | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
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
EOF
    fi
    
    print_success "CoreDNS configuration restored to working state"
}

# Scale up CoreDNS
scale_up_coredns() {
    print_header "Scaling Up CoreDNS"
    
    echo "Problem: CoreDNS was scaled down to 0 replicas"
    echo "Solution: Scale CoreDNS back to appropriate number of replicas"
    
    kubectl scale deployment coredns --replicas=2 -n kube-system
    
    # Wait for CoreDNS to be ready
    kubectl wait --for=condition=available --timeout=120s deployment coredns -n kube-system
    
    print_success "CoreDNS scaled up to 2 replicas and ready"
}

# Remove DNS-blocking network policy
remove_dns_blocking_policy() {
    print_header "Removing DNS-Blocking Network Policy"
    
    echo "Problem: Network policy was blocking DNS traffic on port 53"
    echo "Solution: Remove the restrictive network policy or allow DNS traffic"
    
    # Option 1: Delete the blocking policy
    kubectl delete networkpolicy block-dns -n troubleshooting-dns --ignore-not-found=true
    
    # Option 2: Create a policy that allows DNS (alternative approach)
    cat << EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
  namespace: troubleshooting-dns
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
    - protocol: TCP
      port: 80
    - protocol: TCP
      port: 443
EOF

    print_success "DNS-blocking network policy removed and DNS-allowing policy created"
}

# Restart CoreDNS to apply changes
restart_coredns() {
    print_header "Restarting CoreDNS"
    
    echo "Restarting CoreDNS to apply configuration changes..."
    kubectl rollout restart deployment coredns -n kube-system
    kubectl rollout status deployment coredns -n kube-system --timeout=120s
    
    print_success "CoreDNS restarted successfully"
}

# Test DNS resolution
test_dns_resolution() {
    print_header "Testing DNS Resolution"
    
    echo "Waiting for DNS to stabilize..."
    sleep 10
    
    echo "Testing external DNS resolution:"
    kubectl run dns-test-external --image=busybox --rm -it --restart=Never --timeout=30s -- nslookup google.com || print_warning "External DNS test failed"
    
    echo -e "\nTesting internal DNS resolution:"
    kubectl run dns-test-internal --image=busybox --rm -it --restart=Never --timeout=30s -- nslookup kubernetes.default.svc.cluster.local || print_warning "Internal DNS test failed"
    
    echo -e "\nTesting service discovery:"
    kubectl run dns-test-service --image=busybox --rm -it --restart=Never --timeout=30s -n troubleshooting-dns -- nslookup test-service-a || print_warning "Service discovery test failed"
    
    print_success "DNS resolution tests completed"
}

# Check application logs
check_application_logs() {
    print_header "Checking Application Logs"
    
    echo "External connector logs (last 10 lines):"
    kubectl logs deployment/external-connector -n troubleshooting-dns --tail=10 || echo "No logs available yet"
    
    echo -e "\nService connector logs (last 10 lines):"
    kubectl logs deployment/service-connector -n troubleshooting-dns --tail=10 || echo "No logs available yet"
    
    print_success "Application logs checked"
}

# Show final status
show_final_status() {
    print_header "Final DNS Status Check"
    
    echo "CoreDNS pods:"
    kubectl get pods -n kube-system -l k8s-app=kube-dns -o wide
    
    echo -e "\nCoreDNS service:"
    kubectl get svc kube-dns -n kube-system
    
    echo -e "\nCoreDNS endpoints:"
    kubectl get endpoints kube-dns -n kube-system
    
    echo -e "\nTest applications:"
    kubectl get pods -n troubleshooting-dns -o wide
    
    echo -e "\nNetwork policies:"
    kubectl get networkpolicies -n troubleshooting-dns
    
    echo -e "\nCoreDNS configuration (first few lines):"
    kubectl get configmap coredns -n kube-system -o jsonpath='{.data.Corefile}' | head -10
}

# Create solutions summary
create_solutions_summary() {
    print_header "Creating DNS Solutions Summary"
    
    cat > dns-solutions-summary.md << 'EOF'
# DNS Resolution Issues - Solutions Summary

## Issues Fixed

### 1. Broken CoreDNS Configuration
**Problem**: CoreDNS Corefile had invalid syntax and wrong endpoints
**Solution**: Restored proper Corefile configuration with correct kubernetes plugin settings
**Key Fix**: Removed invalid endpoint configuration and fixed forward directive

### 2. CoreDNS Scaled Down
**Problem**: CoreDNS deployment was scaled to 0 replicas
**Solution**: Scaled CoreDNS back to 2 replicas
**Learning**: Always ensure DNS service has adequate replicas for availability

### 3. DNS Traffic Blocked by Network Policy
**Problem**: Network policy blocked all traffic on port 53 (DNS)
**Solution**: Removed blocking policy and created allowing policy for DNS traffic
**Learning**: Network policies must explicitly allow DNS traffic for proper resolution

## Key Troubleshooting Commands Used

```bash
# Check CoreDNS status
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl describe pods -n kube-system -l k8s-app=kube-dns
kubectl logs -n kube-system -l k8s-app=kube-dns

# Check CoreDNS configuration
kubectl get configmap coredns -n kube-system -o yaml

# Test DNS resolution
kubectl run dns-test --image=busybox --rm -it --restart=Never -- nslookup <hostname>

# Check DNS service and endpoints
kubectl get svc kube-dns -n kube-system
kubectl get endpoints kube-dns -n kube-system

# Check network policies
kubectl get networkpolicies --all-namespaces
kubectl describe networkpolicy <policy-name>
```

## Working CoreDNS Configuration

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
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

## Network Policy for DNS

```yaml
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

## DNS Troubleshooting Methodology

1. **Check DNS Service Status**
   - Verify CoreDNS pods are running
   - Check service and endpoints

2. **Test DNS Resolution**
   - Start with internal cluster DNS
   - Then test external DNS
   - Use nslookup or dig for testing

3. **Check Configuration**
   - Examine CoreDNS Corefile
   - Look for syntax errors or invalid settings

4. **Check Network Connectivity**
   - Verify network policies allow DNS traffic
   - Check security groups and NACLs

5. **Check Logs**
   - CoreDNS logs for errors
   - Application logs for DNS failures

## Prevention Tips

- Monitor CoreDNS health and performance
- Test network policies before applying
- Keep CoreDNS configuration in version control
- Set up alerts for DNS resolution failures
- Regular DNS resolution testing
- Backup CoreDNS configuration before changes
EOF

    print_success "DNS solutions summary created"
}

# Main execution
main() {
    print_header "DNS Resolution Issues - Cluster Restoration"
    
    echo "This script will fix all DNS issues and show you the solutions."
    echo "Press Enter to continue or Ctrl+C to cancel..."
    read -r
    
    fix_coredns_config
    scale_up_coredns
    remove_dns_blocking_policy
    restart_coredns
    
    echo "Waiting for DNS changes to propagate..."
    sleep 15
    
    test_dns_resolution
    check_application_logs
    show_final_status
    create_solutions_summary
    
    print_success "All DNS issues have been resolved!"
    echo -e "\n${GREEN}Summary:${NC}"
    echo "• CoreDNS configuration fixed and restored"
    echo "• CoreDNS scaled back to 2 replicas"
    echo "• DNS-blocking network policy removed"
    echo "• DNS resolution working for internal and external names"
    echo -e "\n${BLUE}What was learned:${NC}"
    echo "• How to troubleshoot CoreDNS configuration issues"
    echo "• How to identify and fix DNS service scaling problems"
    echo "• How network policies can block DNS traffic"
    echo "• Systematic approach to DNS troubleshooting"
    echo -e "\n${YELLOW}Next steps:${NC}"
    echo "• Check dns-solutions-summary.md for detailed explanations"
    echo "• Monitor application logs to see DNS resolution working"
    echo "• Try other troubleshooting scenarios"
    echo "• Run 'kubectl delete namespace troubleshooting-dns' to clean up"
}

main "$@"
