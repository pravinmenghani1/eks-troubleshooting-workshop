#!/bin/bash

# Enhanced Visual Image Registry Fault Injection Script
# This script creates image registry chaos with spectacular visual feedback

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
PACKAGE="📦"
REGISTRY="🏪"
LOCK="🔐"
NETWORK="🌐"
BROKEN="💥"

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

# Create namespace for image registry chaos
create_registry_namespace() {
    print_header "Creating Image Registry Chaos Arena"
    
    cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: troubleshooting-registry
  labels:
    workshop: eks-troubleshooting
    scenario: image-pull-errors
EOF

    show_progress "Setting up image registry troubleshooting environment" 2
    print_success "Image registry chaos namespace created successfully!"
}

# Inject Fault 1: Non-existent image
inject_nonexistent_image_fault() {
    print_header "Fault 1: Non-existent Image Chaos"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │                NON-EXISTENT IMAGE DISASTER                   │
    │                                                             │
    │  Image: nonexistent/fake-app:v999.999.999                  │
    │  Registry: Docker Hub                                       │
    │  Status: Does not exist! 💀                                │
    │                                                             │
    │  Result: ImagePullBackOff forever! 🔄                      │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nonexistent-image-app
  namespace: troubleshooting-registry
  labels:
    app: nonexistent-image
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nonexistent-image
  template:
    metadata:
      labels:
        app: nonexistent-image
    spec:
      containers:
      - name: fake-app
        image: nonexistent/fake-app:v999.999.999
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
EOF

    show_progress "Deploying non-existent image application" 2
    print_error "Non-existent image deployed! ImagePullBackOff incoming!"
}

# Inject Fault 2: Private registry without credentials
inject_private_registry_fault() {
    print_header "Fault 2: Private Registry Authentication Failure"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │              PRIVATE REGISTRY ACCESS DENIED                  │
    │                                                             │
    │  Registry: private-registry.example.com                     │
    │  Image: private-registry.example.com/secret-app:latest      │
    │  Credentials: Missing! 🔐❌                                 │
    │                                                             │
    │  Result: Pull access denied! 🚫                            │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: private-registry-app
  namespace: troubleshooting-registry
  labels:
    app: private-registry
spec:
  replicas: 1
  selector:
    matchLabels:
      app: private-registry
  template:
    metadata:
      labels:
        app: private-registry
    spec:
      containers:
      - name: secret-app
        image: private-registry.example.com/secret-app:latest
        ports:
        - containerPort: 3000
        env:
        - name: SECRET_KEY
          value: "super-secret-key"
EOF

    show_progress "Deploying private registry application without credentials" 2
    print_error "Private registry app deployed without authentication! Access denied!"
}

# Inject Fault 3: Wrong image tag
inject_wrong_tag_fault() {
    print_header "Fault 3: Wrong Image Tag Catastrophe"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │                  WRONG IMAGE TAG CHAOS                       │
    │                                                             │
    │  Image: nginx:nonexistent-tag-v999                          │
    │  Registry: Docker Hub                                       │
    │  Tag Status: Does not exist! 🏷️❌                          │
    │                                                             │
    │  Result: Tag not found error! 🔍❌                          │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wrong-tag-app
  namespace: troubleshooting-registry
  labels:
    app: wrong-tag
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wrong-tag
  template:
    metadata:
      labels:
        app: wrong-tag
    spec:
      containers:
      - name: nginx-wrong-tag
        image: nginx:nonexistent-tag-v999
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "32Mi"
            cpu: "100m"
EOF

    show_progress "Deploying application with wrong image tag" 2
    print_error "Wrong tag application deployed! Tag not found error incoming!"
}

# Inject Fault 4: Corrupted image pull secret
inject_corrupted_secret_fault() {
    print_header "Fault 4: Corrupted Image Pull Secret"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │               CORRUPTED PULL SECRET DISASTER                 │
    │                                                             │
    │  Secret: corrupted-registry-secret                          │
    │  Content: Invalid base64 data 💀                           │
    │  Registry: ghcr.io                                          │
    │                                                             │
    │  Result: Authentication failure! 🔐💥                       │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    # Create a corrupted image pull secret
    cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: corrupted-registry-secret
  namespace: troubleshooting-registry
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: aW52YWxpZC1iYXNlNjQtZGF0YQ==  # Invalid base64 data
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: corrupted-secret-app
  namespace: troubleshooting-registry
  labels:
    app: corrupted-secret
spec:
  replicas: 1
  selector:
    matchLabels:
      app: corrupted-secret
  template:
    metadata:
      labels:
        app: corrupted-secret
    spec:
      imagePullSecrets:
      - name: corrupted-registry-secret
      containers:
      - name: github-app
        image: ghcr.io/nonexistent/private-app:latest
        ports:
        - containerPort: 8000
EOF

    show_progress "Deploying application with corrupted image pull secret" 2
    print_error "Corrupted secret deployed! Authentication will fail spectacularly!"
}

# Inject Fault 5: Network connectivity issues (simulated)
inject_network_fault() {
    print_header "Fault 5: Registry Network Connectivity Issues"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │              REGISTRY NETWORK ISOLATION                      │
    │                                                             │
    │  Registry: unreachable-registry.internal                    │
    │  Network: Isolated/Unreachable 🌐❌                        │
    │  DNS: May resolve but connection fails                      │
    │                                                             │
    │  Result: Network timeout errors! ⏰💥                       │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: network-isolated-app
  namespace: troubleshooting-registry
  labels:
    app: network-isolated
spec:
  replicas: 1
  selector:
    matchLabels:
      app: network-isolated
  template:
    metadata:
      labels:
        app: network-isolated
    spec:
      containers:
      - name: isolated-app
        image: unreachable-registry.internal/app:latest
        ports:
        - containerPort: 9000
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
EOF

    show_progress "Deploying application from unreachable registry" 2
    print_error "Network isolated app deployed! Connection timeouts expected!"
}

# Create troubleshooting guide
create_registry_guide() {
    print_header "Creating Image Registry Troubleshooting Guide"
    
    cat > image-registry-troubleshooting-guide.md << 'EOF'
# 📦 Image Registry Disasters - Troubleshooting Guide

## 🎯 Mission Objective
Fix all image registry issues and get applications pulling images successfully!

## 🚨 Current Issues

### 1. Non-existent Image (nonexistent-image-app)
- **Symptom**: ImagePullBackOff status
- **Error**: `Failed to pull image "nonexistent/fake-app:v999.999.999": rpc error: code = NotFound`
- **Root Cause**: Image does not exist in any registry

### 2. Private Registry Access Denied (private-registry-app)
- **Symptom**: ImagePullBackOff with authentication error
- **Error**: `pull access denied for private-registry.example.com/secret-app`
- **Root Cause**: Missing image pull secrets for private registry

### 3. Wrong Image Tag (wrong-tag-app)
- **Symptom**: ImagePullBackOff status
- **Error**: `manifest for nginx:nonexistent-tag-v999 not found`
- **Root Cause**: Specified tag does not exist

### 4. Corrupted Image Pull Secret (corrupted-secret-app)
- **Symptom**: ImagePullBackOff with secret error
- **Error**: `couldn't parse image pull secrets`
- **Root Cause**: Invalid base64 data in dockerconfigjson

### 5. Network Connectivity Issues (network-isolated-app)
- **Symptom**: ImagePullBackOff with timeout
- **Error**: `dial tcp: lookup unreachable-registry.internal: no such host`
- **Root Cause**: Registry is unreachable or doesn't exist

## 🔍 Troubleshooting Commands

### Check Pod Status and Events
```bash
kubectl get pods -n troubleshooting-registry
kubectl describe pod <pod-name> -n troubleshooting-registry
kubectl get events -n troubleshooting-registry --sort-by='.lastTimestamp'
```

### Check Image Pull Secrets
```bash
kubectl get secrets -n troubleshooting-registry
kubectl describe secret <secret-name> -n troubleshooting-registry
```

### Check Deployment Configurations
```bash
kubectl get deployments -n troubleshooting-registry -o yaml
kubectl describe deployment <deployment-name> -n troubleshooting-registry
```

### Test Image Availability Manually
```bash
docker pull <image-name>  # Test locally if possible
```

## 🔧 Fixes Needed

### Fix 1: Replace Non-existent Image
```bash
kubectl patch deployment nonexistent-image-app -n troubleshooting-registry \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"fake-app","image":"nginx:latest"}]}}}}'
```

### Fix 2: Create Valid Image Pull Secret for Private Registry
```bash
# Since private-registry.example.com doesn't exist, change to a public image
kubectl patch deployment private-registry-app -n troubleshooting-registry \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"secret-app","image":"nginx:latest"}]}}}}'
```

### Fix 3: Correct the Image Tag
```bash
kubectl patch deployment wrong-tag-app -n troubleshooting-registry \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx-wrong-tag","image":"nginx:latest"}]}}}}'
```

### Fix 4: Fix Corrupted Image Pull Secret
```bash
# Remove the corrupted secret and change to public image
kubectl delete secret corrupted-registry-secret -n troubleshooting-registry
kubectl patch deployment corrupted-secret-app -n troubleshooting-registry \
  -p '{"spec":{"template":{"spec":{"imagePullSecrets":null,"containers":[{"name":"github-app","image":"nginx:latest"}]}}}}'
```

### Fix 5: Fix Network Connectivity Issue
```bash
kubectl patch deployment network-isolated-app -n troubleshooting-registry \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"isolated-app","image":"nginx:latest"}]}}}}'
```

## 🎓 Advanced Solutions

### Create a Valid Image Pull Secret (for real private registries)
```bash
kubectl create secret docker-registry my-registry-secret \
  --docker-server=<registry-server> \
  --docker-username=<username> \
  --docker-password=<password> \
  --docker-email=<email> \
  -n troubleshooting-registry
```

### Use Image Pull Secret in Deployment
```yaml
spec:
  template:
    spec:
      imagePullSecrets:
      - name: my-registry-secret
      containers:
      - name: app
        image: private-registry.com/app:latest
```

## ✅ Success Criteria
- All pods show "Running" status
- No ImagePullBackOff errors in pod descriptions
- All deployments show READY replicas matching desired count

## 🆘 Emergency Reset
If you get completely stuck, run:
```bash
./restore-cluster.sh
```

## 💡 Learning Points
- Always verify image names and tags exist
- Private registries require proper authentication
- Image pull secrets must contain valid dockerconfigjson data
- Network connectivity to registries is essential
- Use `kubectl describe pod` to see detailed error messages
EOF

    show_progress "Creating comprehensive image registry troubleshooting guide" 2
    print_success "Image registry troubleshooting guide created!"
}

# Show current registry status
show_registry_status() {
    print_header "Image Registry Chaos Dashboard"
    
    echo -e "${RED}${BOLD}Monitoring image registry disasters...${NC}"
    show_progress "Letting registry chaos reach maximum entropy" 3
    
    echo -e "\n${YELLOW}${BOLD}📦 IMAGE REGISTRY INFRASTRUCTURE STATUS:${NC}\n"
    
    echo -e "${CYAN}Deployments:${NC}"
    kubectl get deployments -n troubleshooting-registry
    
    echo -e "\n${CYAN}Pods (showing image pull failures):${NC}"
    kubectl get pods -n troubleshooting-registry
    
    echo -e "\n${CYAN}Image Pull Secrets:${NC}"
    kubectl get secrets -n troubleshooting-registry
    
    echo -e "\n${RED}${BOLD}⚠️  RECENT REGISTRY DISASTERS:${NC}\n"
    kubectl get events -n troubleshooting-registry --sort-by='.lastTimestamp' | tail -15
}

# Main execution function
main() {
    clear
    echo -e "${PURPLE}${BOLD}"
    cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    📦 IMAGE REGISTRY DISASTERS 📦                                           ║
║                                                                              ║
║    Prepare for total image pull chaos! Nothing will download! 💥            ║
║                                                                              ║
║    Your mission: Restore order to the registry universe! 🚀                ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

EOF
    echo -e "${NC}"

    echo -e "${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  🏗️  INITIALIZING REGISTRY CHAOS CHAMBER${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    create_registry_namespace
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  💥 FAULT #1: NON-EXISTENT IMAGE CHAOS${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    inject_nonexistent_image_fault
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  🔐 FAULT #2: PRIVATE REGISTRY ACCESS DENIED${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    inject_private_registry_fault
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  🏷️  FAULT #3: WRONG IMAGE TAG CATASTROPHE${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    inject_wrong_tag_fault
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  💀 FAULT #4: CORRUPTED IMAGE PULL SECRET${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    inject_corrupted_secret_fault
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  🌐 FAULT #5: NETWORK CONNECTIVITY CHAOS${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    inject_network_fault
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  📚 CREATING REGISTRY TROUBLESHOOTING GUIDE${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    create_registry_guide
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  📊 REGISTRY CHAOS DASHBOARD${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    show_registry_status
    
    echo -e "\n${BLUE}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}${BOLD}║  🎯 REGISTRY RESCUE MISSION BRIEFING${NC}"
    echo -e "${BLUE}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    echo -e "${YELLOW}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │                    MISSION OBJECTIVES                       │
    │                                                             │
    │  🔧 Fix non-existent image references                      │
    │  🔐 Resolve private registry authentication                │
    │  🏷️  Correct wrong image tags                              │
    │  💀 Fix corrupted image pull secrets                       │
    │  🌐 Resolve network connectivity issues                    │
    │                                                             │
    │  Success: All pods Running with successful image pulls! 🎉 │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    echo -e "${GREEN}${BOLD}🚀 READY TO RESTORE REGISTRY ORDER?${NC}"
    echo -e "${CYAN}1. Read the image-registry-troubleshooting-guide.md${NC}"
    echo -e "${CYAN}2. Check pod statuses and error messages${NC}"
    echo -e "${CYAN}3. Fix image references and authentication${NC}"
    echo -e "${CYAN}4. Verify all pods reach Running status${NC}"
    echo -e "${CYAN}5. Celebrate when all images pull successfully! 🎉${NC}"
    
    echo -e "\n${RED}${BOLD}🆘 EMERGENCY RESTORATION: ./restore-cluster.sh${NC}"
    
    echo -e "\n${RED}${BOLD}🔥 REGISTRY DISASTERS COMPLETE! 🔥${NC}"
    echo -e "${PURPLE}${BOLD}The image registry universe is in chaos! Time to restore order! 📦${NC}"
}

# Run main function
main "$@"
