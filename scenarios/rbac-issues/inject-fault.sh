#!/bin/bash

# Enhanced Visual RBAC Fault Injection Script
# This script creates RBAC permission chaos with spectacular visual feedback

set -e

# Enhanced colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Visual elements
CHECKMARK="✅"
CROSSMARK="❌"
WARNING="⚠️"
ROCKET="🚀"
WRENCH="🔧"
LOCK="🔐"
KEY="🔑"
SHIELD="🛡️"
FORBIDDEN="🚫"
USER="👤"

# Utility functions for colored output
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

# Animated spinner function
show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "\r${BLUE}%c Working...${NC}" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf "\r"
}

# Visual progress function
show_progress() {
    local message=$1
    local duration=${2:-3}
    
    echo -e "${CYAN}$message${NC}"
    for i in $(seq 1 $duration); do
        printf "\r${BLUE}⠋ Working...${NC}"
        sleep 0.2
        printf "\r${BLUE}⠙ Working...${NC}"
        sleep 0.2
        printf "\r${BLUE}⠹ Working...${NC}"
        sleep 0.2
        printf "\r${BLUE}⠸ Working...${NC}"
        sleep 0.2
        printf "\r${BLUE}⠼ Working...${NC}"
        sleep 0.2
    done
    printf "\r"
}

# Create namespace for RBAC chaos
create_rbac_namespace() {
    print_header "Creating RBAC Chaos Arena"
    
    cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: troubleshooting-rbac
  labels:
    workshop: eks-troubleshooting
    scenario: rbac-issues
EOF

    show_progress "Setting up RBAC troubleshooting environment" 2
    print_success "RBAC chaos namespace created successfully!"
}

# Deploy applications that will suffer from RBAC issues
deploy_rbac_victims() {
    print_header "Deploying RBAC Victim Applications"
    
    echo -e "${YELLOW}${BOLD}▶ Creating applications that will suffer from permission failures...${NC}"
    
    # Service Account Reader App (will fail to read secrets)
    cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: secret-reader
  namespace: troubleshooting-rbac
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secret-reader-app
  namespace: troubleshooting-rbac
  labels:
    app: secret-reader
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secret-reader
  template:
    metadata:
      labels:
        app: secret-reader
    spec:
      serviceAccountName: secret-reader
      containers:
      - name: reader
        image: bitnami/kubectl:latest
        command: ["/bin/sh"]
        args: ["-c", "while true; do kubectl get secrets -n troubleshooting-rbac; sleep 30; done"]
---
apiVersion: v1
kind: Secret
metadata:
  name: super-secret
  namespace: troubleshooting-rbac
type: Opaque
data:
  password: c3VwZXJzZWNyZXRwYXNzd29yZA==
EOF

    # Pod Creator App (will fail to create pods)
    cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pod-creator
  namespace: troubleshooting-rbac
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pod-creator-app
  namespace: troubleshooting-rbac
  labels:
    app: pod-creator
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pod-creator
  template:
    metadata:
      labels:
        app: pod-creator
    spec:
      serviceAccountName: pod-creator
      containers:
      - name: creator
        image: bitnami/kubectl:latest
        command: ["/bin/sh"]
        args: ["-c", "while true; do kubectl run test-pod-\$RANDOM --image=nginx --restart=Never -n troubleshooting-rbac || true; sleep 60; done"]
EOF

    # Service Lister App (will fail to list services)
    cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: service-lister
  namespace: troubleshooting-rbac
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-lister-app
  namespace: troubleshooting-rbac
  labels:
    app: service-lister
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-lister
  template:
    metadata:
      labels:
        app: service-lister
    spec:
      serviceAccountName: service-lister
      containers:
      - name: lister
        image: bitnami/kubectl:latest
        command: ["/bin/sh"]
        args: ["-c", "while true; do kubectl get services -n troubleshooting-rbac; sleep 45; done"]
EOF

    show_progress "Deploying RBAC victim applications" 3
    print_success "RBAC victim applications deployed and ready to suffer!"
}

# Create broken RBAC configurations
inject_rbac_faults() {
    print_header "Injecting RBAC Permission Chaos"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │                RBAC PERMISSION DESTRUCTION                   │
    │                                                             │
    │  Before: Working Service Accounts ✅                       │
    │  After:  Broken Permissions ❌                             │
    │                                                             │
    │  Issues Injected:                                           │
    │  ├─ Missing Role Bindings                                   │
    │  ├─ Incorrect Resource Permissions                          │
    │  ├─ Wrong Namespace Scope                                   │
    │  └─ Service Account Misconfigurations                       │
    │                                                             │
    │  Result: Applications fail with 403 Forbidden! 🚫          │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    # Create intentionally broken roles and role bindings
    echo -e "${YELLOW}${BOLD}▶ Creating broken RBAC configurations...${NC}"
    
    # Broken Role 1: Secret reader with wrong permissions
    cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: troubleshooting-rbac
  name: broken-secret-reader
rules:
- apiGroups: [""]
  resources: ["configmaps"]  # Wrong resource! Should be "secrets"
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: broken-secret-reader-binding
  namespace: troubleshooting-rbac
subjects:
- kind: ServiceAccount
  name: secret-reader
  namespace: troubleshooting-rbac
roleRef:
  kind: Role
  name: broken-secret-reader
  apiGroup: rbac.authorization.k8s.io
EOF

    # Broken Role 2: Pod creator with insufficient permissions
    cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: troubleshooting-rbac
  name: broken-pod-creator
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]  # Missing "create" verb!
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: broken-pod-creator-binding
  namespace: troubleshooting-rbac
subjects:
- kind: ServiceAccount
  name: pod-creator
  namespace: troubleshooting-rbac
roleRef:
  kind: Role
  name: broken-pod-creator
  apiGroup: rbac.authorization.k8s.io
EOF

    # Missing Role Binding for service-lister (no permissions at all!)
    cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: troubleshooting-rbac
  name: service-lister-role
rules:
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get", "list"]
# Note: RoleBinding is intentionally missing!
EOF

    show_progress "Injecting RBAC permission chaos" 3
    print_error "RBAC permissions thoroughly broken! Applications will fail with 403 Forbidden!"
}

# Create troubleshooting guide
create_rbac_guide() {
    print_header "Creating RBAC Troubleshooting Guide"
    
    cat > rbac-troubleshooting-guide.md << 'EOF'
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
EOF

    show_progress "Creating comprehensive RBAC troubleshooting guide" 2
    print_success "RBAC troubleshooting guide created!"
}

# Show current RBAC status
show_rbac_status() {
    print_header "RBAC Chaos Dashboard"
    
    echo -e "${RED}${BOLD}Monitoring RBAC permission failures...${NC}"
    show_progress "Letting RBAC chaos reach maximum entropy" 3
    
    echo -e "\n${YELLOW}${BOLD}🔐 RBAC INFRASTRUCTURE STATUS:${NC}\n"
    
    echo -e "${CYAN}Service Accounts:${NC}"
    kubectl get serviceaccounts -n troubleshooting-rbac
    
    echo -e "\n${CYAN}Roles:${NC}"
    kubectl get roles -n troubleshooting-rbac
    
    echo -e "\n${CYAN}Role Bindings:${NC}"
    kubectl get rolebindings -n troubleshooting-rbac
    
    echo -e "\n${CYAN}Application Pods:${NC}"
    kubectl get pods -n troubleshooting-rbac
    
    echo -e "\n${RED}${BOLD}⚠️  RECENT RBAC DISASTERS:${NC}\n"
    kubectl get events -n troubleshooting-rbac --sort-by='.lastTimestamp' | tail -10
}

# Main execution function
main() {
    clear
    echo -e "${PURPLE}${BOLD}"
    cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    🔐 RBAC PERMISSION NIGHTMARE 🔐                                          ║
║                                                                              ║
║    Prepare for total permission chaos! Nothing will be allowed! 🚫          ║
║                                                                              ║
║    Your mission: Restore order to the RBAC universe! 🚀                    ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

EOF
    echo -e "${NC}"

    echo -e "${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  🏗️  INITIALIZING RBAC CHAOS CHAMBER${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    create_rbac_namespace
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  🎯 DEPLOYING RBAC VICTIM APPLICATIONS${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    deploy_rbac_victims
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  💥 INJECTING RBAC PERMISSION CHAOS${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    inject_rbac_faults
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  📚 CREATING RBAC TROUBLESHOOTING GUIDE${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    create_rbac_guide
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  📊 RBAC CHAOS DASHBOARD${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    show_rbac_status
    
    echo -e "\n${BLUE}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}${BOLD}║  🎯 RBAC RESCUE MISSION BRIEFING${NC}"
    echo -e "${BLUE}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    echo -e "${BLUE}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │                    RBAC ARCHITECTURE                        │
    │                                                             │
    │  ServiceAccount ──→ RoleBinding ──→ Role ──→ Resources     │
    │       │                  │           │          │          │
    │       │                  │           │          │          │
    │       └──Identity─────────┴──Binding──┴─Permissions────────┘ │
    │                                                             │
    │  🎯 Target: Break every link in this chain! 💥            │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    echo -e "${YELLOW}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │                    MISSION OBJECTIVES                       │
    │                                                             │
    │  🔧 Fix secret reader role permissions                     │
    │  🔑 Add missing verbs to pod creator role                  │
    │  🔗 Create missing role binding for service lister        │
    │  🧪 Test permissions with kubectl auth can-i              │
    │  ✅ Verify all applications work without 403 errors       │
    │                                                             │
    │  Success: All RBAC permissions working correctly! 🎉      │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    echo -e "${GREEN}${BOLD}🚀 READY TO RESTORE RBAC ORDER?${NC}"
    echo -e "${CYAN}1. Read the rbac-troubleshooting-guide.md${NC}"
    echo -e "${CYAN}2. Check current RBAC configurations${NC}"
    echo -e "${CYAN}3. Fix roles, role bindings, and permissions${NC}"
    echo -e "${CYAN}4. Test with kubectl auth can-i commands${NC}"
    echo -e "${CYAN}5. Celebrate when all permissions work! 🎉${NC}"
    
    echo -e "\n${RED}${BOLD}🆘 EMERGENCY RESTORATION: ./restore-cluster.sh${NC}"
    
    echo -e "\n${RED}${BOLD}🔥 RBAC NIGHTMARE COMPLETE! 🔥${NC}"
    echo -e "${PURPLE}${BOLD}The permission universe is in chaos! Time to restore order! 🔐${NC}"
}

# Run main function
main "$@"
