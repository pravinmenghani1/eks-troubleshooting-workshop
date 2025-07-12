# Pod Startup Failures

## Scenario Description
A pod is failing to start and remains in `Pending` or `CrashLoopBackOff` state. This scenario covers common causes and troubleshooting steps.

## Problem Statement
Your application pod is not starting successfully. The pod shows various error states and the application is not accessible.

## Symptoms
- Pod status shows `Pending`, `CrashLoopBackOff`, or `Error`
- Application is not responding to requests
- Pod restarts frequently
- Events show scheduling or startup issues

## Setup Instructions

1. Apply the problematic pod configuration:
```bash
kubectl apply -f broken-pod.yaml
```

2. Observe the pod status:
```bash
kubectl get pods
kubectl describe pod <pod-name>
```

## Troubleshooting Steps

### Step 1: Check Pod Status and Events
```bash
# Get pod status
kubectl get pods -o wide

# Get detailed pod information
kubectl describe pod <pod-name>

# Check pod events
kubectl get events --sort-by=.metadata.creationTimestamp
```

### Step 2: Examine Pod Logs
```bash
# Get current logs
kubectl logs <pod-name>

# Get previous container logs (if pod restarted)
kubectl logs <pod-name> --previous

# Follow logs in real-time
kubectl logs -f <pod-name>
```

### Step 3: Check Resource Constraints
```bash
# Check node resources
kubectl describe nodes

# Check resource quotas
kubectl describe resourcequota

# Check limit ranges
kubectl describe limitrange
```

### Step 4: Verify Image and Configuration
```bash
# Check if image exists and is accessible
docker pull <image-name>

# Verify pod specification
kubectl get pod <pod-name> -o yaml
```

## Common Issues and Solutions

### Issue 1: ImagePullBackOff
**Cause**: Cannot pull the container image
**Solution**:
- Verify image name and tag
- Check image registry credentials
- Ensure network connectivity to registry

### Issue 2: Insufficient Resources
**Cause**: Node doesn't have enough CPU/memory
**Solution**:
- Scale cluster or add nodes
- Adjust resource requests/limits
- Check for resource quotas

### Issue 3: Configuration Errors
**Cause**: Invalid pod specification
**Solution**:
- Validate YAML syntax
- Check environment variables
- Verify volume mounts and secrets

### Issue 4: Node Selector Issues
**Cause**: No nodes match the pod's node selector
**Solution**:
- Check node labels
- Modify or remove node selector
- Add appropriate labels to nodes

## Resolution Verification

1. Pod should be in `Running` state:
```bash
kubectl get pods
```

2. Application should be accessible:
```bash
kubectl port-forward <pod-name> 8080:80
curl localhost:8080
```

3. No error events should be present:
```bash
kubectl get events --field-selector type=Warning
```

## Prevention Tips

- Always test images before deployment
- Set appropriate resource requests and limits
- Use health checks (readiness and liveness probes)
- Monitor cluster resource usage
- Implement proper logging and monitoring
