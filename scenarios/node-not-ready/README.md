# Node Not Ready

## Scenario Description
One or more nodes in your EKS cluster are showing as `NotReady`, preventing pods from being scheduled on them.

## Problem Statement
Nodes in your cluster are not ready to accept workloads, causing scheduling issues and potential service disruptions.

## Symptoms
- Node status shows `NotReady`
- Pods cannot be scheduled on affected nodes
- Cluster capacity appears reduced
- Applications may be unavailable if too many nodes are affected

## Setup Instructions

This scenario typically occurs in real environments. To simulate:

1. Check current node status:
```bash
kubectl get nodes
```

2. If all nodes are ready, you can simulate by cordoning a node:
```bash
kubectl cordon <node-name>
```

## Troubleshooting Steps

### Step 1: Identify NotReady Nodes
```bash
# Check all nodes status
kubectl get nodes

# Get detailed node information
kubectl describe node <node-name>

# Check node conditions
kubectl get nodes -o wide
```

### Step 2: Examine Node Events and Logs
```bash
# Check node events
kubectl describe node <node-name>

# Check kubelet logs (SSH to node or use AWS Systems Manager)
sudo journalctl -u kubelet -f

# Check container runtime logs
sudo journalctl -u docker -f  # for Docker
sudo journalctl -u containerd -f  # for containerd
```

### Step 3: Check Node Resources
```bash
# Check node resource usage
kubectl top nodes

# Check disk usage on node
kubectl describe node <node-name> | grep -A 5 "Conditions"

# SSH to node and check system resources
df -h
free -h
top
```

### Step 4: Verify Network Connectivity
```bash
# Test connectivity from node to API server
curl -k https://<api-server-endpoint>

# Check DNS resolution
nslookup kubernetes.default.svc.cluster.local

# Test pod network connectivity
ping <pod-ip>
```

## Common Issues and Solutions

### Issue 1: Disk Pressure
**Cause**: Node running out of disk space
**Solution**:
```bash
# Clean up unused images
docker system prune -a

# Clean up unused containers
docker container prune

# Check and clean log files
sudo find /var/log -name "*.log" -size +100M

# Increase disk size or add storage
```

### Issue 2: Memory Pressure
**Cause**: Node running out of memory
**Solution**:
```bash
# Check memory usage
free -h
ps aux --sort=-%mem | head

# Kill unnecessary processes
# Scale up node group or add nodes
# Adjust pod resource limits
```

### Issue 3: Kubelet Issues
**Cause**: Kubelet service problems
**Solution**:
```bash
# Restart kubelet service
sudo systemctl restart kubelet

# Check kubelet configuration
sudo cat /etc/kubernetes/kubelet/kubelet-config.json

# Verify kubelet can reach API server
```

### Issue 4: Network Plugin Issues
**Cause**: CNI plugin problems
**Solution**:
```bash
# Check CNI plugin pods
kubectl get pods -n kube-system | grep -E "(aws-node|calico|flannel)"

# Restart CNI plugin
kubectl delete pod -n kube-system -l k8s-app=aws-node

# Check CNI configuration
ls -la /etc/cni/net.d/
```

### Issue 5: Certificate Issues
**Cause**: Expired or invalid certificates
**Solution**:
```bash
# Check certificate expiration
sudo kubeadm certs check-expiration

# Renew certificates if needed
sudo kubeadm certs renew all

# For EKS, certificates are managed automatically
```

## EKS-Specific Troubleshooting

### Check Node Group Health
```bash
# Describe node group
aws eks describe-nodegroup --cluster-name <cluster-name> --nodegroup-name <nodegroup-name>

# Check Auto Scaling Group
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names <asg-name>

# Check EC2 instance health
aws ec2 describe-instances --instance-ids <instance-id>
```

### Check IAM Roles and Policies
```bash
# Verify node instance profile
aws iam get-instance-profile --instance-profile-name <profile-name>

# Check attached policies
aws iam list-attached-role-policies --role-name <node-role-name>
```

## Resolution Verification

1. Node should be in `Ready` state:
```bash
kubectl get nodes
```

2. Node should accept new pods:
```bash
kubectl run test-pod --image=nginx --restart=Never
kubectl get pods -o wide
```

3. No critical conditions should be present:
```bash
kubectl describe node <node-name> | grep -A 10 "Conditions"
```

## Prevention Tips

- Monitor node resource usage regularly
- Set up alerts for node conditions
- Implement proper resource requests and limits
- Use cluster autoscaler for automatic scaling
- Regular maintenance and updates
- Monitor disk usage and implement log rotation
- Use node taints and tolerations appropriately
