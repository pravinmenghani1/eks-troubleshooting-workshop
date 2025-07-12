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

# Progressive hint system
show_hints() {
    local scenario=$1
    local scenario_info=$(get_scenario_info "$scenario")
    IFS='|' read -r title difficulty description duration <<< "$scenario_info"
    
    print_section_header "💡 PROGRESSIVE HINTS FOR $title"
    
    case $scenario in
        "pod-startup-failures")
            show_pod_startup_hints
            ;;
        "dns-issues")
            show_dns_hints
            ;;
        "rbac-issues")
            show_rbac_hints
            ;;
        "node-not-ready")
            show_node_hints
            ;;
        "image-pull-errors")
            show_image_pull_hints
            ;;
        *)
            print_error "No hints available for scenario: $scenario"
            ;;
    esac
}

# Pod Startup Failures Hints
show_pod_startup_hints() {
    echo -e "${YELLOW}${BOLD}🐛 Pod Startup Failures - Progressive Hints${NC}\n"
    
    echo -e "${CYAN}${BOLD}Level 1 Hints (Start Here):${NC}"
    echo -e "${GREEN}💡 Hint 1:${NC} Always start with 'kubectl get pods -A' to see the overall status"
    echo -e "${GREEN}💡 Hint 2:${NC} Look for pods in 'Pending', 'ImagePullBackOff', or 'CrashLoopBackOff' states"
    echo -e "${GREEN}💡 Hint 3:${NC} Use 'kubectl describe pod <pod-name>' to get detailed information"
    echo ""
    
    echo -e "${CYAN}${BOLD}Level 2 Hints (If Still Stuck):${NC}"
    echo -e "${BLUE}🔍 Hint 4:${NC} Check events with 'kubectl get events --sort-by=.metadata.creationTimestamp'"
    echo -e "${BLUE}🔍 Hint 5:${NC} For ImagePullBackOff: Check image name, registry access, and credentials"
    echo -e "${BLUE}🔍 Hint 6:${NC} For Pending pods: Check node resources with 'kubectl top nodes'"
    echo -e "${BLUE}🔍 Hint 7:${NC} For CrashLoopBackOff: Check logs with 'kubectl logs <pod-name>'"
    echo ""
    
    echo -e "${CYAN}${BOLD}Level 3 Hints (Deep Debugging):${NC}"
    echo -e "${PURPLE}🎯 Hint 8:${NC} Check resource requests/limits in pod specifications"
    echo -e "${PURPLE}🎯 Hint 9:${NC} Verify secrets exist: 'kubectl get secrets'"
    echo -e "${PURPLE}🎯 Hint 10:${NC} Check node selectors and taints: 'kubectl describe nodes'"
    echo -e "${PURPLE}🎯 Hint 11:${NC} For persistent issues, check admission controllers and policies"
    echo ""
    
    echo -e "${CYAN}${BOLD}Common Commands for This Scenario:${NC}"
    cat << 'EOF'
# Essential debugging commands
kubectl get pods -A -o wide
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace>
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl top nodes
kubectl top pods -A
kubectl get secrets -A
kubectl describe nodes

# Check specific issues
kubectl get pods --field-selector=status.phase=Pending
kubectl get pods --field-selector=status.phase=Failed
EOF
    
    echo ""
    echo -e "${YELLOW}${BOLD}🎓 Learning Tip:${NC} Work through hints progressively. Try Level 1 first!"
    echo -e "${GREEN}${BOLD}🚀 Need Solutions?${NC} Run: ./scenario-manager.sh run pod-startup-failures restore"
}

# DNS Issues Hints
show_dns_hints() {
    echo -e "${YELLOW}${BOLD}🌐 DNS Resolution Apocalypse - Progressive Hints${NC}\n"
    
    echo -e "${CYAN}${BOLD}Level 1 Hints (Start Here):${NC}"
    echo -e "${GREEN}💡 Hint 1:${NC} Test DNS resolution with a debug pod: 'kubectl run dns-test --image=busybox --rm -it --restart=Never -- nslookup kubernetes.default'"
    echo -e "${GREEN}💡 Hint 2:${NC} Check CoreDNS pods status: 'kubectl get pods -n kube-system -l k8s-app=kube-dns'"
    echo -e "${GREEN}💡 Hint 3:${NC} Look at CoreDNS logs: 'kubectl logs -n kube-system -l k8s-app=kube-dns'"
    echo ""
    
    echo -e "${CYAN}${BOLD}Level 2 Hints (If Still Stuck):${NC}"
    echo -e "${BLUE}🔍 Hint 4:${NC} Check CoreDNS configuration: 'kubectl get configmap coredns -n kube-system -o yaml'"
    echo -e "${BLUE}🔍 Hint 5:${NC} Verify service endpoints: 'kubectl get endpoints'"
    echo -e "${BLUE}🔍 Hint 6:${NC} Test service discovery: 'kubectl run test --image=busybox --rm -it --restart=Never -- nslookup <service-name>'"
    echo -e "${BLUE}🔍 Hint 7:${NC} Check network policies: 'kubectl get networkpolicies -A'"
    echo ""
    
    echo -e "${CYAN}${BOLD}Level 3 Hints (Deep Debugging):${NC}"
    echo -e "${PURPLE}🎯 Hint 8:${NC} Check kube-dns service: 'kubectl get svc kube-dns -n kube-system'"
    echo -e "${PURPLE}🎯 Hint 9:${NC} Verify DNS policy in pods: Look for 'dnsPolicy' in pod specs"
    echo -e "${PURPLE}🎯 Hint 10:${NC} Check cluster DNS settings: 'kubectl get nodes -o yaml | grep -A 5 -B 5 dns'"
    echo -e "${PURPLE}🎯 Hint 11:${NC} Test external DNS: 'kubectl run test --image=busybox --rm -it --restart=Never -- nslookup google.com'"
    echo ""
    
    echo -e "${CYAN}${BOLD}Common Commands for This Scenario:${NC}"
    cat << 'EOF'
# DNS testing commands
kubectl run dns-test --image=busybox --rm -it --restart=Never -- nslookup kubernetes.default
kubectl run dns-test --image=busybox --rm -it --restart=Never -- nslookup google.com
kubectl run dns-test --image=busybox --rm -it --restart=Never -- cat /etc/resolv.conf

# CoreDNS debugging
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl logs -n kube-system -l k8s-app=kube-dns
kubectl get configmap coredns -n kube-system -o yaml
kubectl get svc kube-dns -n kube-system

# Service discovery
kubectl get services -A
kubectl get endpoints -A
kubectl describe svc <service-name>

# Network policies
kubectl get networkpolicies -A
kubectl describe networkpolicy <policy-name>
EOF
    
    echo ""
    echo -e "${YELLOW}${BOLD}🎓 Learning Tip:${NC} DNS issues often involve CoreDNS configuration or network policies!"
    echo -e "${GREEN}${BOLD}🚀 Need Solutions?${NC} Run: ./scenario-manager.sh run dns-issues restore"
}

# RBAC Issues Hints
show_rbac_hints() {
    echo -e "${YELLOW}${BOLD}🔐 RBAC Permission Nightmare - Progressive Hints${NC}\n"
    
    echo -e "${CYAN}${BOLD}Level 1 Hints (Start Here):${NC}"
    echo -e "${GREEN}💡 Hint 1:${NC} Test permissions with 'kubectl auth can-i <verb> <resource>'"
    echo -e "${GREEN}💡 Hint 2:${NC} Check what you can do: 'kubectl auth can-i --list'"
    echo -e "${GREEN}💡 Hint 3:${NC} Look for 'Forbidden' errors in kubectl output"
    echo ""
    
    echo -e "${CYAN}${BOLD}Level 2 Hints (If Still Stuck):${NC}"
    echo -e "${BLUE}🔍 Hint 4:${NC} Check service accounts: 'kubectl get serviceaccounts -A'"
    echo -e "${BLUE}🔍 Hint 5:${NC} List roles and role bindings: 'kubectl get roles,rolebindings -A'"
    echo -e "${BLUE}🔍 Hint 6:${NC} Check cluster roles: 'kubectl get clusterroles,clusterrolebindings'"
    echo -e "${BLUE}🔍 Hint 7:${NC} Test as specific user: 'kubectl auth can-i <verb> <resource> --as=<user>'"
    echo ""
    
    echo -e "${CYAN}${BOLD}Level 3 Hints (Deep Debugging):${NC}"
    echo -e "${PURPLE}🎯 Hint 8:${NC} Describe role bindings: 'kubectl describe rolebinding <binding-name>'"
    echo -e "${PURPLE}🎯 Hint 9:${NC} Check pod's service account: 'kubectl get pod <pod-name> -o yaml | grep serviceAccount'"
    echo -e "${PURPLE}🎯 Hint 10:${NC} Verify service account tokens: 'kubectl describe serviceaccount <sa-name>'"
    echo -e "${PURPLE}🎯 Hint 11:${NC} Check for missing subjects in role bindings"
    echo ""
    
    echo -e "${CYAN}${BOLD}Common Commands for This Scenario:${NC}"
    cat << 'EOF'
# Permission testing
kubectl auth can-i get pods
kubectl auth can-i create deployments
kubectl auth can-i --list
kubectl auth can-i get pods --as=system:serviceaccount:default:my-sa

# RBAC resources
kubectl get serviceaccounts -A
kubectl get roles -A
kubectl get rolebindings -A
kubectl get clusterroles
kubectl get clusterrolebindings

# Detailed inspection
kubectl describe serviceaccount <sa-name>
kubectl describe role <role-name>
kubectl describe rolebinding <binding-name>
kubectl describe clusterrole <cluster-role-name>
kubectl describe clusterrolebinding <cluster-binding-name>

# Pod service account
kubectl get pod <pod-name> -o yaml | grep -A 5 serviceAccount
EOF
    
    echo ""
    echo -e "${YELLOW}${BOLD}🎓 Learning Tip:${NC} RBAC issues are usually missing role bindings or incorrect service accounts!"
    echo -e "${GREEN}${BOLD}🚀 Need Solutions?${NC} Run: ./scenario-manager.sh run rbac-issues restore"
}

# Node Health Hints
show_node_hints() {
    echo -e "${YELLOW}${BOLD}🖥️ Node Health Crisis - Progressive Hints${NC}\n"
    
    echo -e "${CYAN}${BOLD}Level 1 Hints (Start Here):${NC}"
    echo -e "${GREEN}💡 Hint 1:${NC} Check node status: 'kubectl get nodes'"
    echo -e "${GREEN}💡 Hint 2:${NC} Look for 'NotReady' or 'Unknown' node states"
    echo -e "${GREEN}💡 Hint 3:${NC} Check node details: 'kubectl describe node <node-name>'"
    echo ""
    
    echo -e "${CYAN}${BOLD}Level 2 Hints (If Still Stuck):${NC}"
    echo -e "${BLUE}🔍 Hint 4:${NC} Check node resources: 'kubectl top nodes'"
    echo -e "${BLUE}🔍 Hint 5:${NC} Look at node conditions in 'kubectl describe node' output"
    echo -e "${BLUE}🔍 Hint 6:${NC} Check kubelet logs on the node (if accessible)"
    echo -e "${BLUE}🔍 Hint 7:${NC} Verify node capacity vs allocatable resources"
    echo ""
    
    echo -e "${CYAN}${BOLD}Level 3 Hints (Deep Debugging):${NC}"
    echo -e "${PURPLE}🎯 Hint 8:${NC} Check for resource pressure: disk, memory, PID pressure"
    echo -e "${PURPLE}🎯 Hint 9:${NC} Look for taints on nodes: 'kubectl describe node | grep -A 5 Taints'"
    echo -e "${PURPLE}🎯 Hint 10:${NC} Check pod distribution: 'kubectl get pods -A -o wide'"
    echo -e "${PURPLE}🎯 Hint 11:${NC} Verify cluster autoscaler logs if using autoscaling"
    echo ""
    
    echo -e "${CYAN}${BOLD}Common Commands for This Scenario:${NC}"
    cat << 'EOF'
# Node status
kubectl get nodes
kubectl get nodes -o wide
kubectl describe node <node-name>
kubectl top nodes

# Resource usage
kubectl top pods -A
kubectl describe node <node-name> | grep -A 5 "Allocated resources"
kubectl get pods -A -o wide --sort-by=.spec.nodeName

# Node conditions and events
kubectl get events --field-selector involvedObject.kind=Node
kubectl describe node <node-name> | grep -A 10 Conditions
kubectl describe node <node-name> | grep -A 5 Taints

# Troubleshooting
kubectl get pods -A --field-selector=status.phase=Pending
kubectl get pods -A --field-selector=spec.nodeName=<node-name>
EOF
    
    echo ""
    echo -e "${YELLOW}${BOLD}🎓 Learning Tip:${NC} Node issues often involve resource exhaustion or kubelet problems!"
    echo -e "${GREEN}${BOLD}🚀 Need Solutions?${NC} Run: ./scenario-manager.sh run node-not-ready restore"
}

# Image Pull Errors Hints
show_image_pull_hints() {
    echo -e "${YELLOW}${BOLD}📦 Image Registry Disasters - Progressive Hints${NC}\n"
    
    echo -e "${CYAN}${BOLD}Level 1 Hints (Start Here):${NC}"
    echo -e "${GREEN}💡 Hint 1:${NC} Look for 'ImagePullBackOff' or 'ErrImagePull' pod status"
    echo -e "${GREEN}💡 Hint 2:${NC} Check the exact error: 'kubectl describe pod <pod-name>'"
    echo -e "${GREEN}💡 Hint 3:${NC} Verify the image name and tag in the pod specification"
    echo ""
    
    echo -e "${CYAN}${BOLD}Level 2 Hints (If Still Stuck):${NC}"
    echo -e "${BLUE}🔍 Hint 4:${NC} Check if image exists: Try pulling manually with 'docker pull <image>'"
    echo -e "${BLUE}🔍 Hint 5:${NC} For private registries, check image pull secrets: 'kubectl get secrets'"
    echo -e "${BLUE}🔍 Hint 6:${NC} Verify service account has access to image pull secrets"
    echo -e "${BLUE}🔍 Hint 7:${NC} Check registry authentication and network connectivity"
    echo ""
    
    echo -e "${CYAN}${BOLD}Level 3 Hints (Deep Debugging):${NC}"
    echo -e "${PURPLE}🎯 Hint 8:${NC} Check node's ability to reach registry: Network policies, firewalls"
    echo -e "${PURPLE}🎯 Hint 9:${NC} Verify image pull secret format: 'kubectl get secret <secret> -o yaml'"
    echo -e "${PURPLE}🎯 Hint 10:${NC} Check if using correct registry URL (especially for ECR)"
    echo -e "${PURPLE}🎯 Hint 11:${NC} For ECR: Verify IAM permissions and token expiration"
    echo ""
    
    echo -e "${CYAN}${BOLD}Common Commands for This Scenario:${NC}"
    cat << 'EOF'
# Image pull debugging
kubectl get pods --field-selector=status.phase=Pending
kubectl describe pod <pod-name>
kubectl get events --field-selector reason=Failed

# Image pull secrets
kubectl get secrets
kubectl get secrets -o yaml
kubectl describe secret <image-pull-secret>

# Service account secrets
kubectl get serviceaccount <sa-name> -o yaml
kubectl describe serviceaccount <sa-name>

# Registry testing (if docker available)
docker pull <image-name>
docker login <registry-url>

# ECR specific (if using ECR)
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account>.dkr.ecr.<region>.amazonaws.com
aws ecr describe-repositories
EOF
    
    echo ""
    echo -e "${YELLOW}${BOLD}🎓 Learning Tip:${NC} Image pull issues are usually authentication or network related!"
    echo -e "${GREEN}${BOLD}🚀 Need Solutions?${NC} Run: ./scenario-manager.sh run image-pull-errors restore"
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
        echo -e "${GREEN}5.${NC} 💡 Get hints for a scenario"
        echo -e "${GREEN}6.${NC} 🧹 Clean up all scenarios"
        echo -e "${GREEN}7.${NC} 🔍 Run cluster health check"
        echo -e "${GREEN}8.${NC} 🚪 Exit mission control"
        
        echo -e "\n${PURPLE}${BOLD}Enter your choice (1-8):${NC} "
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
                echo ""
                list_scenarios
                echo -e "${YELLOW}${BOLD}Enter scenario number for hints:${NC} "
                read -r scenario_num
                
                if [[ "$scenario_num" =~ ^[1-9][0-9]*$ ]] && [ "$scenario_num" -le "${#SCENARIOS[@]}" ]; then
                    local scenario="${SCENARIOS[$((scenario_num - 1))]}"
                    show_hints "$scenario"
                else
                    print_error "Invalid scenario number"
                fi
                ;;
            6)
                cleanup_all
                ;;
            7)
                ./troubleshooting-toolkit.sh
                ;;
            8)
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
  ${GREEN}hint <scenario>${NC}               💡 Get progressive hints for a scenario
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
  ${CYAN}$0 hint pod-startup-failures${NC}          💡 Get hints for pod issues
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
        "hint")
            # Provide hints for scenarios
            if [ $# -lt 2 ]; then
                print_error "Usage: $0 hint <scenario>"
                show_help
                exit 1
            fi
            show_hints "$2"
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
