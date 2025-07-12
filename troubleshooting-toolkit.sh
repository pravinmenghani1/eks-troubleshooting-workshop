#!/bin/bash

# EKS Troubleshooting Toolkit
# This script provides common troubleshooting commands for EKS issues

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Function to check if kubectl is available
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed or not in PATH"
        exit 1
    fi
    print_success "kubectl is available"
}

# Function to check cluster connectivity
check_cluster_connectivity() {
    print_header "Checking Cluster Connectivity"
    
    if kubectl cluster-info &> /dev/null; then
        print_success "Connected to Kubernetes cluster"
        kubectl cluster-info
    else
        print_error "Cannot connect to Kubernetes cluster"
        return 1
    fi
}

# Function to check node status
check_nodes() {
    print_header "Node Status"
    
    echo "Node overview:"
    kubectl get nodes -o wide
    
    echo -e "\nNode conditions:"
    kubectl get nodes -o custom-columns=NAME:.metadata.name,STATUS:.status.conditions[-1].type,REASON:.status.conditions[-1].reason
    
    # Check for NotReady nodes
    NOT_READY=$(kubectl get nodes --no-headers | grep -v " Ready " | wc -l)
    if [ "$NOT_READY" -gt 0 ]; then
        print_warning "$NOT_READY node(s) are not ready"
        kubectl get nodes | grep -v " Ready "
    else
        print_success "All nodes are ready"
    fi
}

# Function to check pod status
check_pods() {
    print_header "Pod Status Overview"
    
    echo "Pods by namespace:"
    kubectl get pods --all-namespaces -o wide
    
    echo -e "\nProblem pods:"
    kubectl get pods --all-namespaces --field-selector=status.phase!=Running,status.phase!=Succeeded
    
    echo -e "\nRecent events:"
    kubectl get events --sort-by=.metadata.creationTimestamp --all-namespaces | tail -10
}

# Function to check system pods
check_system_pods() {
    print_header "System Pods Status"
    
    echo "kube-system pods:"
    kubectl get pods -n kube-system
    
    echo -e "\nCritical system components:"
    kubectl get pods -n kube-system -l component=kube-apiserver,component=kube-controller-manager,component=kube-scheduler,k8s-app=kube-dns
}

# Function to check DNS
check_dns() {
    print_header "DNS Resolution Check"
    
    echo "CoreDNS pods:"
    kubectl get pods -n kube-system -l k8s-app=kube-dns
    
    echo -e "\nTesting DNS resolution:"
    kubectl run dns-test --image=busybox --rm -it --restart=Never -- nslookup kubernetes.default.svc.cluster.local || print_warning "DNS test failed"
}

# Function to check resource usage
check_resources() {
    print_header "Resource Usage"
    
    if kubectl top nodes &> /dev/null; then
        echo "Node resource usage:"
        kubectl top nodes
        
        echo -e "\nPod resource usage (top 10):"
        kubectl top pods --all-namespaces | head -11
    else
        print_warning "Metrics server not available - cannot show resource usage"
    fi
}

# Function to check storage
check_storage() {
    print_header "Storage Status"
    
    echo "Persistent Volumes:"
    kubectl get pv
    
    echo -e "\nPersistent Volume Claims:"
    kubectl get pvc --all-namespaces
    
    echo -e "\nStorage Classes:"
    kubectl get storageclass
}

# Function to check networking
check_networking() {
    print_header "Networking Status"
    
    echo "Services:"
    kubectl get svc --all-namespaces
    
    echo -e "\nIngresses:"
    kubectl get ingress --all-namespaces
    
    echo -e "\nNetwork Policies:"
    kubectl get networkpolicy --all-namespaces
}

# Function to check RBAC
check_rbac() {
    print_header "RBAC Configuration"
    
    echo "Service Accounts:"
    kubectl get serviceaccounts --all-namespaces
    
    echo -e "\nRoles and ClusterRoles (sample):"
    kubectl get roles,clusterroles | head -10
    
    echo -e "\nRole Bindings (sample):"
    kubectl get rolebindings,clusterrolebindings --all-namespaces | head -10
}

# Function to run specific troubleshooting scenario
run_scenario() {
    local scenario=$1
    case $scenario in
        "pod-startup")
            print_header "Pod Startup Troubleshooting"
            kubectl get pods --field-selector=status.phase!=Running
            kubectl describe pods --field-selector=status.phase!=Running
            ;;
        "dns")
            check_dns
            kubectl run dns-debug --image=busybox --rm -it --restart=Never -- sh
            ;;
        "rbac")
            check_rbac
            echo -e "\nTest permissions with: kubectl auth can-i <verb> <resource> --as=<user>"
            ;;
        "nodes")
            check_nodes
            kubectl describe nodes
            ;;
        *)
            print_error "Unknown scenario: $scenario"
            echo "Available scenarios: pod-startup, dns, rbac, nodes"
            ;;
    esac
}

# Main function
main() {
    print_header "EKS Troubleshooting Toolkit"
    
    # Check prerequisites
    check_kubectl
    
    if [ $# -eq 0 ]; then
        # Run full health check
        check_cluster_connectivity
        check_nodes
        check_system_pods
        check_pods
        check_dns
        check_resources
        check_storage
        check_networking
        check_rbac
    else
        # Run specific scenario
        run_scenario $1
    fi
}

# Help function
show_help() {
    echo "EKS Troubleshooting Toolkit"
    echo ""
    echo "Usage: $0 [scenario]"
    echo ""
    echo "Without arguments: Run full cluster health check"
    echo ""
    echo "Available scenarios:"
    echo "  pod-startup  - Troubleshoot pod startup issues"
    echo "  dns          - Troubleshoot DNS resolution"
    echo "  rbac         - Troubleshoot RBAC permissions"
    echo "  nodes        - Troubleshoot node issues"
    echo ""
    echo "Examples:"
    echo "  $0                 # Full health check"
    echo "  $0 pod-startup     # Pod startup troubleshooting"
    echo "  $0 dns             # DNS troubleshooting"
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac
