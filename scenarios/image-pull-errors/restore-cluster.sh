#!/bin/bash

# Image Registry Disasters - Cluster Restoration Script
# This script fixes all image registry issues and shows the solutions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Utility functions
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

print_solution() {
    echo -e "${CYAN}💡 Solution: $1${NC}"
}

# Show visual header
show_header() {
    clear
    echo -e "${GREEN}${BOLD}"
    cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    🔧 IMAGE REGISTRY RESTORATION CENTER 🔧                                  ║
║                                                                              ║
║    Fixing all image registry issues step by step! 🚀                       ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

EOF
    echo -e "${NC}"
}

# Fix 1: Replace non-existent image
fix_nonexistent_image() {
    print_header "Fix 1: Non-existent Image Reference"
    
    echo -e "${YELLOW}Problem: Image 'nonexistent/fake-app:v999.999.999' does not exist${NC}"
    echo -e "${RED}Current: nonexistent/fake-app:v999.999.999${NC}"
    echo -e "${GREEN}Solution: nginx:latest (a reliable, existing image)${NC}"
    
    print_solution "Replace with a valid, existing image"
    
    kubectl patch deployment nonexistent-image-app -n troubleshooting-registry \
        -p '{"spec":{"template":{"spec":{"containers":[{"name":"fake-app","image":"nginx:latest"}]}}}}'
    
    print_success "Non-existent image fixed with nginx:latest!"
}

# Fix 2: Fix private registry access
fix_private_registry() {
    print_header "Fix 2: Private Registry Access"
    
    echo -e "${YELLOW}Problem: Private registry 'private-registry.example.com' is not accessible${NC}"
    echo -e "${RED}Current: private-registry.example.com/secret-app:latest${NC}"
    echo -e "${GREEN}Solution: nginx:latest (public image)${NC}"
    
    print_solution "Replace with a public image (or add proper image pull secrets)"
    
    kubectl patch deployment private-registry-app -n troubleshooting-registry \
        -p '{"spec":{"template":{"spec":{"containers":[{"name":"secret-app","image":"nginx:latest"}]}}}}'
    
    print_success "Private registry issue fixed with public image!"
}

# Fix 3: Correct wrong image tag
fix_wrong_tag() {
    print_header "Fix 3: Wrong Image Tag"
    
    echo -e "${YELLOW}Problem: Tag 'nginx:nonexistent-tag-v999' does not exist${NC}"
    echo -e "${RED}Current: nginx:nonexistent-tag-v999${NC}"
    echo -e "${GREEN}Solution: nginx:latest (valid tag)${NC}"
    
    print_solution "Use a valid, existing tag"
    
    kubectl patch deployment wrong-tag-app -n troubleshooting-registry \
        -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx-wrong-tag","image":"nginx:latest"}]}}}}'
    
    print_success "Wrong image tag fixed!"
}

# Fix 4: Fix corrupted image pull secret
fix_corrupted_secret() {
    print_header "Fix 4: Corrupted Image Pull Secret"
    
    echo -e "${YELLOW}Problem: Image pull secret contains invalid base64 data${NC}"
    echo -e "${RED}Current: Corrupted dockerconfigjson + private image${NC}"
    echo -e "${GREEN}Solution: Remove secret and use public image${NC}"
    
    print_solution "Remove corrupted secret and use public image"
    
    # Remove the corrupted secret
    kubectl delete secret corrupted-registry-secret -n troubleshooting-registry --ignore-not-found=true
    
    # Update deployment to remove imagePullSecrets and use public image
    kubectl patch deployment corrupted-secret-app -n troubleshooting-registry \
        -p '{"spec":{"template":{"spec":{"imagePullSecrets":null,"containers":[{"name":"github-app","image":"nginx:latest"}]}}}}'
    
    print_success "Corrupted secret removed and image fixed!"
}

# Fix 5: Fix network connectivity issue
fix_network_connectivity() {
    print_header "Fix 5: Network Connectivity Issue"
    
    echo -e "${YELLOW}Problem: Registry 'unreachable-registry.internal' is not reachable${NC}"
    echo -e "${RED}Current: unreachable-registry.internal/app:latest${NC}"
    echo -e "${GREEN}Solution: nginx:latest (accessible public image)${NC}"
    
    print_solution "Replace with an accessible public registry image"
    
    kubectl patch deployment network-isolated-app -n troubleshooting-registry \
        -p '{"spec":{"template":{"spec":{"containers":[{"name":"isolated-app","image":"nginx:latest"}]}}}}'
    
    print_success "Network connectivity issue fixed with accessible image!"
}

# Wait for deployments to be ready
wait_for_deployments() {
    print_header "Waiting for All Deployments to be Ready"
    
    echo -e "${CYAN}Waiting for deployments to roll out...${NC}"
    
    kubectl rollout status deployment/nonexistent-image-app -n troubleshooting-registry --timeout=120s
    kubectl rollout status deployment/private-registry-app -n troubleshooting-registry --timeout=120s
    kubectl rollout status deployment/wrong-tag-app -n troubleshooting-registry --timeout=120s
    kubectl rollout status deployment/corrupted-secret-app -n troubleshooting-registry --timeout=120s
    kubectl rollout status deployment/network-isolated-app -n troubleshooting-registry --timeout=120s
    
    print_success "All deployments are ready!"
}

# Show final status
show_final_status() {
    print_header "Final Image Registry Status Check"
    
    echo -e "${GREEN}${BOLD}🎉 All image registry issues have been resolved!${NC}\n"
    
    echo -e "${CYAN}Deployments:${NC}"
    kubectl get deployments -n troubleshooting-registry
    
    echo -e "\n${CYAN}Pods (should all be Running):${NC}"
    kubectl get pods -n troubleshooting-registry
    
    echo -e "\n${CYAN}Recent Events (should show successful pulls):${NC}"
    kubectl get events -n troubleshooting-registry --sort-by='.lastTimestamp' | tail -10
}

# Show learning summary
show_learning_summary() {
    print_header "Image Registry Troubleshooting Learning Summary"
    
    echo -e "${PURPLE}${BOLD}🎓 What You Learned:${NC}\n"
    
    echo -e "${CYAN}1. Common Image Pull Issues:${NC}"
    echo -e "   • Non-existent images or tags"
    echo -e "   • Private registry authentication failures"
    echo -e "   • Corrupted image pull secrets"
    echo -e "   • Network connectivity problems"
    
    echo -e "\n${CYAN}2. Troubleshooting Commands:${NC}"
    echo -e "   • kubectl describe pod <name> (check events and errors)"
    echo -e "   • kubectl get events --sort-by='.lastTimestamp'"
    echo -e "   • kubectl get secrets (check image pull secrets)"
    
    echo -e "\n${CYAN}3. Common Solutions:${NC}"
    echo -e "   • Verify image names and tags exist"
    echo -e "   • Create proper image pull secrets for private registries"
    echo -e "   • Check network connectivity to registries"
    echo -e "   • Use kubectl patch to update image references"
    
    echo -e "\n${CYAN}4. Image Pull Secret Creation:${NC}"
    echo -e "   • kubectl create secret docker-registry <name>"
    echo -e "   • --docker-server, --docker-username, --docker-password"
    echo -e "   • Reference in deployment spec.imagePullSecrets"
    
    echo -e "\n${CYAN}5. Best Practices:${NC}"
    echo -e "   • Use specific image tags instead of 'latest'"
    echo -e "   • Test image availability before deployment"
    echo -e "   • Keep image pull secrets secure and up-to-date"
    echo -e "   • Monitor image pull events and errors"
    
    echo -e "\n${GREEN}${BOLD}🏆 Congratulations! You've mastered image registry troubleshooting!${NC}"
}

# Main restoration function
main() {
    show_header
    
    echo -e "${YELLOW}${BOLD}Starting image registry restoration...${NC}\n"
    
    # Check if namespace exists
    if ! kubectl get namespace troubleshooting-registry &>/dev/null; then
        print_error "Registry troubleshooting namespace not found. Run inject-fault.sh first!"
        exit 1
    fi
    
    # Apply all fixes
    fix_nonexistent_image
    echo
    fix_private_registry
    echo
    fix_wrong_tag
    echo
    fix_corrupted_secret
    echo
    fix_network_connectivity
    echo
    
    # Wait for deployments to be ready
    wait_for_deployments
    echo
    
    show_final_status
    echo
    show_learning_summary
    
    echo -e "\n${GREEN}${BOLD}🎉 Image Registry Disasters Successfully Resolved! 🎉${NC}"
    echo -e "${CYAN}All applications should now be running with successful image pulls!${NC}"
}

# Run main function
main "$@"
