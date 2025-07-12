#!/bin/bash

# EKS Cluster Cleanup Script
# This script safely removes the troubleshooting workshop cluster

set -e

# Configuration
CLUSTER_NAME="eks-troubleshooting-workshop"
REGION="us-west-2"

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

# Check if cluster exists
check_cluster_exists() {
    print_header "Checking if Cluster Exists"
    
    if eksctl get cluster --name $CLUSTER_NAME --region $REGION &> /dev/null; then
        print_success "Cluster $CLUSTER_NAME found"
        return 0
    else
        print_warning "Cluster $CLUSTER_NAME not found"
        return 1
    fi
}

# Clean up workshop resources first
cleanup_workshop_resources() {
    print_header "Cleaning Up Workshop Resources"
    
    # Clean up troubleshooting namespaces
    for ns in troubleshooting-pod-startup troubleshooting-dns troubleshooting-rbac; do
        if kubectl get namespace "$ns" &> /dev/null; then
            print_warning "Deleting namespace: $ns"
            kubectl delete namespace "$ns" --ignore-not-found=true --timeout=60s
        fi
    done
    
    # Clean up any test pods
    kubectl delete pod --all --timeout=60s || true
    
    print_success "Workshop resources cleaned up"
}

# Delete the cluster
delete_cluster() {
    print_header "Deleting EKS Cluster"
    
    print_warning "This will delete the entire EKS cluster and all associated resources."
    print_warning "This action cannot be undone!"
    echo ""
    echo "Cluster to delete: $CLUSTER_NAME"
    echo "Region: $REGION"
    echo ""
    read -p "Are you sure you want to delete the cluster? (yes/no): " confirm
    
    if [ "$confirm" != "yes" ]; then
        print_error "Cluster deletion cancelled"
        exit 1
    fi
    
    print_warning "Deleting cluster... This will take 10-15 minutes"
    
    if eksctl delete cluster --name $CLUSTER_NAME --region $REGION --wait; then
        print_success "Cluster deleted successfully"
    else
        print_error "Failed to delete cluster"
        echo "You may need to manually clean up resources in the AWS console"
        exit 1
    fi
}

# Clean up local files
cleanup_local_files() {
    print_header "Cleaning Up Local Files"
    
    # Remove backup files
    rm -f coredns-backup.yaml
    rm -f cluster-config.yaml
    rm -f cluster-autoscaler-autodiscover.yaml*
    
    # Remove generated files
    find . -name "*-backup.yaml" -delete 2>/dev/null || true
    find . -name "*-solutions-summary.md" -delete 2>/dev/null || true
    find . -name "*troubleshooting-guide.md" -delete 2>/dev/null || true
    
    print_success "Local files cleaned up"
}

# Show cost summary
show_cost_summary() {
    print_header "Cost Summary"
    
    echo "The following resources were deleted:"
    echo "• EKS Cluster (Control Plane)"
    echo "• EC2 Instances (Worker Nodes)"
    echo "• EBS Volumes"
    echo "• VPC and Networking Components"
    echo "• Load Balancers (if any)"
    echo ""
    echo "You should no longer incur charges for these resources."
    echo "Check your AWS billing dashboard to confirm."
}

# Main execution
main() {
    print_header "EKS Troubleshooting Workshop - Cluster Cleanup"
    
    if ! check_cluster_exists; then
        print_success "No cluster to clean up"
        cleanup_local_files
        exit 0
    fi
    
    # Try to clean up workshop resources first
    if kubectl cluster-info &> /dev/null; then
        cleanup_workshop_resources
    else
        print_warning "Cannot connect to cluster - skipping resource cleanup"
    fi
    
    delete_cluster
    cleanup_local_files
    show_cost_summary
    
    print_success "Cleanup completed successfully!"
    echo ""
    echo "Thank you for using the EKS Troubleshooting Workshop!"
}

# Help function
show_help() {
    echo "EKS Cluster Cleanup Script"
    echo ""
    echo "This script safely removes the troubleshooting workshop cluster and all associated resources."
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -f, --force    Skip confirmation prompts"
    echo "  -n, --name     Cluster name (default: $CLUSTER_NAME)"
    echo "  -r, --region   AWS region (default: $REGION)"
    echo ""
    echo "Examples:"
    echo "  $0                           # Interactive cleanup"
    echo "  $0 -f                        # Force cleanup without prompts"
    echo "  $0 -n my-cluster            # Cleanup specific cluster"
}

# Parse command line arguments
FORCE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -n|--name)
            CLUSTER_NAME="$2"
            shift 2
            ;;
        -r|--region)
            REGION="$2"
            shift 2
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Override confirmation if force flag is set
if [ "$FORCE" = true ]; then
    # Modify delete_cluster function to skip confirmation
    delete_cluster() {
        print_header "Deleting EKS Cluster (Force Mode)"
        print_warning "Deleting cluster... This will take 10-15 minutes"
        
        if eksctl delete cluster --name $CLUSTER_NAME --region $REGION --wait; then
            print_success "Cluster deleted successfully"
        else
            print_error "Failed to delete cluster"
            exit 1
        fi
    }
fi

main
