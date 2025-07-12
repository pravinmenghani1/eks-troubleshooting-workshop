#!/bin/bash

# Enhanced Visual Node Health Crisis Fault Injection Script
# This script creates node health chaos with spectacular visual feedback

set -e

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
NODE="🖥️"
MEMORY="💾"
CPU="⚡"
DISK="💿"
NETWORK="🌐"
BROKEN="💥"

# Utility functions for colored output
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

# Visual progress function
show_progress() {
    local message=$1
    local duration=${2:-3}
    
    echo -e "${CYAN}$message${NC}"
    for i in $(seq 1 $duration); do
        printf "\r${BLUE}⠋ Working...${NC}"
        sleep 0.2
        printf "\r${BLUE}⠙ Working...${NC}"
        sleep 0.2
        printf "\r${BLUE}⠹ Working...${NC}"
        sleep 0.2
        printf "\r${BLUE}⠸ Working...${NC}"
        sleep 0.2
        printf "\r${BLUE}⠼ Working...${NC}"
        sleep 0.2
    done
    printf "\r"
}

# Create namespace for node health chaos
create_node_namespace() {
    print_header "Creating Node Health Crisis Arena"
    
    cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: troubleshooting-node
  labels:
    workshop: eks-troubleshooting
    scenario: node-health-crisis
EOF

    show_progress "Setting up node health troubleshooting environment" 2
    print_success "Node health crisis namespace created successfully!"
}

# Inject Fault 1: Resource exhaustion pods
inject_resource_exhaustion() {
    print_header "Fault 1: Node Resource Exhaustion Attack"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │                NODE RESOURCE EXHAUSTION                      │
    │                                                             │
    │  Memory Hogs: 10 pods requesting 2Gi each                  │
    │  CPU Burners: 5 pods requesting 4 cores each               │
    │  Disk Fillers: 3 pods with huge storage requests           │
    │                                                             │
    │  Result: Nodes overwhelmed, pods stuck Pending! 💥         │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    # Memory exhaustion deployment
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: memory-hog
  namespace: troubleshooting-node
  labels:
    app: memory-hog
spec:
  replicas: 10
  selector:
    matchLabels:
      app: memory-hog
  template:
    metadata:
      labels:
        app: memory-hog
    spec:
      containers:
      - name: memory-consumer
        image: nginx:latest
        resources:
          requests:
            memory: "2Gi"
            cpu: "100m"
          limits:
            memory: "2Gi"
            cpu: "200m"
        command: ["/bin/sh"]
        args: ["-c", "while true; do sleep 30; done"]
EOF

    # CPU exhaustion deployment
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cpu-burner
  namespace: troubleshooting-node
  labels:
    app: cpu-burner
spec:
  replicas: 5
  selector:
    matchLabels:
      app: cpu-burner
  template:
    metadata:
      labels:
        app: cpu-burner
    spec:
      containers:
      - name: cpu-consumer
        image: nginx:latest
        resources:
          requests:
            cpu: "4000m"
            memory: "100Mi"
          limits:
            cpu: "4000m"
            memory: "200Mi"
        command: ["/bin/sh"]
        args: ["-c", "while true; do sleep 30; done"]
EOF

    show_progress "Deploying resource exhaustion applications" 3
    print_error "Resource exhaustion pods deployed! Nodes will be overwhelmed!"
}

# Inject Fault 2: Node affinity impossible requirements
inject_impossible_affinity() {
    print_header "Fault 2: Impossible Node Affinity Requirements"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │              IMPOSSIBLE NODE REQUIREMENTS                    │
    │                                                             │
    │  Required Labels: nonexistent-zone=mars                    │
    │  Required Labels: instance-type=super-computer              │
    │  Required Labels: gpu=quantum-processor                     │
    │                                                             │
    │  Result: Pods forever Pending! 🚫                          │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: impossible-affinity-app
  namespace: troubleshooting-node
  labels:
    app: impossible-affinity
spec:
  replicas: 3
  selector:
    matchLabels:
      app: impossible-affinity
  template:
    metadata:
      labels:
        app: impossible-affinity
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: nonexistent-zone
                operator: In
                values:
                - mars
              - key: instance-type
                operator: In
                values:
                - super-computer
              - key: gpu
                operator: In
                values:
                - quantum-processor
      containers:
      - name: impossible-app
        image: nginx:latest
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
EOF

    show_progress "Deploying impossible node affinity requirements" 2
    print_error "Impossible affinity requirements deployed! Pods will never schedule!"
}

# Inject Fault 3: Taint intolerant pods
inject_taint_intolerance() {
    print_header "Fault 3: Taint Intolerant Pod Deployment"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │                 TAINT INTOLERANCE CHAOS                      │
    │                                                             │
    │  Pods: No tolerations configured                            │
    │  Nodes: May have taints that repel pods                    │
    │  Scheduling: Blocked by taint/toleration mismatch          │
    │                                                             │
    │  Result: Pods rejected by tainted nodes! 🚫                │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    # First, let's add a taint to one of the nodes (if possible)
    echo -e "${YELLOW}Attempting to add taints to nodes for demonstration...${NC}"
    
    # Get the first worker node
    WORKER_NODE=$(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep -v master | head -1)
    
    if [ -n "$WORKER_NODE" ]; then
        # Add a taint to the node
        kubectl taint node "$WORKER_NODE" workshop=node-health-crisis:NoSchedule --overwrite || true
        print_warning "Added taint to node: $WORKER_NODE"
    fi

    # Deploy pods without tolerations
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: taint-intolerant-app
  namespace: troubleshooting-node
  labels:
    app: taint-intolerant
spec:
  replicas: 4
  selector:
    matchLabels:
      app: taint-intolerant
  template:
    metadata:
      labels:
        app: taint-intolerant
    spec:
      containers:
      - name: intolerant-app
        image: nginx:latest
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
        ports:
        - containerPort: 80
EOF

    show_progress "Deploying taint intolerant applications" 2
    print_error "Taint intolerant pods deployed! Some may be rejected by tainted nodes!"
}

# Inject Fault 4: Pod disruption budget blocking
inject_pdb_blocking() {
    print_header "Fault 4: Pod Disruption Budget Blocking Scenario"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │              POD DISRUPTION BUDGET CHAOS                     │
    │                                                             │
    │  PDB: Requires 100% pods available (impossible!)           │
    │  Replicas: 3 pods                                          │
    │  Updates: Blocked by overly restrictive PDB                │
    │                                                             │
    │  Result: Rolling updates stuck! 🔄❌                        │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    # Create deployment first
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pdb-blocked-app
  namespace: troubleshooting-node
  labels:
    app: pdb-blocked
spec:
  replicas: 3
  selector:
    matchLabels:
      app: pdb-blocked
  template:
    metadata:
      labels:
        app: pdb-blocked
    spec:
      containers:
      - name: blocked-app
        image: nginx:1.20
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
        ports:
        - containerPort: 80
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: overly-restrictive-pdb
  namespace: troubleshooting-node
spec:
  minAvailable: 100%
  selector:
    matchLabels:
      app: pdb-blocked
EOF

    # Wait a moment then trigger an update that will be blocked
    sleep 5
    kubectl patch deployment pdb-blocked-app -n troubleshooting-node \
        -p '{"spec":{"template":{"spec":{"containers":[{"name":"blocked-app","image":"nginx:latest"}]}}}}'

    show_progress "Deploying PDB-blocked application and triggering update" 2
    print_error "Overly restrictive PDB deployed! Rolling updates will be blocked!"
}

# Create troubleshooting guide
create_node_guide() {
    print_header "Creating Node Health Crisis Troubleshooting Guide"
    
    cat > node-health-troubleshooting-guide.md << 'EOF'
# 🖥️ Node Health Crisis - Troubleshooting Guide

## 🎯 Mission Objective
Fix all node health and scheduling issues to get applications running properly!

## 🚨 Current Issues

### 1. Resource Exhaustion (memory-hog, cpu-burner)
- **Symptom**: Pods stuck in Pending state
- **Error**: `Insufficient memory/cpu`
- **Root Cause**: Pods requesting more resources than available on nodes

### 2. Impossible Node Affinity (impossible-affinity-app)
- **Symptom**: Pods permanently Pending
- **Error**: `0/X nodes are available: X node(s) didn't match Pod's node affinity/selector`
- **Root Cause**: Required node labels don't exist on any nodes

### 3. Taint Intolerance (taint-intolerant-app)
- **Symptom**: Some pods Pending or not scheduling on certain nodes
- **Error**: `0/X nodes are available: X node(s) had taint that the pod didn't tolerate`
- **Root Cause**: Nodes have taints but pods lack tolerations

### 4. Pod Disruption Budget Blocking (pdb-blocked-app)
- **Symptom**: Rolling update stuck, old pods not terminating
- **Error**: `cannot evict pod as it would violate the pod's disruption budget`
- **Root Cause**: PDB too restrictive (requires 100% availability)

## 🔍 Troubleshooting Commands

### Check Node Status and Resources
```bash
kubectl get nodes
kubectl describe nodes
kubectl top nodes  # Requires metrics-server
```

### Check Pod Scheduling Issues
```bash
kubectl get pods -n troubleshooting-node
kubectl describe pod <pod-name> -n troubleshooting-node
kubectl get events -n troubleshooting-node --sort-by='.lastTimestamp'
```

### Check Node Taints and Labels
```bash
kubectl describe node <node-name>
kubectl get nodes --show-labels
```

### Check Pod Disruption Budgets
```bash
kubectl get pdb -n troubleshooting-node
kubectl describe pdb <pdb-name> -n troubleshooting-node
```

### Check Resource Usage
```bash
kubectl describe node <node-name> | grep -A 5 "Allocated resources"
```

## 🔧 Fixes Needed

### Fix 1: Reduce Resource Requests
```bash
# Reduce memory-hog replicas and resource requests
kubectl scale deployment memory-hog -n troubleshooting-node --replicas=2
kubectl patch deployment memory-hog -n troubleshooting-node \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"memory-consumer","resources":{"requests":{"memory":"256Mi"}}}]}}}}'

# Reduce cpu-burner replicas and resource requests  
kubectl scale deployment cpu-burner -n troubleshooting-node --replicas=1
kubectl patch deployment cpu-burner -n troubleshooting-node \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"cpu-consumer","resources":{"requests":{"cpu":"500m"}}}]}}}}'
```

### Fix 2: Remove Impossible Node Affinity
```bash
kubectl patch deployment impossible-affinity-app -n troubleshooting-node \
  -p '{"spec":{"template":{"spec":{"affinity":null}}}}'
```

### Fix 3: Add Tolerations or Remove Taints
```bash
# Option A: Add tolerations to pods
kubectl patch deployment taint-intolerant-app -n troubleshooting-node \
  -p '{"spec":{"template":{"spec":{"tolerations":[{"key":"workshop","operator":"Equal","value":"node-health-crisis","effect":"NoSchedule"}]}}}}'

# Option B: Remove taint from node (find node name first)
kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | head -1 | xargs -I {} kubectl taint node {} workshop:NoSchedule-
```

### Fix 4: Fix Pod Disruption Budget
```bash
kubectl patch pdb overly-restrictive-pdb -n troubleshooting-node \
  -p '{"spec":{"minAvailable":"50%"}}'
```

## 🎓 Advanced Troubleshooting

### Check Node Conditions
```bash
kubectl get nodes -o custom-columns=NAME:.metadata.name,STATUS:.status.conditions[-1].type,REASON:.status.conditions[-1].reason
```

### Check Scheduler Events
```bash
kubectl get events --all-namespaces --field-selector reason=FailedScheduling
```

### Check Resource Quotas (if any)
```bash
kubectl get resourcequota -n troubleshooting-node
```

## ✅ Success Criteria
- All pods show "Running" status (except intentionally scaled down ones)
- No pods stuck in Pending state due to scheduling issues
- Rolling updates complete successfully
- Node resources are not over-allocated

## 🆘 Emergency Reset
If you get completely stuck, run:
```bash
./restore-cluster.sh
```

## 💡 Learning Points
- Node resource capacity limits pod scheduling
- Node affinity/selectors must match existing node labels
- Taints and tolerations control pod placement
- Pod Disruption Budgets can block updates if too restrictive
- Always check node conditions and available resources
- Use `kubectl describe` to see detailed scheduling failures
EOF

    show_progress "Creating comprehensive node health troubleshooting guide" 2
    print_success "Node health troubleshooting guide created!"
}

# Show current node status
show_node_status() {
    print_header "Node Health Crisis Dashboard"
    
    echo -e "${RED}${BOLD}Monitoring node health disasters...${NC}"
    show_progress "Letting node chaos reach maximum entropy" 4
    
    echo -e "\n${YELLOW}${BOLD}🖥️ NODE HEALTH INFRASTRUCTURE STATUS:${NC}\n"
    
    echo -e "${CYAN}Nodes:${NC}"
    kubectl get nodes
    
    echo -e "\n${CYAN}Deployments:${NC}"
    kubectl get deployments -n troubleshooting-node
    
    echo -e "\n${CYAN}Pods (showing scheduling failures):${NC}"
    kubectl get pods -n troubleshooting-node
    
    echo -e "\n${CYAN}Pod Disruption Budgets:${NC}"
    kubectl get pdb -n troubleshooting-node
    
    echo -e "\n${RED}${BOLD}⚠️  RECENT NODE HEALTH DISASTERS:${NC}\n"
    kubectl get events -n troubleshooting-node --sort-by='.lastTimestamp' | tail -15
    
    echo -e "\n${CYAN}Node Resource Allocation Summary:${NC}"
    kubectl describe nodes | grep -A 5 "Allocated resources" | head -20
}

# Main execution function
main() {
    clear
    echo -e "${PURPLE}${BOLD}"
    cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    🖥️ NODE HEALTH CRISIS 🖥️                                                ║
║                                                                              ║
║    Prepare for total node chaos! Resources exhausted! Scheduling broken! 💥 ║
║                                                                              ║
║    Your mission: Restore order to the node universe! 🚀                    ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

EOF
    echo -e "${NC}"

    echo -e "${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  🏗️  INITIALIZING NODE HEALTH CHAOS CHAMBER${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    create_node_namespace
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  💥 FAULT #1: NODE RESOURCE EXHAUSTION${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    inject_resource_exhaustion
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  🚫 FAULT #2: IMPOSSIBLE NODE AFFINITY${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    inject_impossible_affinity
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  🏷️  FAULT #3: TAINT INTOLERANCE CHAOS${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    inject_taint_intolerance
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  🔄 FAULT #4: POD DISRUPTION BUDGET BLOCKING${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    inject_pdb_blocking
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  📚 CREATING NODE HEALTH TROUBLESHOOTING GUIDE${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    create_node_guide
    
    echo -e "\n${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║  📊 NODE HEALTH CHAOS DASHBOARD${NC}"
    echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    show_node_status
    
    echo -e "\n${BLUE}${BOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}${BOLD}║  🎯 NODE HEALTH RESCUE MISSION BRIEFING${NC}"
    echo -e "${BLUE}${BOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    echo -e "${YELLOW}${BOLD}"
    cat << 'EOF'

    ┌─────────────────────────────────────────────────────────────┐
    │                    MISSION OBJECTIVES                       │
    │                                                             │
    │  💾 Fix resource exhaustion issues                         │
    │  🏷️  Remove impossible node affinity requirements          │
    │  🚫 Resolve taint/toleration mismatches                    │
    │  🔄 Fix overly restrictive Pod Disruption Budgets         │
    │  📊 Ensure healthy node resource utilization              │
    │                                                             │
    │  Success: All pods scheduled and running properly! 🎉      │
    └─────────────────────────────────────────────────────────────┘

EOF
    echo -e "${NC}"

    echo -e "${GREEN}${BOLD}🚀 READY TO RESTORE NODE HEALTH?${NC}"
    echo -e "${CYAN}1. Read the node-health-troubleshooting-guide.md${NC}"
    echo -e "${CYAN}2. Check node status and resource availability${NC}"
    echo -e "${CYAN}3. Fix resource requests and scheduling constraints${NC}"
    echo -e "${CYAN}4. Verify all pods can schedule successfully${NC}"
    echo -e "${CYAN}5. Celebrate when all nodes are healthy! 🎉${NC}"
    
    echo -e "\n${RED}${BOLD}🆘 EMERGENCY RESTORATION: ./restore-cluster.sh${NC}"
    
    echo -e "\n${RED}${BOLD}🔥 NODE HEALTH CRISIS COMPLETE! 🔥${NC}"
    echo -e "${PURPLE}${BOLD}The node universe is in chaos! Time to restore order! 🖥️${NC}"
}

# Run main function
main "$@"
