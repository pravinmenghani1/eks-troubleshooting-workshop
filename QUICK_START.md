# 🚀 EKS Troubleshooting Workshop - Visual Quick Start Guide

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    🎯 GET STARTED IN 5 MINUTES - VISUAL EDITION 🎯                          ║
║                                                                              ║
║    Welcome to the most spectacular Kubernetes debugging experience!          ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## 🎮 Choose Your Adventure

### 🚀 **Quick Launch (Recommended)**
```bash
./scenario-manager.sh
```
*Launches the interactive mission control center with full visual experience!*

### ⚡ **Speed Run**
```bash
# 1. Create cluster (15-20 min)
./cluster-setup.sh

# 2. Start your first chaos
./scenario-manager.sh run pod-startup-failures inject

# 3. Debug and learn!
# 4. See solutions when ready
./scenario-manager.sh run pod-startup-failures restore
```

## 🎯 Visual Scenario Gallery

### 🐛 **Pod Startup Failures** `⭐⭐⭐`
```
┌─────────────────────────────────────────────────────────────┐
│  🖼️  ImagePullBackOff    💾 Resource Limits               │
│  🔐 Missing Secrets      🏷️  Node Selectors               │
│  💥 Crash Loops          ✨ Health Checks                 │
└─────────────────────────────────────────────────────────────┘
```
**What you'll master:** Image issues, resource management, secrets, scheduling
**Duration:** 30 minutes of pure debugging joy!

### 🌐 **DNS Resolution Apocalypse** `⭐⭐⭐⭐`
```
┌─────────────────────────────────────────────────────────────┐
│  🔧 CoreDNS Chaos        🚫 Network Policies              │
│  📊 Service Discovery    🌍 External Resolution            │
│  ⚙️  Configuration Hell  🔍 Deep Diagnostics              │
└─────────────────────────────────────────────────────────────┘
```
**What you'll master:** DNS troubleshooting, CoreDNS, network policies
**Duration:** 25 minutes of DNS detective work!

### 🔐 **RBAC Permission Nightmare** `⭐⭐⭐`
```
┌─────────────────────────────────────────────────────────────┐
│  🚫 Forbidden Errors     👤 Service Accounts              │
│  🔑 Role Bindings        🛡️  Security Policies            │
│  ⚖️  Permission Matrix    🔓 Access Control               │
└─────────────────────────────────────────────────────────────┘
```
**What you'll master:** RBAC debugging, permissions, security
**Duration:** 20 minutes of permission puzzles!

## 🛠️ Prerequisites Checklist

```
┌─────────────────────────────────────────────────────────────┐
│                    MISSION REQUIREMENTS                     │
│                                                             │
│  ✅ AWS CLI configured with appropriate permissions        │
│  ✅ kubectl installed and ready                            │
│  ✅ eksctl installed (for cluster creation)                │
│  ✅ Basic Kubernetes knowledge                             │
│  ✅ Sense of adventure! 🎯                                 │
└─────────────────────────────────────────────────────────────┘
```

## 🎬 Workshop Flow - The Epic Journey

### 🏗️ **Phase 1: Setup** (20 minutes)
```
🚀 Launch Sequence
├─ ./cluster-setup.sh          # Create your EKS playground
├─ ./troubleshooting-toolkit.sh # Health check
└─ ./scenario-manager.sh        # Enter mission control
```

### 🐛 **Phase 2: Pod Chaos** (30 minutes)
```
💥 Chaos Injection
├─ 5 different pod startup disasters
├─ ImagePullBackOff nightmares
├─ Resource constraint puzzles
├─ Secret management mysteries
└─ Crash loop catastrophes
```

### 🌐 **Phase 3: DNS Apocalypse** (25 minutes)
```
🌍 DNS Destruction
├─ CoreDNS configuration corruption
├─ Service discovery failures
├─ Network policy blockades
└─ Resolution restoration
```

### 🔐 **Phase 4: RBAC Rebellion** (20 minutes)
```
🛡️ Permission Problems
├─ Forbidden access errors
├─ Missing role bindings
├─ Service account issues
└─ Security policy puzzles
```

### 🧹 **Phase 5: Cleanup** (5 minutes)
```
✨ Restoration Ritual
├─ ./scenario-manager.sh cleanup
└─ ./cleanup-cluster.sh
```

## 🎯 Essential Commands - Your Debugging Arsenal

### 🔍 **Investigation Commands**
```bash
# The Holy Trinity of Pod Debugging
kubectl get pods --all-namespaces -o wide    # Survey the battlefield
kubectl describe pod <pod-name>              # Gather intelligence
kubectl logs <pod-name>                      # Read the story

# Event Timeline Analysis
kubectl get events --sort-by=.metadata.creationTimestamp

# Resource Investigation
kubectl top nodes                            # Check node health
kubectl top pods --all-namespaces           # Find resource hogs
```

### 🌐 **DNS Detective Work**
```bash
# CoreDNS Health Check
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl logs -n kube-system -l k8s-app=kube-dns

# DNS Resolution Testing
kubectl run dns-test --image=busybox --rm -it --restart=Never -- nslookup kubernetes.default.svc.cluster.local

# Service Discovery Verification
kubectl run test --image=busybox --rm -it --restart=Never -- nslookup <service-name>
```

### 🔐 **RBAC Permission Probing**
```bash
# Permission Testing
kubectl auth can-i <verb> <resource> --as=<user>
kubectl auth can-i --list --as=<user>

# RBAC Investigation
kubectl get roles,rolebindings --all-namespaces
kubectl describe serviceaccount <sa-name>
```

## 🏆 Learning Achievements System

### 🥉 **Bronze Level - Pod Padawan**
- ✅ Fix your first ImagePullBackOff
- ✅ Resolve resource constraint issues
- ✅ Create missing secrets
- ✅ Master basic kubectl commands

### 🥈 **Silver Level - DNS Detective**
- ✅ Restore CoreDNS functionality
- ✅ Debug service discovery issues
- ✅ Fix network policy problems
- ✅ Master DNS troubleshooting

### 🥇 **Gold Level - RBAC Master**
- ✅ Resolve permission denied errors
- ✅ Create proper role bindings
- ✅ Debug service account issues
- ✅ Master security troubleshooting

### 💎 **Diamond Level - Kubernetes Grandmaster**
- ✅ Complete all scenarios
- ✅ Master systematic debugging
- ✅ Prevent common issues
- ✅ Teach others your skills

## 🎨 Visual Features Showcase

### 🌈 **Enhanced Visual Experience**
- **Colorful ASCII Art** - Every scenario has stunning visual elements
- **Progress Animations** - Watch chaos unfold in real-time
- **Status Dashboards** - Beautiful cluster health displays
- **Interactive Guides** - Step-by-step visual troubleshooting
- **Celebration Animations** - Victory celebrations when you succeed!

### 📊 **Real-time Monitoring**
- **Live Pod Status** - Watch pods fail and recover
- **Event Timelines** - See problems as they happen
- **Resource Graphs** - Visual resource utilization
- **Network Diagrams** - Understand DNS and networking flows

## 🆘 Help & Support

### 🚨 **Emergency Commands**
```bash
# Stuck? Get immediate help!
./scenario-manager.sh status <scenario>      # Check what's happening
./troubleshooting-toolkit.sh                # Run health diagnostics
./scenario-manager.sh run <scenario> restore # See all solutions
```

### 💡 **Pro Tips**
- 🎯 **Start with interactive mode** - Best experience for beginners
- 🔍 **Read error messages carefully** - They contain the clues
- 📋 **Use kubectl describe first** - Most informative command
- 🎮 **Try scenarios multiple times** - Each run teaches something new
- 🏆 **Complete all scenarios** - Become a troubleshooting master

### 🎓 **Learning Resources**
- 📚 Each scenario includes detailed troubleshooting guides
- 🎯 Visual diagrams explain complex concepts
- 💡 Pro tips and best practices included
- 🔗 Links to official Kubernetes documentation
- 🎬 Step-by-step solution walkthroughs

## 💰 Cost Management

```
┌─────────────────────────────────────────────────────────────┐
│                    💳 COST BREAKDOWN                        │
│                                                             │
│  Workshop Duration: 2-4 hours                              │
│  Estimated Cost: $5-10 USD                                 │
│                                                             │
│  💡 Remember to clean up when done!                        │
│  ./cleanup-cluster.sh                                      │
└─────────────────────────────────────────────────────────────┘
```

## 🎉 Ready to Begin?

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│    🚀 LAUNCH YOUR DEBUGGING ADVENTURE! 🚀                  │
│                                                             │
│    git clone https://github.com/pravinmenghani1/eks-troubleshooting-workshop.git
│    cd eks-troubleshooting-workshop                         │
│    ./scenario-manager.sh                                   │
│                                                             │
│    May your pods be ever Running! ✨                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

**🎯 Happy Troubleshooting, Kubernetes Warrior! 🛡️**
