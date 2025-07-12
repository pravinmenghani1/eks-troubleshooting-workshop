#!/bin/bash

# Enhanced Visual DNS Fault Injection Script
# This script creates DNS resolution chaos with spectacular visual feedback

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
BUG="🐛"
FIRE="🔥"
MAGNIFYING="🔍"
DNS="🌐"
BROKEN="💥"
NETWORK="🔗"

print_banner() {
    clear
    echo -e "${PURPLE}${BOLD}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    🌐 DNS RESOLUTION APOCALYPSE 🌐                                          ║
║                                                                              ║
║    Prepare for total DNS chaos! Nothing will resolve! 💥                    ║
║                                                                              ║
║    Your mission: Restore order to the DNS universe! 🚀                     ║
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

# Animated progress bar
show_progress() {
    local duration=$1
    local message=$2
    echo -e "${CYAN}${message}${NC}"
    
    local chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local delay=0.1
    local iterations=$((duration * 10))
    
    for ((i=0; i<iterations; i++)); do
        printf "\r${BLUE}%s Working...${NC}" "${chars:$((i % ${#chars})):1}"
        sleep $delay
    done
    echo ""
}

# DNS Network Diagram
show_dns_architecture() {
    echo -e "${BLUE}${BOLD}"
    cat << 'EOF'
    ┌─────────────────────────────────────────────────────────────┐
    │                    DNS ARCHITECTURE                         │
    │                                                             │
    │  Pod ──DNS Query──> CoreDNS ──Forward──> Upstream DNS      │
    │   │                    │                      │             │
    │   │                    │                      │             │
    │   └──Response──────────┴──────Response────────┘             │
    │                                                             │
    │  🎯 Target: Break every step of this chain! 💥            │
    └─────────────────────────────────────────────────────────────┘
EOF
    echo -e "${NC}"
}

create_namespace() {
    print_section_header "🏗️  INITIALIZING DNS CHAOS CHAMBER"
    
    print_step "Creating DNS troubleshooting arena..."
    kubectl create namespace troubleshooting-dns --dry-run=client -o yaml | kubectl apply -f -
    
    show_progress 2 "Setting up DNS chaos environment"
    print_success "DNS troubleshooting namespace ready for destruction!"
}

backup_coredns() {
    print_section_header "💾 BACKING UP COREDNS (BEFORE THE CHAOS)"
    
    print_step "Creating safety backup of CoreDNS configuration..."
    kubectl get configmap coredns -n kube-system -o yaml > coredns-backup.yaml
    
    show_progress 1 "Securing CoreDNS backup"
    print_success "CoreDNS configuration safely backed up!"
    print_info "Backup saved to: coredns-backup.yaml"
}

break_coredns_config() {
    print_section_header "💥 FAULT #1: COREDNS CONFIGURATION DESTRUCTION"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'
    ┌─────────────────────────────────────────────────────────────┐
    │                COREDNS CONFIG CORRUPTION                    │
    │                                                             │
    │  Before: Working Corefile ✅                               │
    │  After:  Broken Corefile ❌                                │
    │                                                             │
    │  Issues Injected:                                           │
    │  ├─ Invalid kubernetes endpoint                             │
    │  ├─ Broken forward configuration                            │
    │  └─ Syntax errors galore                                    │
    │                                                             │
    │  Result: DNS queries fail spectacularly! 💥                │
    └─────────────────────────────────────────────────────────────┘
EOF
    echo -e "${NC}"
    
    print_step "Corrupting CoreDNS configuration with malicious intent..."
    
    cat << 'EOF' | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
  annotations:
    troubleshooting.workshop/fault: "broken-config"
    troubleshooting.workshop/hint: "Check Corefile syntax and endpoints"
data:
  Corefile: |
    .:53 {
        errors
        health {
           lameduck 5s
        }
        ready
        # 💥 BROKEN: Invalid kubernetes plugin configuration
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           fallthrough in-addr.arpa ip6.arpa
           ttl 30
           # 💥 BROKEN: Invalid endpoint configuration
           endpoint https://invalid-endpoint-that-does-not-exist:443
        }
        prometheus :9153
        # 💥 BROKEN: Invalid forward configuration
        forward . 1.2.3.4:53 {
           max_concurrent 1000
        }
        cache 30
        loop
        reload
        loadbalance
    }
EOF

    show_progress 3 "Injecting configuration chaos"
    
    print_step "Restarting CoreDNS with broken configuration..."
    kubectl rollout restart deployment coredns -n kube-system
    
    print_error "CoreDNS configuration thoroughly corrupted! DNS resolution doomed! 💀"
}

scale_down_coredns() {
    print_section_header "📉 FAULT #2: COREDNS EXTINCTION EVENT"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'
    ┌─────────────────────────────────────────────────────────────┐
    │                   COREDNS VANISHING ACT                     │
    │                                                             │
    │  CoreDNS Replicas: 2 ──> 0                                 │
    │                                                             │
    │  DNS Service Status:                                        │
    │  ├─ Pods: None (Extinct) 🦕                                │
    │  ├─ Endpoints: Empty                                        │
    │  └─ DNS Resolution: Impossible                              │
    │                                                             │
    │  Impact: Total DNS blackout! 🌑                            │
    └─────────────────────────────────────────────────────────────┘
EOF
    echo -e "${NC}"
    
    print_step "Executing CoreDNS extinction protocol..."
    kubectl scale deployment coredns --replicas=0 -n kube-system
    
    show_progress 2 "Eliminating all CoreDNS pods"
    print_error "CoreDNS completely eliminated! DNS service extinct! 🦕"
}

create_dns_dependent_apps() {
    print_section_header "🎯 DEPLOYING DNS-DEPENDENT VICTIMS"
    
    print_step "Creating applications that will suffer from DNS failures..."
    
    cat << EOF | kubectl apply -f -
# External DNS Test App
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns-tester
  namespace: troubleshooting-dns
  labels:
    app: external-dns-tester
    purpose: chaos-victim
spec:
  replicas: 1
  selector:
    matchLabels:
      app: external-dns-tester
  template:
    metadata:
      labels:
        app: external-dns-tester
      annotations:
        troubleshooting.workshop/purpose: "Tests external DNS resolution"
    spec:
      containers:
      - name: dns-tester
        image: busybox:latest
        command: ["sh", "-c"]
        args:
        - |
          while true; do
            echo "🌐 === EXTERNAL DNS RESOLUTION TEST ==="
            echo "🔍 Testing google.com..."
            nslookup google.com || echo "❌ FAILED: google.com"
            echo "🔍 Testing github.com..."
            nslookup github.com || echo "❌ FAILED: github.com"
            echo "🔍 Testing aws.amazon.com..."
            nslookup aws.amazon.com || echo "❌ FAILED: aws.amazon.com"
            echo "💤 Sleeping for 30 seconds..."
            sleep 30
          done
        resources:
          requests:
            memory: "32Mi"
            cpu: "25m"
---
# Internal Service Discovery Test
apiVersion: v1
kind: Service
metadata:
  name: service-alpha
  namespace: troubleshooting-dns
spec:
  selector:
    app: app-alpha
  ports:
  - port: 80
    targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-alpha
  namespace: troubleshooting-dns
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app-alpha
  template:
    metadata:
      labels:
        app: app-alpha
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: service-beta
  namespace: troubleshooting-dns
spec:
  selector:
    app: app-beta
  ports:
  - port: 80
    targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-beta
  namespace: troubleshooting-dns
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app-beta
  template:
    metadata:
      labels:
        app: app-beta
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
---
# Service Discovery Test App
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-discovery-tester
  namespace: troubleshooting-dns
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-discovery-tester
  template:
    metadata:
      labels:
        app: service-discovery-tester
      annotations:
        troubleshooting.workshop/purpose: "Tests internal service discovery"
    spec:
      containers:
      - name: discovery-tester
        image: busybox:latest
        command: ["sh", "-c"]
        args:
        - |
          while true; do
            echo "🔍 === SERVICE DISCOVERY TEST ==="
            echo "🎯 Testing service-alpha (FQDN)..."
            nslookup service-alpha.troubleshooting-dns.svc.cluster.local || echo "❌ FAILED: service-alpha FQDN"
            echo "🎯 Testing service-beta (FQDN)..."
            nslookup service-beta.troubleshooting-dns.svc.cluster.local || echo "❌ FAILED: service-beta FQDN"
            echo "🎯 Testing service-alpha (short name)..."
            nslookup service-alpha || echo "❌ FAILED: service-alpha short"
            echo "🎯 Testing service-beta (short name)..."
            nslookup service-beta || echo "❌ FAILED: service-beta short"
            echo "🎯 Testing kubernetes API..."
            nslookup kubernetes.default.svc.cluster.local || echo "❌ FAILED: kubernetes API"
            echo "💤 Sleeping for 30 seconds..."
            sleep 30
          done
        resources:
          requests:
            memory: "32Mi"
            cpu: "25m"
EOF

    show_progress 3 "Deploying DNS-dependent applications"
    print_success "DNS victim applications deployed and ready to suffer!"
}

create_dns_blocking_policy() {
    print_section_header "🚫 FAULT #3: DNS TRAFFIC ANNIHILATION"
    
    echo -e "${RED}${BOLD}"
    cat << 'EOF'
    ┌─────────────────────────────────────────────────────────────┐
    │                 NETWORK POLICY BLOCKADE                     │
    │                                                             │
    │  Network Policy Rules:                                      │
    │  ├─ Allow: HTTP (80), HTTPS (443) ✅                       │
    │  └─ Block: DNS (53) ❌                                      │
    │                                                             │
    │  Result:                                                    │
    │  ├─ Apps can't resolve any names                            │
    │  ├─ DNS queries timeout                                     │
    │  └─ Total communication breakdown 📡❌                      │
    └─────────────────────────────────────────────────────────────┘
EOF
    echo -e "${NC}"
    
    print_step "Deploying DNS-blocking network policy..."
    
    cat << EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: dns-traffic-blocker
  namespace: troubleshooting-dns
  annotations:
    troubleshooting.workshop/fault: "dns-blocking"
    troubleshooting.workshop/hint: "Check if DNS traffic (port 53) is allowed"
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  # Allow HTTP and HTTPS but NOT DNS!
  - to: []
    ports:
    - protocol: TCP
      port: 80
    - protocol: TCP
      port: 443
  # Intentionally NOT allowing DNS ports 53 (UDP/TCP)
EOF

    show_progress 2 "Activating DNS traffic blockade"
    print_error "DNS traffic completely blocked! Network isolation activated! 🚫"
}

create_visual_dns_guide() {
    print_section_header "📚 CREATING VISUAL DNS TROUBLESHOOTING GUIDE"
    
    cat > visual-dns-troubleshooting-guide.md << 'EOF'
# 🌐 DNS Resolution Apocalypse - Visual Troubleshooting Guide

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    🎯 MISSION: RESTORE DNS TO THE KUBERNETES UNIVERSE                        ║
║                                                                              ║
║    DNS is completely broken! Nothing resolves! Fix the chaos! 🚀            ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## 🔥 Current DNS Disaster Status

```
┌─────────────────────────────────────────────────────────────┐
│                    DNS FAILURE MATRIX                       │
│                                                             │
│  External DNS:     ❌ BROKEN (google.com fails)            │
│  Internal DNS:     ❌ BROKEN (kubernetes API fails)        │
│  Service Discovery:❌ BROKEN (service-alpha fails)         │
│  CoreDNS Status:   ❌ BROKEN (0 replicas)                  │
│  Network Policy:   ❌ BLOCKING (DNS traffic blocked)       │
│                                                             │
│  Overall Status:   🔥 TOTAL DNS APOCALYPSE 🔥              │
└─────────────────────────────────────────────────────────────┘
```

## 🕵️ DNS Detective Toolkit

### Phase 1: Assess the Damage
```bash
# Check CoreDNS pod status
kubectl get pods -n kube-system -l k8s-app=kube-dns

# Check DNS service
kubectl get svc kube-dns -n kube-system

# Check DNS endpoints
kubectl get endpoints kube-dns -n kube-system
```

### Phase 2: Test DNS Resolution
```bash
# Quick DNS test (should fail)
kubectl run dns-test --image=busybox --rm -it --restart=Never -- nslookup kubernetes.default.svc.cluster.local

# Test from troubleshooting namespace
kubectl run dns-test --image=busybox --rm -it --restart=Never -n troubleshooting-dns -- nslookup google.com
```

### Phase 3: Investigate the Crime Scene
```bash
# Check CoreDNS configuration
kubectl get configmap coredns -n kube-system -o yaml

# Check CoreDNS logs (if any pods exist)
kubectl logs -n kube-system -l k8s-app=kube-dns

# Check network policies
kubectl get networkpolicies -n troubleshooting-dns
```

## 🛠️ Repair Mission Checklist

### 🎯 **Issue #1: CoreDNS Configuration Corruption**
```
Problem: Invalid Corefile with broken endpoints
Symptoms: CoreDNS pods failing, configuration errors
Solution: Restore proper Corefile configuration

Commands:
kubectl get configmap coredns -n kube-system -o yaml
# Fix the Corefile or restore from backup
kubectl apply -f coredns-backup.yaml
```

### 🎯 **Issue #2: CoreDNS Extinction**
```
Problem: CoreDNS scaled to 0 replicas
Symptoms: No CoreDNS pods running
Solution: Scale CoreDNS back up

Commands:
kubectl get deployment coredns -n kube-system
kubectl scale deployment coredns --replicas=2 -n kube-system
```

### 🎯 **Issue #3: DNS Traffic Blockade**
```
Problem: Network policy blocking DNS traffic
Symptoms: DNS queries timeout, no response
Solution: Allow DNS traffic or remove blocking policy

Commands:
kubectl get networkpolicies -n troubleshooting-dns
kubectl delete networkpolicy dns-traffic-blocker -n troubleshooting-dns
# OR create policy that allows DNS traffic
```

## 🎮 DNS Troubleshooting Game

| Challenge | Status | Command to Check | Fix Command |
|-----------|--------|------------------|-------------|
| 🔧 CoreDNS Config | 🔴 | `kubectl get cm coredns -n kube-system -o yaml` | Restore backup |
| 📊 CoreDNS Scale | 🔴 | `kubectl get deploy coredns -n kube-system` | Scale to 2 |
| 🚫 Network Policy | 🔴 | `kubectl get netpol -n troubleshooting-dns` | Delete blocker |
| 🌐 External DNS | 🔴 | `nslookup google.com` | Fix above issues |
| 🎯 Service Discovery | 🔴 | `nslookup service-alpha` | Fix above issues |

## 🏆 Victory Conditions

When DNS is fixed, you should see:

```bash
# CoreDNS healthy
kubectl get pods -n kube-system -l k8s-app=kube-dns
NAME                      READY   STATUS    RESTARTS   AGE
coredns-xxx               1/1     Running   0          1m
coredns-yyy               1/1     Running   0          1m

# DNS resolution working
kubectl run test --image=busybox --rm -it --restart=Never -- nslookup google.com
# Should resolve successfully ✅

# Service discovery working
kubectl run test --image=busybox --rm -it --restart=Never -n troubleshooting-dns -- nslookup service-alpha
# Should resolve successfully ✅
```

## 🎯 Pro DNS Detective Tips

- 🔍 **Always check CoreDNS pods first** - No pods = No DNS
- 📋 **Read CoreDNS logs** - They tell you what's wrong
- 🔧 **Test step by step** - Internal DNS first, then external
- 🚫 **Check network policies** - They can silently block DNS
- 💾 **Keep backups** - Always backup before breaking things
- 🎯 **Use FQDN for testing** - More reliable than short names

## 🆘 Emergency DNS Restoration

If completely stuck, run: `./restore-cluster.sh` 🚑

---
**May your DNS queries resolve swiftly! 🌐✨**
EOF

    print_success "Visual DNS troubleshooting guide created!"
}

show_dns_chaos_dashboard() {
    print_section_header "📊 DNS CHAOS DASHBOARD"
    
    echo -e "${RED}${BOLD}Monitoring DNS apocalypse in progress...${NC}"
    show_progress 8 "Letting DNS chaos reach maximum entropy"
    
    echo -e "\n${YELLOW}${BOLD}🌐 DNS INFRASTRUCTURE STATUS:${NC}\n"
    
    echo -e "${CYAN}CoreDNS Pods:${NC}"
    kubectl get pods -n kube-system -l k8s-app=kube-dns || echo "CoreDNS pods extinct! 🦕"
    
    echo -e "\n${CYAN}DNS Service:${NC}"
    kubectl get svc kube-dns -n kube-system || echo "DNS service unreachable!"
    
    echo -e "\n${CYAN}Test Applications:${NC}"
    kubectl get pods -n troubleshooting-dns || echo "Test apps still starting..."
    
    echo -e "\n${CYAN}Network Policies:${NC}"
    kubectl get networkpolicies -n troubleshooting-dns || echo "No network policies found"
    
    echo -e "\n${RED}${BOLD}⚠️  RECENT DNS DISASTERS:${NC}\n"
    kubectl get events -n kube-system --field-selector involvedObject.name=coredns --sort-by=.metadata.creationTimestamp | tail -5 || echo "Events loading..."
}

show_dns_mission_briefing() {
    print_section_header "🎯 DNS RESCUE MISSION BRIEFING"
    
    show_dns_architecture
    
    echo -e "\n${YELLOW}${BOLD}"
    cat << 'EOF'
    ┌─────────────────────────────────────────────────────────────┐
    │                    MISSION OBJECTIVES                       │
    │                                                             │
    │  🎯 Restore CoreDNS configuration                          │
    │  📊 Scale CoreDNS back to healthy replica count           │
    │  🚫 Remove DNS-blocking network policies                   │
    │  🌐 Verify external DNS resolution works                   │
    │  🎯 Confirm service discovery functions                    │
    │                                                             │
    │  Success: All DNS queries resolve successfully ✅          │
    └─────────────────────────────────────────────────────────────┘
EOF
    echo -e "${NC}"
    
    echo -e "\n${GREEN}${BOLD}🚀 READY TO RESTORE DNS ORDER?${NC}"
    echo -e "${CYAN}1. Read the visual-dns-troubleshooting-guide.md${NC}"
    echo -e "${CYAN}2. Check CoreDNS pod status first${NC}"
    echo -e "${CYAN}3. Fix configuration, scaling, and network issues${NC}"
    echo -e "${CYAN}4. Test DNS resolution step by step${NC}"
    echo -e "${CYAN}5. Celebrate when DNS works again! 🎉${NC}"
    
    echo -e "\n${RED}${BOLD}🆘 EMERGENCY RESTORATION: ./restore-cluster.sh${NC}"
}

# Main execution with spectacular visuals
main() {
    print_banner
    sleep 2
    
    create_namespace
    sleep 1
    
    backup_coredns
    sleep 1
    
    create_dns_dependent_apps
    sleep 2
    
    # Wait for apps to be ready before breaking DNS
    echo -e "${YELLOW}Waiting for victim applications to be ready...${NC}"
    kubectl wait --for=condition=available --timeout=120s deployment --all -n troubleshooting-dns
    
    break_coredns_config
    sleep 2
    
    scale_down_coredns
    sleep 2
    
    create_dns_blocking_policy
    sleep 1
    
    create_visual_dns_guide
    sleep 1
    
    show_dns_chaos_dashboard
    sleep 2
    
    show_dns_mission_briefing
    
    echo -e "\n${RED}${BOLD}${FIRE} DNS APOCALYPSE COMPLETE! ${FIRE}${NC}"
    echo -e "${PURPLE}${BOLD}The DNS universe is in chaos! Time to restore order! 🌐${NC}"
}

main "$@"
