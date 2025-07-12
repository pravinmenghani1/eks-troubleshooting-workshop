#!/bin/bash

# Node Health Crisis - Cluster Restoration Script
# This script fixes all node health and scheduling issues

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
║    🔧 NODE HEALTH RESTORATION CENTER 🔧                                     ║
║                                                                              ║
║    Fixing all node health and scheduling issues step by step! 🚀           ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

EOF
    echo -e "${NC}"
}

# Fix 1: Reduce resource exhaustion
fix_resource_exhaustion() {
    print_header "Fix 1: Node Resource Exhaustion"
    
    echo -e "${YELLOW}Problem: Pods requesting more resources than available on nodes${NC}"
    echo -e "${RED}Current: memory-hog (10 replicas × 2Gi), cpu-burner (5 replicas × 4 cores)${NC}"
    echo -e "${GREEN}Solution: Reduce replicas and resource requests to reasonable levels${NC}"
    
    print_solution "Scale down and reduce resource requests"
    
    # Reduce memory-hog deployment
    kubectl scale deployment memory-hog -n troubleshooting-node --replicas=2
    kubectl patch deployment memory-hog -n troubleshooting-node \
        -p '{"spec":{"template":{"spec":{"containers":[{"name":"memory-consumer","resources":{"requests":{"memory":"256Mi","cpu":"100m"},"limits":{"memory":"512Mi","cpu":"200m"}}}]}}}}'
    
    # Reduce cpu-burner deployment
    kubectl scale deployment cpu-burner -n troubleshooting-node --replicas=1
    kubectl patch deployment cpu-burner -n troubleshooting-node \
        -p '{"spec":{"template":{"spec":{"containers":[{"name":"cpu-consumer","resources":{"requests":{"cpu":"500m","memory":"100Mi"},"limits":{"cpu":"1000m","memory":"200Mi"}}}]}}}}'
    
    print_success "Resource exhaustion fixed! Scaled down and reduced resource requests."
}

# Fix 2: Remove impossible node affinity
fix_impossible_affinity() {
    print_header "Fix 2: Impossible Node Affinity Requirements"
    
    echo -e "${YELLOW}Problem: Pods require node labels that don't exist${NC}"
    echo -e "${RED}Current: Requires nonexistent-zone=mars, instance-type=super-computer${NC}"
    echo -e "${GREEN}Solution: Remove impossible node affinity constraints${NC}"
    
    print_solution "Remove node affinity requirements"
    
    kubectl patch deployment impossible-affinity-app -n troubleshooting-node \
        -p '{"spec":{"template":{"spec":{"affinity":null}}}}'
    
    print_success "Impossible node affinity removed! Pods can now schedule on any node."
}

# Fix 3: Fix taint intolerance
fix_taint_intolerance() {
    print_header "Fix 3: Taint Intolerance Issues"
    
    echo -e "${YELLOW}Problem: Pods lack tolerations for tainted nodes${NC}"
    echo -e "${RED}Current: Nodes may have taints, pods have no tolerations${NC}"
    echo -e "${GREEN}Solution: Add tolerations to pods or remove taints from nodes${NC}"
    
    print_solution "Add tolerations to handle workshop taints"
    
    # Add tolerations to the deployment
    kubectl patch deployment taint-intolerant-app -n troubleshooting-node \
        -p '{"spec":{"template":{"spec":{"tolerations":[{"key":"workshop","operator":"Equal","value":"node-health-crisis","effect":"NoSchedule"}]}}}}'
    
    # Also remove the taint we added (if it exists)
    WORKER_NODE=$(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep -v master | head -1)
    if [ -n "$WORKER_NODE" ]; then
        kubectl taint node "$WORKER_NODE" workshop:NoSchedule- || true
        print_warning "Removed workshop taint from node: $WORKER_NODE"
    fi
    
    print_success "Taint intolerance fixed! Added tolerations and removed problematic taints."
}

# Fix 4: Fix Pod Disruption Budget
fix_pdb_blocking() {
    print_header "Fix 4: Pod Disruption Budget Blocking"
    
    echo -e "${YELLOW}Problem: PDB requires 100% availability, blocking rolling updates${NC}"
    echo -e "${RED}Current: minAvailable: 100% (impossible during updates)${NC}"
    echo -e "${GREEN}Solution: Set reasonable PDB allowing some disruption${NC}"
    
    print_solution "Update PDB to allow reasonable disruption"
    
    kubectl patch pdb overly-restrictive-pdb -n troubleshooting-node \
        -p '{"spec":{"minAvailable":"50%"}}'
    
    print_success "Pod Disruption Budget fixed! Rolling updates can now proceed."
}

# Wait for deployments to be ready
wait_for_deployments() {
    print_header "Waiting for All Deployments to be Ready"
    
    echo -e "${CYAN}Waiting for deployments to roll out and pods to schedule...${NC}"
    
    # Wait for each deployment with timeout
    kubectl rollout status deployment/memory-hog -n troubleshooting-node --timeout=180s || true
    kubectl rollout status deployment/cpu-burner -n troubleshooting-node --timeout=180s || true
    kubectl rollout status deployment/impossible-affinity-app -n troubleshooting-node --timeout=180s || true
    kubectl rollout status deployment/taint-intolerant-app -n troubleshooting-node --timeout=180s || true
    kubectl rollout status deployment/pdb-blocked-app -n troubleshooting-node --timeout=180s || true
    
    print_success "All deployments have been processed!"
}

# Show final status
show_final_status() {
    print_header "Final Node Health Status Check"
    
    echo -e "${GREEN}${BOLD}🎉 All node health issues have been addressed!${NC}\n"
    
    echo -e "${CYAN}Nodes:${NC}"
    kubectl get nodes
    
    echo -e "\n${CYAN}Deployments:${NC}"
    kubectl get deployments -n troubleshooting-node
    
    echo -e "\n${CYAN}Pods (should be Running or have reasonable resource requests):${NC}"
    kubectl get pods -n troubleshooting-node
    
    echo -e "\n${CYAN}Pod Disruption Budgets:${NC}"
    kubectl get pdb -n troubleshooting-node
    
    echo -e "\n${CYAN}Recent Events:${NC}"
    kubectl get events -n troubleshooting-node --sort-by='.lastTimestamp' | tail -10
    
    echo -e "\n${CYAN}Node Resource Summary:${NC}"
    kubectl describe nodes | grep -A 3 "Allocated resources" | head -15
}

# Show learning summary
show_learning_summary() {
    print_header "Node Health Troubleshooting Learning Summary"
    
    echo -e "${PURPLE}${BOLD}🎓 What You Learned:${NC}\n"
    
    echo -e "${CYAN}1. Node Resource Management:${NC}"
    echo -e "   • Nodes have finite CPU, memory, and storage capacity"
    echo -e "   • Pod resource requests must fit within node capacity"
    echo -e "   • Over-requesting resources leads to Pending pods"
    
    echo -e "\n${CYAN}2. Pod Scheduling Constraints:${NC}"
    echo -e "   • Node affinity/selectors must match existing node labels"
    echo -e "   • Impossible requirements result in permanently Pending pods"
    echo -e "   • Always verify node labels before setting affinity rules"
    
    echo -e "\n${CYAN}3. Taints and Tolerations:${NC}"
    echo -e "   • Taints repel pods that don't have matching tolerations"
    echo -e "   • Tolerations allow pods to be scheduled on tainted nodes"
    echo -e "   • Common taints: NoSchedule, PreferNoSchedule, NoExecute"
    
    echo -e "\n${CYAN}4. Pod Disruption Budgets:${NC}"
    echo -e "   • PDBs protect applications during voluntary disruptions"
    echo -e "   • Overly restrictive PDBs can block rolling updates"
    echo -e "   • Balance availability requirements with update flexibility"
    
    echo -e "\n${CYAN}5. Troubleshooting Commands:${NC}"
    echo -e "   • kubectl get nodes (check node status)"
    echo -e "   • kubectl describe nodes (detailed resource info)"
    echo -e "   • kubectl describe pod (scheduling failure reasons)"
    echo -e "   • kubectl get events (scheduling events and errors)"
    
    echo -e "\n${CYAN}6. Best Practices:${NC}"
    echo -e "   • Set realistic resource requests and limits"
    echo -e "   • Use node selectors/affinity only when necessary"
    echo -e "   • Configure appropriate tolerations for tainted nodes"
    echo -e "   • Set reasonable Pod Disruption Budgets"
    echo -e "   • Monitor node resource utilization regularly"
    
    echo -e "\n${GREEN}${BOLD}🏆 Congratulations! You've mastered node health troubleshooting!${NC}"
}

# Main restoration function
main() {
    show_header
    
    echo -e "${YELLOW}${BOLD}Starting node health restoration...${NC}\n"
    
    # Check if namespace exists
    if ! kubectl get namespace troubleshooting-node &>/dev/null; then
        print_error "Node troubleshooting namespace not found. Run inject-fault.sh first!"
        exit 1
    fi
    
    # Apply all fixes
    fix_resource_exhaustion
    echo
    fix_impossible_affinity
    echo
    fix_taint_intolerance
    echo
    fix_pdb_blocking
    echo
    
    # Wait for deployments to be ready
    wait_for_deployments
    echo
    
    show_final_status
    echo
    show_learning_summary
    
    echo -e "\n${GREEN}${BOLD}🎉 Node Health Crisis Successfully Resolved! 🎉${NC}"
    echo -e "${CYAN}All node health and scheduling issues have been addressed!${NC}"
}

# Run main function
main "$@"
