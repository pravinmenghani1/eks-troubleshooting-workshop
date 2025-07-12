# Image Pull Errors

## Scenario Description
Pods are failing to start due to image pull errors. This scenario covers authentication issues, network problems, and image availability issues.

## Problem Statement
Your pods are stuck in `ImagePullBackOff` or `ErrImagePull` state because Kubernetes cannot pull the container images.

## Symptoms
- Pod status shows `ImagePullBackOff` or `ErrImagePull`
- Events show "Failed to pull image" errors
- Pods remain in `Pending` state
- Long delays in pod startup

## Setup Instructions

1. Apply the problematic deployment:
```bash
kubectl apply -f image-pull-deployment.yaml
```

2. Observe the pod status:
```bash
kubectl get pods
kubectl describe pod <pod-name>
```

## Troubleshooting Steps

### Step 1: Identify the Image Pull Error
```bash
# Check pod status
kubectl get pods

# Get detailed error information
kubectl describe pod <pod-name>

# Check events for image pull errors
kubectl get events --field-selector reason=Failed
```

### Step 2: Verify Image Details
```bash
# Check the exact image name and tag
kubectl get pod <pod-name> -o jsonpath='{.spec.containers[0].image}'

# Test image pull manually (on a node or locally)
docker pull <image-name>
```

### Step 3: Check Registry Authentication
```bash
# List image pull secrets
kubectl get secrets

# Check if secret is properly configured
kubectl describe secret <image-pull-secret>

# Verify secret is attached to service account
kubectl describe serviceaccount default
```

### Step 4: Network and Registry Connectivity
```bash
# Test connectivity to registry from a pod
kubectl run debug --image=busybox --rm -it --restart=Never -- nslookup <registry-domain>

# Check if registry is accessible
kubectl run debug --image=busybox --rm -it --restart=Never -- wget -O- <registry-url>
```

## Common Issues and Solutions

### Issue 1: Private Registry Authentication
**Cause**: Missing or incorrect image pull secrets
**Solution**:
```bash
# Create docker registry secret
kubectl create secret docker-registry regcred \
  --docker-server=<registry-server> \
  --docker-username=<username> \
  --docker-password=<password> \
  --docker-email=<email>

# Add secret to service account
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "regcred"}]}'
```

### Issue 2: Image Does Not Exist
**Cause**: Wrong image name, tag, or image doesn't exist
**Solution**:
- Verify image name and tag
- Check if image exists in registry
- Use correct registry URL

### Issue 3: Network Connectivity Issues
**Cause**: Cannot reach image registry
**Solution**:
- Check security groups and NACLs
- Verify VPC endpoints for ECR
- Check DNS resolution

### Issue 4: Rate Limiting
**Cause**: Docker Hub rate limits exceeded
**Solution**:
- Use authenticated pulls
- Switch to alternative registries
- Implement image caching

## ECR-Specific Troubleshooting

### Check ECR Repository
```bash
# List ECR repositories
aws ecr describe-repositories

# Get ECR login token
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com
```

### Create ECR Secret
```bash
# Create ECR secret
kubectl create secret docker-registry ecr-secret \
  --docker-server=<account-id>.dkr.ecr.<region>.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region <region>)
```

## Resolution Verification

1. Pod should be in `Running` state:
```bash
kubectl get pods
```

2. No image pull errors in events:
```bash
kubectl get events --field-selector reason=Pulled
```

3. Container should be ready:
```bash
kubectl describe pod <pod-name>
```

## Prevention Tips

- Use specific image tags instead of `latest`
- Set up proper image pull secrets for private registries
- Monitor registry authentication token expiration
- Implement image scanning and vulnerability management
- Use multi-stage builds to reduce image size
- Consider using image pull policies appropriately
