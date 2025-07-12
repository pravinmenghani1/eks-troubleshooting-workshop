# RBAC Permission Denied

## Scenario Description
Applications or users are receiving "permission denied" or "forbidden" errors when trying to access Kubernetes resources due to RBAC configuration issues.

## Problem Statement
Your application pods or users cannot perform required operations due to insufficient RBAC permissions.

## Symptoms
- "Forbidden" or "permission denied" errors
- HTTP 403 status codes from API server
- Applications cannot access required resources
- Users cannot execute kubectl commands

## Setup Instructions

1. Apply the problematic RBAC configuration:
```bash
kubectl apply -f rbac-demo.yaml
```

2. Test the permissions:
```bash
kubectl auth can-i get pods --as=system:serviceaccount:default:limited-sa
```

## Troubleshooting Steps

### Step 1: Identify the Permission Error
```bash
# Check the exact error message
kubectl logs <pod-name>

# Test specific permissions
kubectl auth can-i <verb> <resource> --as=<user-or-serviceaccount>

# List all permissions for a user/service account
kubectl auth can-i --list --as=<user-or-serviceaccount>
```

### Step 2: Examine Current RBAC Configuration
```bash
# List roles and cluster roles
kubectl get roles,clusterroles

# Check role bindings
kubectl get rolebindings,clusterrolebindings

# Describe specific role
kubectl describe role <role-name>
kubectl describe clusterrole <clusterrole-name>

# Check role bindings for a specific service account
kubectl describe rolebinding,clusterrolebinding --all-namespaces | grep -A 5 -B 5 <serviceaccount-name>
```

### Step 3: Verify Service Account Configuration
```bash
# Check service account
kubectl describe serviceaccount <sa-name>

# Check which service account the pod is using
kubectl get pod <pod-name> -o jsonpath='{.spec.serviceAccountName}'

# Verify service account token
kubectl describe secret <sa-token-secret>
```

### Step 4: Test Permissions Systematically
```bash
# Test basic permissions
kubectl auth can-i get pods --as=system:serviceaccount:<namespace>:<sa-name>
kubectl auth can-i create pods --as=system:serviceaccount:<namespace>:<sa-name>
kubectl auth can-i list services --as=system:serviceaccount:<namespace>:<sa-name>

# Test with specific namespace
kubectl auth can-i get pods --as=system:serviceaccount:<namespace>:<sa-name> -n <target-namespace>
```

## Common Issues and Solutions

### Issue 1: Missing Role Binding
**Cause**: Service account not bound to any role
**Solution**:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: default
subjects:
- kind: ServiceAccount
  name: limited-sa
  namespace: default
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

### Issue 2: Insufficient Role Permissions
**Cause**: Role doesn't include required permissions
**Solution**:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-manager
  namespace: default
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "create", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get", "list"]
```

### Issue 3: Wrong Namespace Scope
**Cause**: Using Role instead of ClusterRole for cluster-wide resources
**Solution**:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: node-reader
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: node-reader-binding
subjects:
- kind: ServiceAccount
  name: node-reader-sa
  namespace: default
roleRef:
  kind: ClusterRole
  name: node-reader
  apiGroup: rbac.authorization.k8s.io
```

### Issue 4: Service Account Not Specified
**Cause**: Pod using default service account without permissions
**Solution**:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  serviceAccountName: my-service-account
  containers:
  - name: app
    image: nginx
```

## EKS-Specific RBAC Issues

### AWS IAM Integration
```bash
# Check aws-auth ConfigMap
kubectl describe configmap aws-auth -n kube-system

# Add IAM user to aws-auth
kubectl edit configmap aws-auth -n kube-system
```

### IRSA (IAM Roles for Service Accounts)
```bash
# Check service account annotations
kubectl describe serviceaccount <sa-name>

# Verify OIDC provider
aws iam list-open-id-connect-providers

# Check IAM role trust policy
aws iam get-role --role-name <role-name>
```

## Debugging Commands

### Check Effective Permissions
```bash
# Create a debug pod with specific service account
kubectl run debug-pod --image=busybox --serviceaccount=<sa-name> --rm -it --restart=Never -- sh

# Inside the pod, test API access
wget -qO- --header="Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  https://kubernetes.default.svc/api/v1/namespaces/default/pods
```

### Audit RBAC
```bash
# Enable audit logging to see permission checks
# Check audit logs for permission denials
kubectl logs -n kube-system <api-server-pod> | grep -i forbidden
```

## Resolution Verification

1. Test the specific permission that was failing:
```bash
kubectl auth can-i <verb> <resource> --as=system:serviceaccount:<namespace>:<sa-name>
```

2. Verify the application works:
```bash
kubectl logs <pod-name>
```

3. Check that no forbidden errors occur:
```bash
kubectl get events --field-selector reason=Forbidden
```

## Prevention Tips

- Follow principle of least privilege
- Use namespaced roles when possible
- Regularly audit RBAC permissions
- Document service account purposes
- Use tools like `kubectl auth can-i` for testing
- Implement RBAC policies as code
- Monitor for permission escalation attempts
