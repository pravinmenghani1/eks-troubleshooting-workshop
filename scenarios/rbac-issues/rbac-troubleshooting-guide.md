# 🔐 RBAC Permission Nightmare - Troubleshooting Guide

## 🎯 Mission Objective
Fix all RBAC permission issues and get applications working properly!

## 🚨 Current Issues

### 1. Secret Reader App Failures
- **Symptom**: Cannot read secrets in the namespace
- **Error**: `secrets is forbidden: User "system:serviceaccount:troubleshooting-rbac:secret-reader" cannot list resource "secrets"`
- **Root Cause**: Role has wrong resource permissions (configmaps instead of secrets)

### 2. Pod Creator App Failures  
- **Symptom**: Cannot create pods
- **Error**: `pods is forbidden: User "system:serviceaccount:troubleshooting-rbac:pod-creator" cannot create resource "pods"`
- **Root Cause**: Role missing "create" verb for pods

### 3. Service Lister App Failures
- **Symptom**: Cannot list services
- **Error**: `services is forbidden: User "system:serviceaccount:troubleshooting-rbac:service-lister" cannot list resource "services"`
- **Root Cause**: Missing RoleBinding entirely

## 🔍 Troubleshooting Commands

### Check Service Accounts
```bash
kubectl get serviceaccounts -n troubleshooting-rbac
```

### Check Roles
```bash
kubectl get roles -n troubleshooting-rbac
kubectl describe role <role-name> -n troubleshooting-rbac
```

### Check Role Bindings
```bash
kubectl get rolebindings -n troubleshooting-rbac
kubectl describe rolebinding <binding-name> -n troubleshooting-rbac
```

### Check Pod Logs for Permission Errors
```bash
kubectl logs -l app=secret-reader -n troubleshooting-rbac
kubectl logs -l app=pod-creator -n troubleshooting-rbac
kubectl logs -l app=service-lister -n troubleshooting-rbac
```

### Test Permissions Manually
```bash
kubectl auth can-i get secrets --as=system:serviceaccount:troubleshooting-rbac:secret-reader -n troubleshooting-rbac
kubectl auth can-i create pods --as=system:serviceaccount:troubleshooting-rbac:pod-creator -n troubleshooting-rbac
kubectl auth can-i list services --as=system:serviceaccount:troubleshooting-rbac:service-lister -n troubleshooting-rbac
```

## 🔧 Fixes Needed

### Fix 1: Correct Secret Reader Role
```bash
kubectl patch role broken-secret-reader -n troubleshooting-rbac --type='json' -p='[{"op": "replace", "path": "/rules/0/resources", "value": ["secrets"]}]'
```

### Fix 2: Add Create Permission to Pod Creator Role
```bash
kubectl patch role broken-pod-creator -n troubleshooting-rbac --type='json' -p='[{"op": "add", "path": "/rules/0/verbs/-", "value": "create"}]'
```

### Fix 3: Create Missing RoleBinding for Service Lister
```bash
kubectl create rolebinding service-lister-binding \
  --role=service-lister-role \
  --serviceaccount=troubleshooting-rbac:service-lister \
  -n troubleshooting-rbac
```

## ✅ Success Criteria
- All pod logs show successful operations (no 403 errors)
- `kubectl auth can-i` commands return "yes" for all service accounts
- Applications can perform their intended operations

## 🆘 Emergency Reset
If you get completely stuck, run:
```bash
./restore-cluster.sh
```
