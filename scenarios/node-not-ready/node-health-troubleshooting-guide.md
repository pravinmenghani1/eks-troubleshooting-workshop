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
