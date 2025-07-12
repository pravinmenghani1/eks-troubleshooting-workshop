#!/bin/bash

# Enhanced Visual EKS Troubleshooting Workshop - Scenario Manager
# This script manages all troubleshooting scenarios with spectacular visuals

set -e

# Check Bash version compatibility
if [ "${BASH_VERSION%%.*}" -lt 3 ]; then
    echo "Error: This script requires Bash 3.0 or higher"
    echo "Current version: $BASH_VERSION"
    echo "Please upgrade your Bash version"
    exit 1
fi

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
TROPHY="🏆"
STAR="⭐"
HEART="❤️"
LIGHTNING="⚡"

print_main_banner() {
    clear
    echo -e "${PURPLE}${BOLD}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    🚀 EKS TROUBLESHOOTING WORKSHOP COMMAND CENTER 🚀                        ║
║                                                                              ║
║    Welcome to the ultimate Kubernetes debugging experience!                  ║
║    Choose your chaos, master your skills! 💪                                ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

print_section_header() {
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  $1${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}\n"
}

print_success() {
    echo -e "${GREEN}${CHECKMARK} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

print_error() {
    echo -e "${RED}${CROSSMARK} $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Available scenarios with enhanced metadata
SCENARIOS=(
    "pod-startup-failures"
    "dns-issues"
    "rbac-issues"
    "node-not-ready"
    "image-pull-errors"
)

# Function to get scenario metadata
get_scenario_info() {
    local scenario=$1
    case $scenario in
        "pod-startup-failures")
            echo "🐛 Pod Startup Failures|⭐⭐⭐|Image pulls, resources, secrets, crashes|30 min"
            ;;
        "dns-issues")
            echo "🌐 DNS Resolution Apocalypse|⭐⭐⭐⭐|CoreDNS chaos, network policies, service discovery|25 min"
            ;;
        "rbac-issues")
            echo "🔐 RBAC Permission Nightmare|⭐⭐⭐|Role bindings, service accounts, permissions|20 min"
            ;;
        "node-not-ready")
            echo "🖥️  Node Health Crisis|⭐⭐⭐⭐⭐|Node failures, resource exhaustion, kubelet issues|35 min"
            ;;
        "image-pull-errors")
            echo "📦 Image Registry Disasters|⭐⭐|Private registries, authentication, network issues|15 min"
            ;;
        *)
            echo "Unknown Scenario|⭐|Unknown|Unknown"
            ;;
    esac
}

# Check if cluster is available with style
check_cluster() {
    print_section_header "🔍 CLUSTER CONNECTIVITY CHECK"
    
    if ! kubectl cluster-info &> /dev/null; then
        echo -e "${RED}${BOLD}"
        cat << 'EOF'
    ┌─────────────────────────────────────────────────────────────┐
    │                    ⚠️  CLUSTER OFFLINE ⚠️                   │
    │                                                             │
    │  Cannot connect to Kubernetes cluster!                      │
    │                                                             │
    │  Please ensure:                                             │
    │  ├─ EKS cluster is running                                  │
    │  ├─ kubectl is configured correctly                         │
    │  └─ AWS credentials are valid                               │
    │                                                             │
    │  💡 Run './cluster-setup.sh' to create a cluster           │
    └─────────────────────────────────────────────────────────────┘
EOF
        echo -e "${NC}"
        exit 1
    fi
    
    # Get cluster info with style
    local cluster_info=$(kubectl cluster-info | head -1)
    local node_count=$(kubectl get nodes --no-headers | wc -l)
    local pod_count=$(kubectl get pods --all-namespaces --no-headers | wc -l)
    
    echo -e "${GREEN}${BOLD}"
    cat << EOF
    ┌─────────────────────────────────────────────────────────────┐
    │                    ✅ CLUSTER ONLINE ✅                     │
    │                                                             │
    │  Status: Connected and Ready                                │
    │  Nodes:  $node_count active                                │
    │  Pods:   $pod_count running                                │
    │                                                             │
    │  Ready for troubleshooting adventures! 🚀                  │
    └─────────────────────────────────────────────────────────────┘
EOF
    echo -e "${NC}"
}

# Enhanced scenario listing with visual appeal
list_scenarios() {
    print_section_header "🎮 AVAILABLE TROUBLESHOOTING ADVENTURES"
    
    echo -e "${YELLOW}${BOLD}Choose your chaos level and begin your debugging journey!${NC}\n"
    
    local counter=1
    for scenario in "${SCENARIOS[@]}"; do
        local scenario_info=$(get_scenario_info "$scenario")
        IFS='|' read -r title difficulty description duration <<< "$scenario_info"
        
        echo -e "${CYAN}${BOLD}[$counter] $title${NC}"
        echo -e "    ${PURPLE}Difficulty: $difficulty${NC}"
        echo -e "    ${BLUE}Challenge: $description${NC}"
        echo -e "    ${GREEN}Duration: $duration${NC}"
        echo ""
        ((counter++))
    done
    
    echo -e "${YELLOW}${BOLD}💡 Pro Tip:${NC} Start with Pod Startup Failures if you're new to troubleshooting!"
}

# Enhanced scenario execution with visual feedback
run_scenario() {
    local scenario=$1
    local action=$2
    
    # Check if scenario exists
    local scenario_exists=false
    for s in "${SCENARIOS[@]}"; do
        if [ "$s" = "$scenario" ]; then
            scenario_exists=true
            break
        fi
    done
    
    if [ "$scenario_exists" = false ]; then
        print_error "Unknown scenario: $scenario"
        list_scenarios
        exit 1
    fi
    
    local scenario_info=$(get_scenario_info "$scenario")
    IFS='|' read -r title difficulty description duration <<< "$scenario_info"
    local scenario_dir="scenarios/$scenario"
    
    if [ ! -d "$scenario_dir" ]; then
        print_error "Scenario directory not found: $scenario_dir"
        exit 1
    fi
    
    case $action in
        "inject"|"start")
            print_section_header "🚀 LAUNCHING CHAOS: $title"
            
            echo -e "${YELLOW}${BOLD}"
            cat << EOF
    ┌─────────────────────────────────────────────────────────────┐
    │                    MISSION BRIEFING                         │
    │                                                             │
    │  Scenario: $title                                           │
    │  Difficulty: $difficulty                                    │
    │  Challenge: $description                                    │
    │  Est. Time: $duration                                       │
    │                                                             │
    │  Prepare for controlled chaos! 💥                          │
    └─────────────────────────────────────────────────────────────┘
EOF
            echo -e "${NC}"
            
            if [ -f "$scenario_dir/inject-fault.sh" ]; then
                cd "$scenario_dir"
                chmod +x inject-fault.sh
                ./inject-fault.sh
                cd - > /dev/null
            else
                print_error "Fault injection script not found for scenario: $scenario"
                exit 1
            fi
            ;;
        "restore"|"fix"|"solve")
            print_section_header "🏥 HEALING SESSION: $title"
            
            echo -e "${GREEN}${BOLD}"
            cat << EOF
    ┌─────────────────────────────────────────────────────────────┐
    │                    HEALING CEREMONY                         │
    │                                                             │
    │  Scenario: $title                                           │
    │  Action: Complete restoration with solutions                │
    │                                                             │
    │  Watch as chaos transforms into harmony! ✨                 │
    └─────────────────────────────────────────────────────────────┘
EOF
            echo -e "${NC}"
            
            if [ -f "$scenario_dir/restore-cluster.sh" ]; then
                cd "$scenario_dir"
                chmod +x restore-cluster.sh
                ./restore-cluster.sh
                cd - > /dev/null
            else
                print_error "Restoration script not found for scenario: $scenario"
                exit 1
            fi
            ;;
        "status"|"check")
            print_section_header "📊 SCENARIO STATUS: $title"
            check_scenario_status "$scenario"
            ;;
        *)
            print_error "Unknown action: $action"
            echo "Available actions: inject, restore, status"
            exit 1
            ;;
    esac
}

# Enhanced status checking with visual dashboard
check_scenario_status() {
    local scenario=$1
    local scenario_info=$(get_scenario_info "$scenario")
    IFS='|' read -r title difficulty description duration <<< "$scenario_info"
    
    echo -e "${CYAN}${BOLD}Checking status for: $title${NC}\n"
    
    case $scenario in
        "pod-startup-failures")
            if kubectl get namespace troubleshooting-pod-startup &> /dev/null; then
                echo -e "${GREEN}${BOLD}📊 Pod Startup Scenario Status:${NC}"
                echo -e "${YELLOW}Namespace:${NC} troubleshooting-pod-startup ✅"
                echo -e "\n${CYAN}Pod Status:${NC}"
                kubectl get pods -n troubleshooting-pod-startup -o wide
                echo -e "\n${CYAN}Deployment Status:${NC}"
                kubectl get deployments -n troubleshooting-pod-startup
            else
                print_info "Pod startup scenario not currently active"
            fi
            ;;
        "dns-issues")
            if kubectl get namespace troubleshooting-dns &> /dev/null; then
                echo -e "${GREEN}${BOLD}📊 DNS Scenario Status:${NC}"
                echo -e "${YELLOW}Namespace:${NC} troubleshooting-dns ✅"
                echo -e "\n${CYAN}DNS Test Apps:${NC}"
                kubectl get pods -n troubleshooting-dns -o wide
                echo -e "\n${CYAN}CoreDNS Status:${NC}"
                kubectl get pods -n kube-system -l k8s-app=kube-dns
            else
                print_info "DNS scenario not currently active"
            fi
            ;;
        "rbac-issues")
            if kubectl get namespace troubleshooting-rbac &> /dev/null; then
                echo -e "${GREEN}${BOLD}📊 RBAC Scenario Status:${NC}"
                echo -e "${YELLOW}Namespace:${NC} troubleshooting-rbac ✅"
                echo -e "\n${CYAN}RBAC Test Apps:${NC}"
                kubectl get pods -n troubleshooting-rbac -o wide
                echo -e "\n${CYAN}Service Accounts:${NC}"
                kubectl get serviceaccounts -n troubleshooting-rbac
            else
                print_info "RBAC scenario not currently active"
            fi
            ;;
        *)
            print_info "Status check not implemented for scenario: $scenario"
            ;;
    esac
}

# Progress portal functions
launch_progress_portal() {
    print_section_header "📊 LAUNCHING PROGRESS PORTAL"
    
    if [ -f "./launch-portal.sh" ]; then
        print_success "Starting progress portal..."
        echo -e "${CYAN}The progress portal will help you track your workshop progress!${NC}"
        echo -e "${YELLOW}Keep the portal open in your browser while working on scenarios.${NC}"
        echo ""
        ./launch-portal.sh
    else
        print_warning "Progress portal launcher not found"
        print_info "You can still use the workshop without the portal"
    fi
}

launch_progress_portal_if_needed() {
    # Check if portal is already running on common ports
    local portal_running=false
    for port in 8080 8081 8082 3000 3001; do
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            portal_running=true
            break
        fi
    done
    
    if [ "$portal_running" = false ]; then
        echo -e "${CYAN}${BOLD}🚀 Would you like to launch the Progress Portal? (y/n):${NC} "
        read -r launch_portal
        if [[ "$launch_portal" =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}Launching progress portal in background...${NC}"
            nohup ./launch-portal.sh > /dev/null 2>&1 &
            sleep 2
            print_success "Progress portal started! Check your browser."
        fi
    fi
}
cleanup_all() {
    print_section_header "🧹 COMPLETE WORKSHOP CLEANUP"
    
    echo -e "${YELLOW}${BOLD}"
    cat << 'EOF'
    ┌─────────────────────────────────────────────────────────────┐
    │                    ⚠️  CLEANUP WARNING ⚠️                   │
    │                                                             │
    │  This will remove ALL troubleshooting scenarios and        │
    │  restore the cluster to its original state.                │
    │                                                             │
    │  All progress will be lost!                                 │
    │                                                             │
    │  Are you sure you want to proceed?                          │
    └─────────────────────────────────────────────────────────────┘
EOF
    echo -e "${NC}"
    
    echo "Press Enter to continue or Ctrl+C to cancel..."
    read -r
    
    echo -e "${CYAN}🧹 Cleaning up troubleshooting namespaces...${NC}"
    for ns in troubleshooting-pod-startup troubleshooting-dns troubleshooting-rbac; do
        if kubectl get namespace "$ns" &> /dev/null; then
            print_warning "Removing namespace: $ns"
            kubectl delete namespace "$ns" --ignore-not-found=true
        fi
    done
    
    echo -e "${CYAN}🔧 Restoring CoreDNS configuration...${NC}"
    if [ -f "scenarios/dns-issues/coredns-backup.yaml" ]; then
        kubectl apply -f scenarios/dns-issues/coredns-backup.yaml
        kubectl rollout restart deployment coredns -n kube-system
    fi
    
    echo -e "${CYAN}📊 Scaling CoreDNS to normal levels...${NC}"
    kubectl scale deployment coredns --replicas=2 -n kube-system
    
    print_success "Complete cleanup finished! Cluster restored to original state! ✨"
}

# Enhanced interactive mode with better UX
interactive_mode() {
    while true; do
        print_main_banner
        
        echo -e "${YELLOW}${BOLD}🎯 MISSION CONTROL CENTER${NC}\n"
        echo -e "${CYAN}What would you like to do today, troubleshooter?${NC}\n"
        
        echo -e "${GREEN}1.${NC} 📋 List available scenarios"
        echo -e "${GREEN}2.${NC} 🚀 Launch a troubleshooting scenario"
        echo -e "${GREEN}3.${NC} 📊 Check scenario status"
        echo -e "${GREEN}4.${NC} 🏥 Restore/heal a scenario"
        echo -e "${GREEN}5.${NC} 🧹 Clean up all scenarios"
        echo -e "${GREEN}6.${NC} 🔍 Run cluster health check"
        echo -e "${GREEN}7.${NC} 🚪 Exit mission control"
        
        echo -e "\n${PURPLE}${BOLD}Enter your choice (1-7):${NC} "
        read -r choice
        
        case $choice in
            1)
                list_scenarios
                ;;
            2)
                echo ""
                list_scenarios
                echo -e "${YELLOW}${BOLD}Enter scenario number (1-${#SCENARIOS[@]}):${NC} "
                read -r scenario_num
                
                if [[ "$scenario_num" =~ ^[1-9][0-9]*$ ]] && [ "$scenario_num" -le "${#SCENARIOS[@]}" ]; then
                    local scenario="${SCENARIOS[$((scenario_num - 1))]}"
                    run_scenario "$scenario" "inject"
                else
                    print_error "Invalid scenario number"
                fi
                ;;
            3)
                echo ""
                list_scenarios
                echo -e "${YELLOW}${BOLD}Enter scenario number to check:${NC} "
                read -r scenario_num
                
                if [[ "$scenario_num" =~ ^[1-9][0-9]*$ ]] && [ "$scenario_num" -le "${#SCENARIOS[@]}" ]; then
                    local scenario="${SCENARIOS[$((scenario_num - 1))]}"
                    check_scenario_status "$scenario"
                else
                    print_error "Invalid scenario number"
                fi
                ;;
            4)
                echo ""
                list_scenarios
                echo -e "${YELLOW}${BOLD}Enter scenario number to heal:${NC} "
                read -r scenario_num
                
                if [[ "$scenario_num" =~ ^[1-9][0-9]*$ ]] && [ "$scenario_num" -le "${#SCENARIOS[@]}" ]; then
                    local scenario="${SCENARIOS[$((scenario_num - 1))]}"
                    run_scenario "$scenario" "restore"
                else
                    print_error "Invalid scenario number"
                fi
                ;;
            5)
                cleanup_all
                ;;
            6)
                ./troubleshooting-toolkit.sh
                ;;
            7)
                echo -e "\n${GREEN}${BOLD}${ROCKET} Thank you for using the EKS Troubleshooting Workshop! ${ROCKET}${NC}"
                echo -e "${CYAN}May your pods always be Running and your DNS always resolve! 🌟${NC}"
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please enter 1-7."
                ;;
        esac
        
        echo -e "\n${PURPLE}${BOLD}Press Enter to return to mission control...${NC}"
        read -r
    done
}

# Enhanced help with visual formatting
show_help() {
    print_main_banner
    
    cat << EOF
${CYAN}${BOLD}🎯 EKS TROUBLESHOOTING WORKSHOP COMMAND CENTER${NC}

${YELLOW}${BOLD}USAGE:${NC}
  $0 [command] [scenario] [action]

${YELLOW}${BOLD}COMMANDS:${NC}
  ${GREEN}list${NC}                          📋 List all available scenarios
  ${GREEN}run <scenario> <action>${NC}       🚀 Run a specific scenario with action
  ${GREEN}status <scenario>${NC}             📊 Check status of a scenario
  ${GREEN}cleanup${NC}                       🧹 Clean up all scenarios
  ${GREEN}interactive${NC}                   🎮 Start interactive mode (recommended)
  ${GREEN}portal${NC}                        📊 Launch progress portal
  ${GREEN}help${NC}                          ❓ Show this help message

${YELLOW}${BOLD}SCENARIOS:${NC}
EOF

    for scenario in "${SCENARIOS[@]}"; do
        local scenario_info=$(get_scenario_info "$scenario")
        IFS='|' read -r title difficulty description duration <<< "$scenario_info"
        echo -e "  ${GREEN}$scenario${NC}  $title"
    done

    cat << EOF

${YELLOW}${BOLD}ACTIONS:${NC}
  ${GREEN}inject|start${NC}                  💥 Start the scenario (inject faults)
  ${GREEN}restore|fix|solve${NC}             🏥 Fix the scenario (show solutions)
  ${GREEN}status|check${NC}                  📊 Check current status

${YELLOW}${BOLD}EXAMPLES:${NC}
  ${CYAN}$0${NC}                                    🎮 Start interactive mode
  ${CYAN}$0 list${NC}                               📋 List all scenarios
  ${CYAN}$0 run pod-startup-failures inject${NC}    💥 Start pod startup scenario
  ${CYAN}$0 run dns-issues restore${NC}             🏥 Fix DNS issues scenario
  ${CYAN}$0 status pod-startup-failures${NC}        📊 Check pod scenario status
  ${CYAN}$0 portal${NC}                             📊 Launch progress portal
  ${CYAN}$0 interactive${NC}                        🎮 Launch mission control center

${YELLOW}${BOLD}PREREQUISITES:${NC}
  ✅ Running EKS cluster
  ✅ kubectl configured
  ✅ Appropriate AWS permissions

${YELLOW}${BOLD}CLUSTER SETUP:${NC}
  Run ${GREEN}'./cluster-setup.sh'${NC} to create a new EKS cluster for the workshop.

${YELLOW}${BOLD}NEED HELP?${NC}
  Start with ${GREEN}'$0 interactive'${NC} for the best experience! 🚀
EOF
}

# Main execution with enhanced error handling
main() {
    case "${1:-interactive}" in
        "list")
            list_scenarios
            ;;
        "run")
            # Check cluster connectivity for run commands
            check_cluster
            if [ $# -lt 3 ]; then
                print_error "Usage: $0 run <scenario> <action>"
                show_help
                exit 1
            fi
            run_scenario "$2" "$3"
            ;;
        "status")
            # Check cluster connectivity for status commands
            check_cluster
            if [ $# -lt 2 ]; then
                print_error "Usage: $0 status <scenario>"
                show_help
                exit 1
            fi
            check_scenario_status "$2"
            ;;
        "cleanup")
            # Check cluster connectivity for cleanup
            check_cluster
            cleanup_all
            ;;
        "interactive")
            # Check cluster connectivity for interactive mode
            check_cluster
            # Launch progress portal if not already running
            launch_progress_portal_if_needed
            interactive_mode
            ;;
        "portal")
            launch_progress_portal
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            if [ $# -eq 0 ]; then
                # Check cluster connectivity for default interactive mode
                check_cluster
                interactive_mode
            else
                print_error "Unknown command: $1"
                show_help
                exit 1
            fi
            ;;
    esac
}

# Make scripts executable
chmod +x scenarios/*/inject-fault.sh 2>/dev/null || true
chmod +x scenarios/*/restore-cluster.sh 2>/dev/null || true
chmod +x troubleshooting-toolkit.sh 2>/dev/null || true
chmod +x cluster-setup.sh 2>/dev/null || true

main "$@"
