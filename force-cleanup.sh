#!/bin/bash

# Force Cleanup Script for EKS Troubleshooting Workshop
# Handles stuck namespaces and ensures clean environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Function to force delete a stuck namespace
force_delete_namespace() {
    local namespace=$1
    
    print_header "Force deleting namespace: $namespace"
    
    # Check if namespace exists
    if ! kubectl get namespace "$namespace" &>/dev/null; then
        print_success "Namespace $namespace does not exist"
        return 0
    fi
    
    # Check if namespace is stuck in Terminating state
    local status=$(kubectl get namespace "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
    
    if [[ "$status" == "Terminating" ]]; then
        print_warning "Namespace $namespace is stuck in Terminating state"
        
        # Create a clean namespace spec without finalizers
        cat > /tmp/ns-clean.json << EOF
{
    "apiVersion": "v1",
    "kind": "Namespace",
    "metadata": {
        "name": "$namespace"
    },
    "spec": {
        "finalizers": []
    }
}
EOF
        
        # Force finalize the namespace
        if kubectl replace --raw "/api/v1/namespaces/$namespace/finalize" -f /tmp/ns-clean.json &>/dev/null; then
            print_success "Successfully force-deleted namespace $namespace"
        else
            print_error "Failed to force-delete namespace $namespace"
        fi
        
        # Clean up temp file
        rm -f /tmp/ns-clean.json
    else
        # Try normal deletion first
        if kubectl delete namespace "$namespace" --timeout=30s &>/dev/null; then
            print_success "Successfully deleted namespace $namespace"
        else
            print_warning "Normal deletion failed, trying force delete..."
            kubectl delete namespace "$namespace" --force --grace-period=0 &>/dev/null || true
            sleep 2
            
            # If still exists, use the force method
            if kubectl get namespace "$namespace" &>/dev/null; then
                force_delete_namespace "$namespace"
            fi
        fi
    fi
}

# Main cleanup function
main() {
    print_header "EKS Troubleshooting Workshop - Force Cleanup"
    
    # List of workshop namespaces
    NAMESPACES=(
        "troubleshooting-pod-startup"
        "troubleshooting-dns"
        "troubleshooting-rbac"
        "troubleshooting-node"
        "troubleshooting-registry"
    )
    
    # Force delete each namespace
    for ns in "${NAMESPACES[@]}"; do
        force_delete_namespace "$ns"
    done
    
    # Clean up any workshop-related resources in default namespace
    print_header "Cleaning up default namespace resources"
    kubectl delete pods,deployments,services,configmaps,secrets -l workshop=eks-troubleshooting --ignore-not-found=true
    
    print_success "Force cleanup completed!"
    print_header "Cluster Status"
    kubectl get namespaces | grep -E "(troubleshooting|NAME)" || print_success "No troubleshooting namespaces found"
}

# Run main function
main "$@"
