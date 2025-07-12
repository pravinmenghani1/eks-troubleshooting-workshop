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
