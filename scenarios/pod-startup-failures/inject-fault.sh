#!/bin/bash

# Enhanced Visual Fault Injection Script - Pod Startup Failures
# This script introduces various pod startup issues with visual feedback

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
BUG="🐛"
FIRE="🔥"
MAGNIFYING="🔍"

# Create namespace for the scenario
create_namespace() {
    print_header "Creating Scenario Namespace"
    kubectl create namespace troubleshooting-pod-startup --dry-run=client -o yaml | kubectl apply -f -
    print_success "Namespace 'troubleshooting-pod-startup' created"
}

# Inject Fault 1: Image Pull Error
inject_image_pull_fault() {
    print_header "Injecting Image Pull Fault"
    
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: broken-image-app
  namespace: troubleshooting-pod-startup
  labels:
    scenario: image-pull-error
spec:
  replicas: 2
  selector:
    matchLabels:
      app: broken-image-app
  template:
    metadata:
      labels:
        app: broken-image-app
    spec:
      containers:
      - name: web
        image: nginx:nonexistent-tag-12345
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
EOF

    print_warning "Deployed app with non-existent image tag"
}

# Inject Fault 2: Resource Constraints
inject_resource_fault() {
    print_header "Injecting Resource Constraint Fault"
    
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: resource-hungry-app
  namespace: troubleshooting-pod-startup
  labels:
    scenario: resource-constraint
spec:
  replicas: 1
  selector:
    matchLabels:
      app: resource-hungry-app
  template:
    metadata:
      labels:
        app: resource-hungry-app
    spec:
      containers:
      - name: hungry
        image: nginx:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "50Gi"
            cpu: "20"
          limits:
            memory: "50Gi"
            cpu: "20"
EOF

    print_warning "Deployed app with excessive resource requirements"
}

# Inject Fault 3: Missing Secret
inject_secret_fault() {
    print_header "Injecting Missing Secret Fault"
    
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secret-dependent-app
  namespace: troubleshooting-pod-startup
  labels:
    scenario: missing-secret
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secret-dependent-app
  template:
    metadata:
      labels:
        app: secret-dependent-app
    spec:
      containers:
      - name: app
        image: nginx:latest
        ports:
        - containerPort: 80
        env:
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: nonexistent-secret
              key: password
        - name: API_KEY
          valueFrom:
            secretKeyRef:
              name: missing-api-secret
              key: api-key
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
EOF

    print_warning "Deployed app with references to non-existent secrets"
}

# Inject Fault 4: Node Selector Issue
inject_node_selector_fault() {
    print_header "Injecting Node Selector Fault"
    
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-selector-app
  namespace: troubleshooting-pod-startup
  labels:
    scenario: node-selector-issue
spec:
  replicas: 2
  selector:
    matchLabels:
      app: node-selector-app
  template:
    metadata:
      labels:
        app: node-selector-app
    spec:
      nodeSelector:
        instance-type: gpu-optimized
        zone: nonexistent-zone
      containers:
      - name: app
        image: nginx:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
EOF

    print_warning "Deployed app with impossible node selector requirements"
}

# Inject Fault 5: Crash Loop
inject_crashloop_fault() {
    print_header "Injecting Crash Loop Fault"
    
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crashloop-app
  namespace: troubleshooting-pod-startup
  labels:
    scenario: crash-loop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: crashloop-app
  template:
    metadata:
      labels:
        app: crashloop-app
    spec:
      containers:
      - name: crasher
        image: busybox:latest
        command: ["sh", "-c"]
        args:
        - |
          echo "Starting application..."
          sleep 5
          echo "Application encountered an error!"
          exit 1
        resources:
          requests:
            memory: "32Mi"
            cpu: "25m"
          limits:
            memory: "64Mi"
            cpu: "50m"
EOF

    print_warning "Deployed app that crashes immediately after startup"
}

# Create troubleshooting guide
create_troubleshooting_guide() {
    print_header "Creating Troubleshooting Guide"
    
    cat > troubleshooting-guide.md << 'EOF'
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
EOF

    print_success "Troubleshooting guide created"
}

# Show current status
show_status() {
    print_header "Current Pod Status"
    echo "Checking pod status in 10 seconds..."
    sleep 10
    
    kubectl get pods -n troubleshooting-pod-startup -o wide
    
    echo -e "\nDeployment status:"
    kubectl get deployments -n troubleshooting-pod-startup
    
    echo -e "\nRecent events:"
    kubectl get events -n troubleshooting-pod-startup --sort-by=.metadata.creationTimestamp | tail -10
}

# Main execution
main() {
    print_header "Pod Startup Failures - Fault Injection"
    
    create_namespace
    inject_image_pull_fault
    inject_resource_fault
    inject_secret_fault
    inject_node_selector_fault
    inject_crashloop_fault
    create_troubleshooting_guide
    show_status
    
    print_success "Fault injection completed!"
    echo -e "\n${GREEN}What's been deployed:${NC}"
    echo "• 5 broken applications with different startup issues"
    echo "• All apps are in the 'troubleshooting-pod-startup' namespace"
    echo -e "\n${YELLOW}Your task:${NC}"
    echo "• Identify and fix each application"
    echo "• Get all pods to 'Running' status"
    echo -e "\n${BLUE}Start troubleshooting:${NC}"
    echo "• Read the troubleshooting-guide.md file"
    echo "• Use kubectl commands to investigate issues"
    echo "• Fix each deployment"
    echo -e "\n${RED}If you get stuck:${NC}"
    echo "• Run ./restore-cluster.sh to see the solutions"
}

main "$@"
