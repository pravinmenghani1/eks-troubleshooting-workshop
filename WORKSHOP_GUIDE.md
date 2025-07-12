# EKS Troubleshooting Workshop Guide

## Overview
This workshop provides hands-on experience with common EKS troubleshooting scenarios. Each scenario is designed to simulate real-world issues you might encounter in production environments.

## Workshop Prerequisites

### Required Tools
- AWS CLI configured with appropriate permissions
- kubectl installed and configured
- Access to an EKS cluster
- Docker (for local testing)
- Basic understanding of Kubernetes concepts

### Cluster Setup
Ensure you have access to an EKS cluster with:
- At least 2 worker nodes
- CoreDNS installed
- Metrics server (optional, for resource monitoring)
- Cluster autoscaler (for scaling scenarios)

## Workshop Structure

### Phase 1: Environment Setup and Basic Troubleshooting (30 minutes)

1. **Cluster Health Check**
   ```bash
   ./troubleshooting-toolkit.sh
   ```

2. **Basic Kubectl Commands Review**
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   kubectl cluster-info
   ```

### Phase 2: Pod and Container Issues (45 minutes)

#### Scenario 1: Pod Startup Failures
**Time**: 15 minutes

1. Navigate to the pod startup scenario:
   ```bash
   cd scenarios/pod-startup-failures/
   ```

2. Apply the broken configuration:
   ```bash
   kubectl apply -f broken-pod.yaml
   ```

3. Follow the troubleshooting steps in the README
4. Apply the fix and verify resolution

#### Scenario 2: Image Pull Errors
**Time**: 15 minutes

1. Navigate to the image pull scenario:
   ```bash
   cd ../image-pull-errors/
   ```

2. Apply the problematic deployment:
   ```bash
   kubectl apply -f image-pull-deployment.yaml
   ```

3. Work through the troubleshooting process
4. Implement the solution

#### Scenario 3: Container Resource Issues
**Time**: 15 minutes

Create a pod with resource constraints and observe behavior:
```bash
kubectl run resource-test --image=nginx --requests='memory=10Gi,cpu=8' --limits='memory=10Gi,cpu=8'
```

### Phase 3: Node and Cluster Issues (30 minutes)

#### Scenario 1: Node Not Ready
**Time**: 15 minutes

1. Navigate to the node issues scenario:
   ```bash
   cd ../node-not-ready/
   ```

2. Simulate node issues (if all nodes are healthy):
   ```bash
   kubectl cordon <node-name>
   kubectl drain <node-name> --ignore-daemonsets
   ```

3. Follow troubleshooting steps
4. Restore node functionality

#### Scenario 2: Resource Exhaustion
**Time**: 15 minutes

Create resource pressure and observe effects:
```bash
kubectl run memory-hog --image=polinux/stress --requests='memory=1Gi' -- stress --vm 1 --vm-bytes 1G --timeout 300s
```

### Phase 4: Networking and DNS (45 minutes)

#### Scenario 1: DNS Resolution Issues
**Time**: 20 minutes

1. Navigate to DNS scenario:
   ```bash
   cd ../dns-issues/
   ```

2. Apply the DNS test deployment:
   ```bash
   kubectl apply -f dns-test-deployment.yaml
   ```

3. Test DNS resolution and troubleshoot issues
4. Verify CoreDNS functionality

#### Scenario 2: Service Discovery
**Time**: 15 minutes

Test service-to-service communication:
```bash
kubectl run client --image=busybox --rm -it --restart=Never -- sh
# Inside the pod:
# nslookup <service-name>
# wget -qO- http://<service-name>
```

#### Scenario 3: Network Policies
**Time**: 10 minutes

Apply restrictive network policies and test connectivity:
```bash
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF
```

### Phase 5: Security and RBAC (30 minutes)

#### Scenario 1: RBAC Permission Issues
**Time**: 20 minutes

1. Navigate to RBAC scenario:
   ```bash
   cd ../rbac-issues/
   ```

2. Apply the problematic RBAC configuration:
   ```bash
   kubectl apply -f rbac-demo.yaml
   ```

3. Test permissions and troubleshoot issues:
   ```bash
   kubectl auth can-i get pods --as=system:serviceaccount:default:limited-sa
   ```

4. Apply the fix and verify resolution

#### Scenario 2: Service Account Issues
**Time**: 10 minutes

Test service account functionality and token mounting.

### Phase 6: Advanced Troubleshooting (30 minutes)

#### Using the Troubleshooting Toolkit
**Time**: 10 minutes

Run specific troubleshooting scenarios:
```bash
./troubleshooting-toolkit.sh pod-startup
./troubleshooting-toolkit.sh dns
./troubleshooting-toolkit.sh rbac
```

#### Log Analysis
**Time**: 10 minutes

Practice log analysis techniques:
```bash
kubectl logs <pod-name> --previous
kubectl logs -f <pod-name>
kubectl logs <pod-name> -c <container-name>
```

#### Event Analysis
**Time**: 10 minutes

Analyze cluster events:
```bash
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get events --field-selector type=Warning
kubectl describe pod <pod-name>
```

## Workshop Exercises

### Exercise 1: Mystery Pod Issue
Create a pod with multiple issues and have participants identify and fix them:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mystery-pod
spec:
  containers:
  - name: app
    image: nginx:nonexistent
    ports:
    - containerPort: 8080
    resources:
      requests:
        memory: "20Gi"
    env:
    - name: SECRET_VALUE
      valueFrom:
        secretKeyRef:
          name: missing-secret
          key: value
  nodeSelector:
    disktype: ssd
```

### Exercise 2: Service Communication Failure
Set up two services that cannot communicate and troubleshoot the networking issue.

### Exercise 3: Permission Escalation
Create a scenario where a service account needs additional permissions to function properly.

## Best Practices Learned

1. **Systematic Troubleshooting Approach**
   - Check pod status and events first
   - Examine logs for error messages
   - Verify resource availability
   - Test network connectivity

2. **Essential Commands**
   ```bash
   kubectl get pods -o wide
   kubectl describe pod <pod-name>
   kubectl logs <pod-name>
   kubectl get events
   kubectl auth can-i <verb> <resource>
   ```

3. **Prevention Strategies**
   - Use resource requests and limits
   - Implement health checks
   - Monitor cluster resources
   - Regular RBAC audits
   - Proper image management

## Additional Resources

- [Kubernetes Troubleshooting Documentation](https://kubernetes.io/docs/tasks/debug/)
- [EKS Workshop Troubleshooting Guide](https://eksworkshop.com/docs/troubleshooting/)
- [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## Workshop Cleanup

After completing the workshop, clean up resources:
```bash
kubectl delete -f scenarios/pod-startup-failures/broken-pod.yaml
kubectl delete -f scenarios/image-pull-errors/image-pull-deployment.yaml
kubectl delete -f scenarios/dns-issues/dns-test-deployment.yaml
kubectl delete -f scenarios/rbac-issues/rbac-demo.yaml
kubectl delete pod --all
kubectl delete networkpolicy --all
```

## Feedback and Improvements

This workshop is designed to be iterative. Please provide feedback on:
- Scenario difficulty and realism
- Time allocations for each section
- Additional scenarios that would be valuable
- Tools and techniques that should be included
