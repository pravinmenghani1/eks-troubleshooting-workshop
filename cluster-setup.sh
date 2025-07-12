#!/bin/bash

# EKS Cluster Setup Script for Troubleshooting Workshop
# This script creates a simple EKS cluster for troubleshooting exercises

set -e

# Configuration
CLUSTER_NAME="eks-troubleshooting-workshop"
REGION="us-west-2"
NODE_GROUP_NAME="workshop-nodes"
KUBERNETES_VERSION="1.33"

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

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    # Check AWS CLI
    if ! command -v aws &> /dev/null; then
        print_error "AWS CLI is not installed"
        exit 1
    fi
    print_success "AWS CLI is available"
    
    # Check eksctl
    if ! command -v eksctl &> /dev/null; then
        print_error "eksctl is not installed"
        echo "Install eksctl: https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html"
        exit 1
    fi
    print_success "eksctl is available"
    
    # Check kubectl
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed"
        exit 1
    fi
    print_success "kubectl is available"
    
    # Check AWS credentials
    if ! aws sts get-caller-identity &> /dev/null; then
        print_error "AWS credentials not configured"
        exit 1
    fi
    print_success "AWS credentials are configured"
    
    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    print_success "Using AWS Account: $ACCOUNT_ID"
}

# Create EKS cluster
create_cluster() {
    print_header "Creating EKS Cluster"
    
    # Check if cluster already exists
    if eksctl get cluster --name $CLUSTER_NAME --region $REGION &> /dev/null; then
        print_warning "Cluster $CLUSTER_NAME already exists"
        return 0
    fi
    
    print_warning "This will take 15-20 minutes..."
    
    # Create cluster configuration
    cat > cluster-config.yaml << EOF
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: $CLUSTER_NAME
  region: $REGION
  version: "$KUBERNETES_VERSION"

nodeGroups:
  - name: $NODE_GROUP_NAME
    instanceType: t3.medium
    desiredCapacity: 3
    minSize: 2
    maxSize: 5
    volumeSize: 20
    amiFamily: AmazonLinux2023
    ssh:
      allow: false
    iam:
      withAddonPolicies:
        imageBuilder: true
        autoScaler: true
        certManager: true
        efs: true
        ebs: true
        fsx: true
        cloudWatch: true

addons:
  - name: vpc-cni
  - name: coredns
  - name: kube-proxy
  - name: aws-ebs-csi-driver

cloudWatch:
  clusterLogging:
    enable: ["api", "audit", "authenticator", "controllerManager", "scheduler"]
EOF

    # Create the cluster
    eksctl create cluster -f cluster-config.yaml
    
    if [ $? -eq 0 ]; then
        print_success "Cluster created successfully"
    else
        print_error "Failed to create cluster"
        exit 1
    fi
}

# Install additional components
install_components() {
    print_header "Installing Additional Components"
    
    # Install metrics server
    print_warning "Installing metrics server..."
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    
    # Wait for metrics server to be ready
    kubectl wait --for=condition=available --timeout=300s deployment/metrics-server -n kube-system
    print_success "Metrics server installed"
    
    # Install cluster autoscaler
    print_warning "Installing cluster autoscaler..."
    curl -o cluster-autoscaler-autodiscover.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
    
    # Update cluster name in the autoscaler config
    sed -i.bak "s/<YOUR CLUSTER NAME>/$CLUSTER_NAME/g" cluster-autoscaler-autodiscover.yaml
    kubectl apply -f cluster-autoscaler-autodiscover.yaml
    
    # Annotate the deployment
    kubectl annotate deployment cluster-autoscaler -n kube-system cluster-autoscaler.kubernetes.io/safe-to-evict="false"
    
    print_success "Cluster autoscaler installed"
    
    # Create sample applications for testing
    print_warning "Creating sample applications..."
    
    # Sample web application
    kubectl create deployment sample-app --image=nginx:latest --replicas=2
    kubectl expose deployment sample-app --port=80 --type=ClusterIP
    
    # Sample backend service
    kubectl create deployment backend-service --image=httpd:latest --replicas=1
    kubectl expose deployment backend-service --port=80 --type=ClusterIP
    
    print_success "Sample applications created"
}

# Verify cluster setup
verify_setup() {
    print_header "Verifying Cluster Setup"
    
    # Check nodes
    echo "Nodes:"
    kubectl get nodes -o wide
    
    # Check system pods
    echo -e "\nSystem pods:"
    kubectl get pods -n kube-system
    
    # Check sample applications
    echo -e "\nSample applications:"
    kubectl get deployments,services
    
    # Test DNS
    echo -e "\nTesting DNS resolution:"
    kubectl run dns-test --image=busybox --rm -it --restart=Never -- nslookup kubernetes.default.svc.cluster.local || true
    
    print_success "Cluster verification completed"
}

# Save cluster information
save_cluster_info() {
    print_header "Saving Cluster Information"
    
    cat > cluster-info.txt << EOF
EKS Troubleshooting Workshop Cluster Information
===============================================

Cluster Name: $CLUSTER_NAME
Region: $REGION
Kubernetes Version: $KUBERNETES_VERSION
Node Group: $NODE_GROUP_NAME

Useful Commands:
- Update kubeconfig: aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME
- Get cluster info: eksctl get cluster --name $CLUSTER_NAME --region $REGION
- Delete cluster: eksctl delete cluster --name $CLUSTER_NAME --region $REGION

Sample Applications:
- sample-app (nginx)
- backend-service (httpd)

Created: $(date)
EOF

    print_success "Cluster information saved to cluster-info.txt"
}

# Main execution
main() {
    print_header "EKS Troubleshooting Workshop - Cluster Setup"
    
    check_prerequisites
    create_cluster
    install_components
    verify_setup
    save_cluster_info
    
    print_success "Cluster setup completed successfully!"
    echo -e "\n${GREEN}Next steps:${NC}"
    echo "1. Run fault injection scripts to create issues"
    echo "2. Practice troubleshooting scenarios"
    echo "3. Use restoration scripts to fix issues"
    echo -e "\n${YELLOW}Remember to delete the cluster when done to avoid charges:${NC}"
    echo "eksctl delete cluster --name $CLUSTER_NAME --region $REGION"
}

# Help function
show_help() {
    echo "EKS Cluster Setup Script"
    echo ""
    echo "This script creates an EKS cluster for troubleshooting workshops."
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -n, --name     Cluster name (default: $CLUSTER_NAME)"
    echo "  -r, --region   AWS region (default: $REGION)"
    echo ""
    echo "Examples:"
    echo "  $0                           # Create cluster with defaults"
    echo "  $0 -n my-cluster            # Create cluster with custom name"
    echo "  $0 -r us-east-1             # Create cluster in different region"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
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

# Run main function
main
