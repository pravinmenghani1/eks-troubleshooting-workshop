#!/bin/bash

# RBAC Permission Nightmare - Cluster Restoration Script
# This script fixes all RBAC permission issues and shows the solutions

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
║    🔧 RBAC PERMISSION RESTORATION CENTER 🔧                                 ║
║                                                                              ║
║    Fixing all RBAC permission issues step by step! 🚀                      ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

EOF
    echo -e "${NC}"
}

# Fix 1: Correct the secret reader role
fix_secret_reader() {
    print_header "Fix 1: Secret Reader Role Permissions"
    
    echo -e "${YELLOW}Problem: Role 'broken-secret-reader' has wrong resource permissions${NC}"
    echo -e "${RED}Current: resources: [\"configmaps\"]${NC}"
    echo -e "${GREEN}Should be: resources: [\"secrets\"]${NC}"
    
    print_solution "Patch the role to use correct resource type"
    
    kubectl patch role broken-secret-reader -n troubleshooting-rbac --type='json' \
        -p='[{"op": "replace", "path": "/rules/0/resources", "value": ["secrets"]}]'
    
    print_success "Secret reader role fixed!"
    
    # Verify the fix
    echo -e "\n${CYAN}Verification:${NC}"
    kubectl auth can-i get secrets --as=system:serviceaccount:troubleshooting-rbac:secret-reader -n troubleshooting-rbac
    kubectl auth can-i list secrets --as=system:serviceaccount:troubleshooting-rbac:secret-reader -n troubleshooting-rbac
}

# Fix 2: Add create permission to pod creator role
fix_pod_creator() {
    print_header "Fix 2: Pod Creator Role Permissions"
    
    echo -e "${YELLOW}Problem: Role 'broken-pod-creator' missing 'create' verb${NC}"
    echo -e "${RED}Current: verbs: [\"get\", \"list\"]${NC}"
    echo -e "${GREEN}Should be: verbs: [\"get\", \"list\", \"create\"]${NC}"
    
    print_solution "Add 'create' verb to the role"
    
    kubectl patch role broken-pod-creator -n troubleshooting-rbac --type='json' \
        -p='[{"op": "add", "path": "/rules/0/verbs/-", "value": "create"}]'
    
    print_success "Pod creator role fixed!"
    
    # Verify the fix
    echo -e "\n${CYAN}Verification:${NC}"
    kubectl auth can-i create pods --as=system:serviceaccount:troubleshooting-rbac:pod-creator -n troubleshooting-rbac
    kubectl auth can-i get pods --as=system:serviceaccount:troubleshooting-rbac:pod-creator -n troubleshooting-rbac
}

# Fix 3: Create missing role binding for service lister
fix_service_lister() {
    print_header "Fix 3: Service Lister Role Binding"
    
    echo -e "${YELLOW}Problem: Service account 'service-lister' has no role binding${NC}"
    echo -e "${RED}Current: No RoleBinding exists${NC}"
    echo -e "${GREEN}Should be: RoleBinding connecting service-lister to service-lister-role${NC}"
    
    print_solution "Create the missing RoleBinding"
    
    kubectl create rolebinding service-lister-binding \
        --role=service-lister-role \
        --serviceaccount=troubleshooting-rbac:service-lister \
        -n troubleshooting-rbac
    
    print_success "Service lister role binding created!"
    
    # Verify the fix
    echo -e "\n${CYAN}Verification:${NC}"
    kubectl auth can-i list services --as=system:serviceaccount:troubleshooting-rbac:service-lister -n troubleshooting-rbac
    kubectl auth can-i get services --as=system:serviceaccount:troubleshooting-rbac:service-lister -n troubleshooting-rbac
}

# Show final status
show_final_status() {
    print_header "Final RBAC Status Check"
    
    echo -e "${GREEN}${BOLD}🎉 All RBAC permissions have been restored!${NC}\n"
    
    echo -e "${CYAN}Service Accounts:${NC}"
    kubectl get serviceaccounts -n troubleshooting-rbac
    
    echo -e "\n${CYAN}Roles:${NC}"
    kubectl get roles -n troubleshooting-rbac
    
    echo -e "\n${CYAN}Role Bindings:${NC}"
    kubectl get rolebindings -n troubleshooting-rbac
    
    echo -e "\n${CYAN}Application Status:${NC}"
    kubectl get pods -n troubleshooting-rbac
    
    echo -e "\n${GREEN}${BOLD}Permission Test Results:${NC}"
    echo -e "${CYAN}Secret Reader:${NC}"
    kubectl auth can-i get secrets --as=system:serviceaccount:troubleshooting-rbac:secret-reader -n troubleshooting-rbac
    kubectl auth can-i list secrets --as=system:serviceaccount:troubleshooting-rbac:secret-reader -n troubleshooting-rbac
    
    echo -e "\n${CYAN}Pod Creator:${NC}"
    kubectl auth can-i create pods --as=system:serviceaccount:troubleshooting-rbac:pod-creator -n troubleshooting-rbac
    kubectl auth can-i get pods --as=system:serviceaccount:troubleshooting-rbac:pod-creator -n troubleshooting-rbac
    
    echo -e "\n${CYAN}Service Lister:${NC}"
    kubectl auth can-i list services --as=system:serviceaccount:troubleshooting-rbac:service-lister -n troubleshooting-rbac
    kubectl auth can-i get services --as=system:serviceaccount:troubleshooting-rbac:service-lister -n troubleshooting-rbac
}

# Show learning summary
show_learning_summary() {
    print_header "RBAC Troubleshooting Learning Summary"
    
    echo -e "${PURPLE}${BOLD}🎓 What You Learned:${NC}\n"
    
    echo -e "${CYAN}1. RBAC Component Relationships:${NC}"
    echo -e "   • ServiceAccount → RoleBinding → Role → Resources"
    echo -e "   • Each component must be correctly configured"
    
    echo -e "\n${CYAN}2. Common RBAC Issues:${NC}"
    echo -e "   • Wrong resource types in roles"
    echo -e "   • Missing verbs (get, list, create, update, delete)"
    echo -e "   • Missing role bindings"
    echo -e "   • Incorrect namespace scope"
    
    echo -e "\n${CYAN}3. Troubleshooting Commands:${NC}"
    echo -e "   • kubectl get roles,rolebindings -n <namespace>"
    echo -e "   • kubectl describe role <role-name> -n <namespace>"
    echo -e "   • kubectl auth can-i <verb> <resource> --as=<user>"
    
    echo -e "\n${CYAN}4. Fixing RBAC Issues:${NC}"
    echo -e "   • kubectl patch role <name> --type='json' -p='[...]'"
    echo -e "   • kubectl create rolebinding <name> --role=<role> --serviceaccount=<sa>"
    echo -e "   • Always verify with 'kubectl auth can-i'"
    
    echo -e "\n${GREEN}${BOLD}🏆 Congratulations! You've mastered RBAC troubleshooting!${NC}"
}

# Main restoration function
main() {
    show_header
    
    echo -e "${YELLOW}${BOLD}Starting RBAC permission restoration...${NC}\n"
    
    # Check if namespace exists
    if ! kubectl get namespace troubleshooting-rbac &>/dev/null; then
        print_error "RBAC troubleshooting namespace not found. Run inject-fault.sh first!"
        exit 1
    fi
    
    # Apply all fixes
    fix_secret_reader
    echo
    fix_pod_creator
    echo
    fix_service_lister
    echo
    
    # Wait a moment for changes to propagate
    echo -e "${YELLOW}Waiting for RBAC changes to propagate...${NC}"
    sleep 5
    
    show_final_status
    echo
    show_learning_summary
    
    echo -e "\n${GREEN}${BOLD}🎉 RBAC Permission Nightmare Successfully Resolved! 🎉${NC}"
    echo -e "${CYAN}All applications should now work without permission errors!${NC}"
}

# Run main function
main "$@"
