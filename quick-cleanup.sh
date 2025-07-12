#!/bin/bash

# Quick Cleanup Script - Uses the working method for stuck namespaces
# This addresses the EKS metrics API discovery issue

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Quick namespace deletion using API method
quick_delete_namespace() {
    local namespace=$1
    
    if kubectl get namespace "$namespace" &>/dev/null; then
        print_warning "Deleting namespace: $namespace"
        
        # Use the API method that works with stuck namespaces
        kubectl get namespace "$namespace" -o json | jq '.spec.finalizers = []' | kubectl replace --raw "/api/v1/namespaces/$namespace/finalize" -f - &>/dev/null || true
        
        # Wait a moment and check
        sleep 2
        if ! kubectl get namespace "$namespace" &>/dev/null; then
            print_success "Namespace $namespace deleted"
        else
            print_warning "Namespace $namespace may still be terminating"
        fi
    else
        print_success "Namespace $namespace already deleted"
    fi
}

# Main cleanup
print_header "Quick Workshop Cleanup"

NAMESPACES=(
    "troubleshooting-pod-startup"
    "troubleshooting-dns"
    "troubleshooting-rbac"
    "troubleshooting-node"
    "troubleshooting-registry"
)

for ns in "${NAMESPACES[@]}"; do
    quick_delete_namespace "$ns"
done

print_success "Quick cleanup completed!"
