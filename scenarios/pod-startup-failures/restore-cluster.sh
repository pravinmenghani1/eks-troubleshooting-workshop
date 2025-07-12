#!/bin/bash

# Enhanced Visual Restoration Script - Pod Startup Failures
# This script fixes all pod startup issues with spectacular visual feedback

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
MAGIC="✨"
TROPHY="🏆"
FIRE="🔥"
HEART="❤️"

print_banner() {
    clear
    echo -e "${GREEN}${BOLD}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    🏥 POD STARTUP RECOVERY CENTER 🏥                                        ║
║                                                                              ║
║    Time to heal all the broken pods! 💊                                     ║
║    Watch as chaos transforms into harmony! ✨                               ║
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

print_step() {
    echo -e "${YELLOW}${BOLD}▶ $1${NC}"
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

# Healing progress animation
show_healing_progress() {
    local duration=$1
    local message=$2
    echo -e "${GREEN}${message}${NC}"
    
    local hearts="❤️ 💚 💙 💜 🧡"
    local delay=0.2
    local iterations=$((duration * 5))
    
    for ((i=0; i<iterations; i++)); do
        local heart_array=($hearts)
        local heart=${heart_array[$((i % ${#heart_array[@]}))]}
        printf "\r${GREEN}%s Healing in progress...${NC}" "$heart"
        sleep $delay
    done
    echo ""
}

# Before and after comparison
show_before_after() {
    local app_name=$1
    local before_status=$2
    local after_status=$3
    
    echo -e "${CYAN}${BOLD}"
    cat << EOF
    ┌─────────────────────────────────────────────────────────────┐
    │                    HEALING SUMMARY                          │
    │                                                             │
    │  Application: $app_name                                     │
    │  Before: $before_status ❌                                  │
    │  After:  $after_status ✅                                   │
    │                                                             │
    │  Status: HEALED! 💚                                        │
    └─────────────────────────────────────────────────────────────┘
EOF
    echo -e "${NC}"
}

fix_image_pull_issue() {
    print_section_header "🖼️  HEALING #1: IMAGE PULL RECOVERY"
    
    echo -e "${BLUE}${BOLD}Diagnosis:${NC} App was using non-existent image tag 'nginx:nonexistent-tag-12345'"
    echo -e "${GREEN}${BOLD}Treatment:${NC} Prescribing valid nginx image tag"
    
    print_step "Administering image tag therapy..."
    
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: broken-image-app
  namespace: troubleshooting-pod-startup
  labels:
    scenario: image-pull-error-fixed
    status: "healed"
  annotations:
    troubleshooting.workshop/fixed-by: "image-tag-therapy"
    troubleshooting.workshop/fix-time: "$(date)"
spec:
  replicas: 2
  selector:
    matchLabels:
      app: broken-image-app
  template:
    metadata:
      labels:
        app: broken-image-app
      annotations:
        troubleshooting.workshop/status: "healthy"
    spec:
      containers:
      - name: web
        image: nginx:latest  # 💊 HEALED: Valid image tag
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
        readinessProbe:  # 💚 BONUS: Health check added
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:   # 💚 BONUS: Liveness check added
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 20
EOF

    show_healing_progress 3 "Applying image tag healing magic"
    show_before_after "broken-image-app" "ImagePullBackOff" "Running"
    print_success "Image pull issue completely healed! 🎉"
}

fix_resource_issue() {
    print_section_header "💾 HEALING #2: RESOURCE CONSTRAINT THERAPY"
    
    echo -e "${BLUE}${BOLD}Diagnosis:${NC} App was requesting 50Gi memory and 20 CPU cores (impossible!)"
    echo -e "${GREEN}${BOLD}Treatment:${NC} Prescribing reasonable resource diet"
    
    print_step "Administering resource reduction therapy..."
    
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: resource-hungry-app
  namespace: troubleshooting-pod-startup
  labels:
    scenario: resource-constraint-fixed
    status: "healed"
  annotations:
    troubleshooting.workshop/fixed-by: "resource-diet-therapy"
    troubleshooting.workshop/fix-time: "$(date)"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: resource-hungry-app
  template:
    metadata:
      labels:
        app: resource-hungry-app
      annotations:
        troubleshooting.workshop/status: "healthy"
    spec:
      containers:
      - name: hungry
        image: nginx:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "128Mi"  # 💊 HEALED: Reasonable memory
            cpu: "100m"      # 💊 HEALED: Reasonable CPU
          limits:
            memory: "256Mi"  # 💊 HEALED: Reasonable limits
            cpu: "200m"      # 💊 HEALED: Reasonable limits
        readinessProbe:  # 💚 BONUS: Health monitoring
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
EOF

    show_healing_progress 2 "Applying resource reduction magic"
    show_before_after "resource-hungry-app" "Pending (Unschedulable)" "Running"
    print_success "Resource constraint completely resolved! 🎉"
}

fix_secret_issue() {
    print_section_header "🔐 HEALING #3: SECRET RESTORATION MAGIC"
    
    echo -e "${BLUE}${BOLD}Diagnosis:${NC} App was referencing non-existent secrets"
    echo -e "${GREEN}${BOLD}Treatment:${NC} Creating the missing secrets with healing powers"
    
    print_step "Conjuring missing secrets from the void..."
    
    # Create the missing secrets with style
    kubectl create secret generic nonexistent-secret \
        --from-literal=password=super-secret-healing-password-123 \
        -n troubleshooting-pod-startup \
        --dry-run=client -o yaml | kubectl apply -f -
    
    kubectl create secret generic missing-api-secret \
        --from-literal=api-key=magical-healing-api-key-xyz789 \
        -n troubleshooting-pod-startup \
        --dry-run=client -o yaml | kubectl apply -f -
    
    # Add healing annotations to the secrets
    kubectl annotate secret nonexistent-secret -n troubleshooting-pod-startup \
        troubleshooting.workshop/created-by="secret-healing-magic" \
        troubleshooting.workshop/heal-time="$(date)"
    
    kubectl annotate secret missing-api-secret -n troubleshooting-pod-startup \
        troubleshooting.workshop/created-by="secret-healing-magic" \
        troubleshooting.workshop/heal-time="$(date)"
    
    show_healing_progress 2 "Materializing secrets from digital ether"
    show_before_after "secret-dependent-app" "CreateContainerConfigError" "Running"
    print_success "Missing secrets successfully materialized! ✨"
}

fix_node_selector_issue() {
    print_section_header "🏷️  HEALING #4: NODE SELECTOR LIBERATION"
    
    echo -e "${BLUE}${BOLD}Diagnosis:${NC} App had impossible node selector requirements"
    echo -e "${GREEN}${BOLD}Treatment:${NC} Removing restrictive node selector chains"
    
    print_step "Breaking the node selector chains..."
    
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-selector-app
  namespace: troubleshooting-pod-startup
  labels:
    scenario: node-selector-issue-fixed
    status: "liberated"
  annotations:
    troubleshooting.workshop/fixed-by: "node-selector-liberation"
    troubleshooting.workshop/fix-time: "$(date)"
spec:
  replicas: 2
  selector:
    matchLabels:
      app: node-selector-app
  template:
    metadata:
      labels:
        app: node-selector-app
      annotations:
        troubleshooting.workshop/status: "free-to-schedule"
    spec:
      # 💊 HEALED: Removed impossible node selector
      containers:
      - name: app
        image: nginx:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
        readinessProbe:  # 💚 BONUS: Health monitoring
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
EOF

    show_healing_progress 2 "Liberating pods from scheduling constraints"
    show_before_after "node-selector-app" "Pending (Unschedulable)" "Running"
    print_success "Node selector constraints completely removed! 🗽"
}

fix_crashloop_issue() {
    print_section_header "💥 HEALING #5: CRASH LOOP RESURRECTION"
    
    echo -e "${BLUE}${BOLD}Diagnosis:${NC} App was designed to crash immediately (very sad!)"
    echo -e "${GREEN}${BOLD}Treatment:${NC} Replacing with stable, happy container"
    
    print_step "Performing crash loop exorcism..."
    
    cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crashloop-app
  namespace: troubleshooting-pod-startup
  labels:
    scenario: crash-loop-fixed
    status: "resurrected"
  annotations:
    troubleshooting.workshop/fixed-by: "crash-loop-exorcism"
    troubleshooting.workshop/fix-time: "$(date)"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: crashloop-app
  template:
    metadata:
      labels:
        app: crashloop-app
      annotations:
        troubleshooting.workshop/status: "stable-and-happy"
    spec:
      containers:
      - name: crasher
        image: nginx:latest  # 💊 HEALED: Stable nginx instead of crashing busybox
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
        readinessProbe:  # 💚 BONUS: Health monitoring
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:   # 💚 BONUS: Automatic healing
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 20
EOF

    show_healing_progress 3 "Exorcising crash demons and installing stability"
    show_before_after "crashloop-app" "CrashLoopBackOff" "Running"
    print_success "Crash loop completely exorcised! App is now stable! 👻➡️😇"
}

wait_for_healing() {
    print_section_header "⏳ WAITING FOR COMPLETE HEALING"
    
    print_step "Monitoring healing progress across all applications..."
    
    echo -e "${CYAN}Waiting for all deployments to achieve enlightenment...${NC}"
    kubectl wait --for=condition=available --timeout=300s deployment --all -n troubleshooting-pod-startup
    
    show_healing_progress 5 "Final healing energy being distributed"
    print_success "All applications have achieved perfect health! 🌟"
}

show_healing_dashboard() {
    print_section_header "📊 HEALING SUCCESS DASHBOARD"
    
    echo -e "${GREEN}${BOLD}🏥 PATIENT STATUS BOARD:${NC}\n"
    
    kubectl get pods -n troubleshooting-pod-startup -o wide
    
    echo -e "\n${GREEN}${BOLD}🏥 DEPLOYMENT HEALTH STATUS:${NC}\n"
    kubectl get deployments -n troubleshooting-pod-startup
    
    echo -e "\n${GREEN}${BOLD}🔐 SECRET INVENTORY:${NC}\n"
    kubectl get secrets -n troubleshooting-pod-startup
    
    echo -e "\n${GREEN}${BOLD}🎉 RECENT HEALING EVENTS:${NC}\n"
    kubectl get events -n troubleshooting-pod-startup --sort-by=.metadata.creationTimestamp | tail -10
}

create_healing_summary() {
    print_section_header "📋 CREATING HEALING DOCUMENTATION"
    
    cat > healing-success-summary.md << 'EOF'
# 🏥 Pod Startup Failures - Complete Healing Summary

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    🏆 MISSION ACCOMPLISHED! ALL PODS HEALED! 🏆                             ║
║                                                                              ║
║    From chaos to harmony - a troubleshooting success story! ✨              ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## 🎯 Healing Achievements Unlocked

| Patient | Original Condition | Treatment Applied | Final Status |
|---------|-------------------|-------------------|--------------|
| 🖼️ broken-image-app | ImagePullBackOff | Image Tag Therapy | ✅ HEALED |
| 💾 resource-hungry-app | Pending (Resources) | Resource Diet | ✅ HEALED |
| 🔐 secret-dependent-app | ConfigError | Secret Materialization | ✅ HEALED |
| 🏷️ node-selector-app | Unschedulable | Selector Liberation | ✅ HEALED |
| 💥 crashloop-app | CrashLoopBackOff | Stability Exorcism | ✅ HEALED |

## 🔬 Medical Procedures Performed

### 🖼️ **Image Pull Therapy**
```yaml
# Before: nginx:nonexistent-tag-12345 ❌
# After:  nginx:latest ✅
Treatment: Changed to valid, existing image tag
Bonus: Added health checks for monitoring
```

### 💾 **Resource Diet Program**
```yaml
# Before: 50Gi memory, 20 CPU cores ❌
# After:  256Mi memory, 200m CPU ✅
Treatment: Reduced to realistic resource requirements
Learning: Always check node capacity vs pod requests
```

### 🔐 **Secret Materialization Ritual**
```bash
# Created missing secrets:
kubectl create secret generic nonexistent-secret --from-literal=password=xxx
kubectl create secret generic missing-api-secret --from-literal=api-key=xxx
Treatment: Materialized secrets from the digital void
```

### 🏷️ **Node Selector Liberation**
```yaml
# Before: Impossible node selector requirements ❌
# After:  No restrictive selectors ✅
Treatment: Removed impossible scheduling constraints
Freedom: Pods can now schedule on any available node
```

### 💥 **Crash Loop Exorcism**
```yaml
# Before: Busybox designed to crash ❌
# After:  Stable nginx container ✅
Treatment: Replaced self-destructing app with stable service
Bonus: Added comprehensive health monitoring
```

## 🎓 Troubleshooting Wisdom Gained

### 🔍 **Detective Skills Mastered**
```bash
# Essential diagnostic commands:
kubectl get pods -o wide                    # Survey the scene
kubectl describe pod <name>                 # Gather evidence
kubectl logs <name>                         # Read the story
kubectl get events --sort-by=.metadata.creationTimestamp  # Timeline
```

### 🛠️ **Healing Techniques Learned**
1. **Image Issues**: Always verify image tags exist in registry
2. **Resource Issues**: Match requests to actual node capacity
3. **Secret Issues**: Ensure all referenced secrets exist
4. **Scheduling Issues**: Verify node selectors match available nodes
5. **Crash Issues**: Fix application logic or use stable images

### 💡 **Prevention Medicine**
- Use specific image tags instead of `latest` in production
- Set realistic resource requests based on actual usage
- Implement proper secret management workflows
- Use node selectors only when necessary
- Add comprehensive health checks to all containers

## 🏆 Certification of Healing

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│    🏥 KUBERNETES HEALING CERTIFICATION 🏥                  │
│                                                             │
│    This certifies that the bearer has successfully:        │
│    ✅ Diagnosed 5 different pod startup failures           │
│    ✅ Applied appropriate healing treatments                │
│    ✅ Achieved 100% pod health restoration                  │
│    ✅ Mastered essential troubleshooting skills            │
│                                                             │
│    Rank: Pod Startup Failure Healer 🩺                    │
│    Date: $(date)                                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 🎮 Next Level Challenges

Ready for more healing adventures?
- Try the DNS Resolution Apocalypse scenario
- Master RBAC Permission Healing
- Tackle Node Health Restoration
- Become a Kubernetes Troubleshooting Grandmaster!

---
**Congratulations, Kubernetes Healer! Your pods are forever grateful! 🙏✨**
EOF

    print_success "Complete healing documentation created!"
}

show_victory_celebration() {
    print_section_header "🎉 VICTORY CELEBRATION"
    
    echo -e "${GREEN}${BOLD}"
    cat << 'EOF'
    ┌─────────────────────────────────────────────────────────────┐
    │                                                             │
    │    🎊 CONGRATULATIONS! MISSION ACCOMPLISHED! 🎊            │
    │                                                             │
    │    You have successfully healed all broken pods!           │
    │    From ImagePullBackOff to Running - what a journey!      │
    │                                                             │
    │    🏆 ACHIEVEMENTS UNLOCKED:                               │
    │    ├─ 🖼️  Image Pull Master                               │
    │    ├─ 💾 Resource Optimization Expert                      │
    │    ├─ 🔐 Secret Management Wizard                          │
    │    ├─ 🏷️  Node Selector Liberator                         │
    │    └─ 💥 Crash Loop Exorcist                              │
    │                                                             │
    │    Your troubleshooting skills are now legendary! ⚡       │
    │                                                             │
    └─────────────────────────────────────────────────────────────┘
EOF
    echo -e "${NC}"
    
    # Animated celebration
    local celebration_chars="🎉 🎊 ✨ 🌟 💫 ⭐ 🎯 🏆"
    echo -e "\n${GREEN}${BOLD}"
    for i in {1..3}; do
        for char in $celebration_chars; do
            printf "%s " "$char"
            sleep 0.1
        done
        echo ""
    done
    echo -e "${NC}"
}

# Main healing ceremony
main() {
    print_banner
    sleep 2
    
    echo -e "${YELLOW}${BOLD}🏥 Welcome to the Pod Startup Recovery Center! 🏥${NC}"
    echo -e "${CYAN}We're about to heal all your broken pods with advanced Kubernetes medicine!${NC}"
    echo -e "\n${GREEN}Press Enter to begin the healing ceremony or Ctrl+C to cancel...${NC}"
    read -r
    
    fix_image_pull_issue
    sleep 2
    
    fix_resource_issue
    sleep 2
    
    fix_secret_issue
    sleep 2
    
    fix_node_selector_issue
    sleep 2
    
    fix_crashloop_issue
    sleep 2
    
    wait_for_healing
    sleep 1
    
    show_healing_dashboard
    sleep 2
    
    create_healing_summary
    sleep 1
    
    show_victory_celebration
    
    echo -e "\n${GREEN}${BOLD}${TROPHY} ALL HEALING COMPLETE! ${TROPHY}${NC}"
    echo -e "${CYAN}Check out the healing-success-summary.md for your certification!${NC}"
    echo -e "${YELLOW}Ready for the next challenge? Try the DNS scenario! 🌐${NC}"
}

main "$@"
