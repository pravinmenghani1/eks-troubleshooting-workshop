# Pod Startup Failures - Troubleshooting Guide

## Scenario Overview
Multiple applications have been deployed with various startup issues. Your task is to identify and fix each problem.

## Applications Deployed
1. **broken-image-app** - Image pull issues
2. **resource-hungry-app** - Resource constraint issues  
3. **secret-dependent-app** - Missing secret references
4. **node-selector-app** - Node selector problems
5. **crashloop-app** - Application crash loop

## Your Mission
Fix each application so that all pods are running successfully.

## Troubleshooting Steps

### Step 1: Identify Problem Pods
```bash
kubectl get pods -n troubleshooting-pod-startup
kubectl get deployments -n troubleshooting-pod-startup
```

### Step 2: Investigate Each Issue
For each problematic pod:
```bash
kubectl describe pod <pod-name> -n troubleshooting-pod-startup
kubectl logs <pod-name> -n troubleshooting-pod-startup
kubectl get events -n troubleshooting-pod-startup --sort-by=.metadata.creationTimestamp
```

### Step 3: Fix the Issues
Use `kubectl edit` or apply corrected YAML files to fix each deployment.

## Hints

### For Image Pull Issues:
- Check the image name and tag
- Verify the image exists in the registry
- Consider using a valid nginx tag

### For Resource Issues:
- Check node capacity: `kubectl describe nodes`
- Reduce resource requests to reasonable values
- Consider what a typical web app needs

### For Secret Issues:
- Create the missing secrets or remove the references
- Use `kubectl create secret` to create required secrets

### For Node Selector Issues:
- Check available node labels: `kubectl get nodes --show-labels`
- Remove or modify impossible node selectors

### For Crash Loop Issues:
- Check application logs for error messages
- Fix the application command or add proper health checks

## Success Criteria
All pods should be in "Running" status:
```bash
kubectl get pods -n troubleshooting-pod-startup
```

## Need Help?
Run the restoration script if you get stuck: `./restore-cluster.sh`
