# 🚀 EKS Troubleshooting Workshop - Visual Edition

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28+-blue.svg)](https://kubernetes.io/)
[![AWS EKS](https://img.shields.io/badge/AWS-EKS-orange.svg)](https://aws.amazon.com/eks/)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)

> **The most visually spectacular and engaging Kubernetes troubleshooting workshop experience!**

Transform your EKS debugging skills through hands-on scenarios with stunning visual feedback, interactive dashboards, and gamified learning. This workshop provides realistic troubleshooting challenges that mirror real-world production issues.

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    🎯 MASTER KUBERNETES TROUBLESHOOTING WITH STYLE 🎯                       ║
║                                                                              ║
║    • Visual ASCII Art & Animations                                           ║
║    • Interactive Mission Control Center                                      ║
║    • Gamified Learning Experience                                            ║
║    • Real-world Production Scenarios                                         ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## 🎮 Quick Start - Get Debugging in 5 Minutes!

```bash
# Clone the repository
git clone https://github.com/pravinmenghani1/eks-troubleshooting-workshop.git
cd eks-troubleshooting-workshop

# Launch the visual experience with progress portal
./scenario-manager.sh

# Or launch just the progress portal
./launch-portal.sh
```

**That's it!** The interactive mission control center and progress portal will guide you through everything! 🚀

## 🌟 What Makes This Workshop Special?

### 🎨 **Visual Excellence**
- **Stunning ASCII Art** - Every scenario has beautiful visual elements
- **Real-time Animations** - Watch chaos unfold and healing happen
- **Interactive Dashboards** - Beautiful cluster status displays
- **Progress Tracking** - Visual feedback on your debugging journey

### 🎯 **Realistic Scenarios**
- **Production-like Issues** - Real problems you'll face in the wild
- **Multiple Failure Modes** - Complex, interconnected problems
- **Progressive Difficulty** - From beginner to expert level challenges

### 🏆 **Gamified Learning**
- **Achievement System** - Unlock badges as you progress
- **Difficulty Ratings** - Star-based challenge levels
- **Victory Celebrations** - Animated success feedback
- **Leaderboard Ready** - Track your troubleshooting skills

## 🎯 Available Troubleshooting Adventures

| Scenario | Difficulty | Duration | Skills Learned |
|----------|------------|----------|----------------|
| 🐛 **Pod Startup Failures** | ⭐⭐⭐ | 30 min | Image pulls, resources, secrets, scheduling |
| 🌐 **DNS Resolution Apocalypse** | ⭐⭐⭐⭐ | 25 min | CoreDNS, service discovery, network policies |
| 🔐 **RBAC Permission Nightmare** | ⭐⭐⭐ | 20 min | Role bindings, service accounts, security |
| 🖥️ **Node Health Crisis** | ⭐⭐⭐⭐⭐ | 35 min | Node failures, resource exhaustion, kubelet |
| 📦 **Image Registry Disasters** | ⭐⭐ | 15 min | Private registries, authentication, networking |

## 🛠️ Prerequisites

```bash
# Required tools
✅ AWS CLI configured
✅ kubectl installed  
✅ eksctl installed
✅ Basic Kubernetes knowledge
✅ Sense of adventure! 🎯
```

## 🚀 Workshop Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    WORKSHOP COMPONENTS                      │
│                                                             │
│  🎮 scenario-manager.sh     ← Interactive Mission Control  │
│  📊 launch-portal.sh        ← Progress Portal Launcher     │
│  🏗️ cluster-setup.sh        ← EKS Cluster Creation        │
│  🔧 troubleshooting-toolkit ← Health Check & Diagnostics   │
│  🧹 cleanup-cluster.sh      ← Complete Cleanup             │
│                                                             │
│  📁 scenarios/              ← Individual Challenge Folders │
│  ├─ 🐛 pod-startup-failures                                │
│  ├─ 🌐 dns-issues                                          │
│  ├─ 🔐 rbac-issues                                         │
│  └─ ... more scenarios                                     │
│                                                             │
│  📊 progress-portal/        ← Web-based Progress Dashboard │
│  ├─ index.html             ← Portal Interface              │
│  ├─ styles.css             ← Visual Styling                │
│  └─ script.js              ← Interactive Features          │
└─────────────────────────────────────────────────────────────┘
```

## 🎬 Workshop Flow

### 🏗️ **Phase 1: Setup** (20 minutes)
```bash
./cluster-setup.sh          # Create your EKS playground
./troubleshooting-toolkit.sh # Verify cluster health
./scenario-manager.sh        # Enter mission control
```

### 🐛 **Phase 2: Pod Chaos** (30 minutes)
Experience 5 different pod startup disasters:
- 🖼️ ImagePullBackOff nightmares
- 💾 Resource constraint puzzles  
- 🔐 Secret management mysteries
- 🏷️ Node selector impossibilities
- 💥 Crash loop catastrophes

### 🌐 **Phase 3: DNS Apocalypse** (25 minutes)
Navigate through DNS resolution chaos:
- 🔧 CoreDNS configuration corruption
- 📊 Service discovery failures
- 🚫 Network policy blockades
- 🌍 External resolution breakdowns

### 🔐 **Phase 4: RBAC Rebellion** (20 minutes)
Master permission troubleshooting:
- 🚫 Forbidden access errors
- 👤 Service account mysteries
- 🔑 Role binding puzzles
- 🛡️ Security policy challenges

## 🎯 Learning Outcomes

By completing this workshop, you'll master:

### 🔍 **Diagnostic Skills**
- Systematic troubleshooting methodology
- Essential kubectl commands for debugging
- Log analysis and event interpretation
- Resource utilization investigation

### 🛠️ **Technical Expertise**
- Pod lifecycle troubleshooting
- DNS resolution debugging
- RBAC permission management
- Node health monitoring
- Network policy configuration

### 🏆 **Best Practices**
- Prevention strategies
- Monitoring and alerting setup
- Security considerations
- Performance optimization

## 📊 Visual Features Showcase

### 🌈 **Enhanced User Experience**
```bash
# Beautiful ASCII art banners
╔══════════════════════════════════════════════════════════════╗
║    🐛 POD STARTUP RECOVERY CENTER 🐛                        ║
╚══════════════════════════════════════════════════════════════╝

# Real-time progress animations
🔄 Injecting chaos... ████████████████████ 100%

# Interactive status dashboards
📊 Cluster Health: ✅ Healthy | Nodes: 3 | Pods: 47
```

### 🎮 **Gamified Elements**
- **Achievement Badges** - Unlock as you progress
- **Difficulty Ratings** - Star-based challenge levels  
- **Victory Celebrations** - Animated success messages
- **Progress Tracking** - Visual completion status
- **Real-time Portal** - Web-based progress dashboard

## 📊 Progress Portal

Experience real-time progress tracking with our web-based portal:

### 🌟 **Portal Features**
- **Live Progress Tracking** - See your completion status in real-time
- **Scenario Status** - Visual indicators for each challenge
- **Time Tracking** - Monitor how long you've been working
- **Cluster Status** - Real-time cluster health monitoring
- **Quick Commands** - Easy access to common kubectl commands

### 🚀 **Launch Portal**
```bash
# Start the progress portal
./launch-portal.sh

# Or launch automatically with interactive mode
./scenario-manager.sh
```

The portal runs locally on `http://localhost:8080` and provides a beautiful dashboard to track your troubleshooting journey!

## 🔧 Advanced Usage

### 🎯 **Command Line Interface**
```bash
# List all scenarios
./scenario-manager.sh list

# Start specific scenario
./scenario-manager.sh run pod-startup-failures inject

# Check scenario status
./scenario-manager.sh status dns-issues

# Restore/fix scenario
./scenario-manager.sh run rbac-issues restore

# Launch progress portal
./scenario-manager.sh portal

# Complete cleanup
./scenario-manager.sh cleanup
```

### 🔍 **Diagnostic Tools**
```bash
# Comprehensive cluster health check
./troubleshooting-toolkit.sh

# Scenario-specific diagnostics
./troubleshooting-toolkit.sh pod-startup
./troubleshooting-toolkit.sh dns
./troubleshooting-toolkit.sh rbac
```

## 🎓 Educational Value

### 👨‍🎓 **For Students**
- **Hands-on Learning** - Real scenarios, not just theory
- **Visual Feedback** - Immediate understanding of concepts
- **Progressive Difficulty** - Build skills step by step
- **Memorable Experience** - Visual elements aid retention

### 👨‍🏫 **For Instructors**
- **Professional Presentation** - Impressive workshop delivery
- **Engagement Tools** - Keep students motivated
- **Progress Tracking** - Easy to monitor student advancement
- **Reusable Content** - Run workshops repeatedly

### 🏢 **For Organizations**
- **Team Training** - Upskill entire teams efficiently
- **Standardized Learning** - Consistent troubleshooting approaches
- **Cost Effective** - Minimal infrastructure requirements
- **Measurable Outcomes** - Clear skill development metrics

## 💰 Cost Management

```
┌─────────────────────────────────────────────────────────────┐
│                    💳 WORKSHOP COSTS                        │
│                                                             │
│  Duration: 2-4 hours                                        │
│  AWS Cost: $5-10 USD                                       │
│  Cluster: t3.medium nodes (3x)                             │
│                                                             │
│  💡 Auto-cleanup included!                                 │
└─────────────────────────────────────────────────────────────┘
```

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### 🐛 **Bug Reports**
- Use GitHub Issues for bug reports
- Include scenario details and error messages
- Provide cluster information and logs

### ✨ **Feature Requests**
- Suggest new troubleshooting scenarios
- Propose visual enhancements
- Request additional diagnostic tools

### 🔧 **Pull Requests**
- Fork the repository
- Create feature branches
- Include tests for new scenarios
- Update documentation

## 📚 Additional Resources

- 📖 [Kubernetes Troubleshooting Documentation](https://kubernetes.io/docs/tasks/debug/)
- 🎯 [EKS Workshop Troubleshooting Guide](https://eksworkshop.com/docs/troubleshooting/)
- 🏆 [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- 🔧 [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## 🌐 Workshop Web Page

Visit our interactive workshop page: [EKS Troubleshooting Workshop](https://pravinmenghani1.github.io/cloudcognoscente/eks-workshop.html)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Kubernetes Community** - For excellent troubleshooting documentation
- **AWS EKS Team** - For comprehensive best practices guides
- **Workshop Participants** - For feedback and improvement suggestions
- **Open Source Contributors** - For tools and inspiration

## 🆘 Support

### 🚨 **Need Help?**
- 📖 Check the [QUICK_START.md](QUICK_START.md) guide
- 🎯 Use the interactive mode: `./scenario-manager.sh`
- 🔍 Run diagnostics: `./troubleshooting-toolkit.sh`
- 🐛 Open a GitHub Issue for bugs

### 💬 **Community**
- ⭐ Star this repository if you find it helpful
- 🍴 Fork and customize for your needs
- 📢 Share with your team and community
- 🤝 Contribute improvements back

---

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│    🚀 READY TO BECOME A KUBERNETES TROUBLESHOOTING         │
│       MASTER? START YOUR JOURNEY NOW! 🚀                   │
│                                                             │
│    ./scenario-manager.sh                                   │
│                                                             │
│    May your pods be ever Running! ✨                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Happy Troubleshooting! 🎯**
