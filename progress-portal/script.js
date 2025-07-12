// Progress Portal JavaScript

class WorkshopProgressTracker {
    constructor() {
        this.scenarios = {
            'pod-startup-failures': { total: 5, completed: 0, status: 'pending', startTime: null },
            'dns-issues': { total: 3, completed: 0, status: 'pending', startTime: null },
            'rbac-issues': { total: 2, completed: 0, status: 'pending', startTime: null },
            'node-not-ready': { total: 4, completed: 0, status: 'pending', startTime: null },
            'image-pull-errors': { total: 2, completed: 0, status: 'pending', startTime: null }
        };
        
        this.workshopStartTime = Date.now();
        this.refreshInterval = null;
        
        this.init();
    }
    
    init() {
        this.loadProgress();
        this.updateDisplay();
        this.startAutoRefresh();
        this.setupEventListeners();
        this.checkClusterStatus();
    }
    
    loadProgress() {
        const saved = localStorage.getItem('workshop-progress');
        if (saved) {
            try {
                const data = JSON.parse(saved);
                this.scenarios = { ...this.scenarios, ...data.scenarios };
                this.workshopStartTime = data.workshopStartTime || Date.now();
            } catch (e) {
                console.warn('Failed to load saved progress:', e);
            }
        }
    }
    
    saveProgress() {
        const data = {
            scenarios: this.scenarios,
            workshopStartTime: this.workshopStartTime,
            lastUpdated: Date.now()
        };
        localStorage.setItem('workshop-progress', JSON.stringify(data));
    }
    
    async checkClusterStatus() {
        const statusIndicator = document.getElementById('statusIndicator');
        const statusText = document.getElementById('statusText');
        
        try {
            // Simulate cluster status check
            // In a real implementation, this would call a backend API
            const response = await this.simulateClusterCheck();
            
            if (response.connected) {
                statusIndicator.className = 'status-indicator online';
                statusText.textContent = `Connected (${response.nodes} nodes, ${response.pods} pods)`;
            } else {
                statusIndicator.className = 'status-indicator offline';
                statusText.textContent = 'Cluster Offline';
            }
        } catch (error) {
            statusIndicator.className = 'status-indicator offline';
            statusText.textContent = 'Connection Error';
        }
    }
    
    async simulateClusterCheck() {
        // Simulate API call delay
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Simulate cluster status (in real implementation, this would be actual kubectl calls)
        return {
            connected: Math.random() > 0.3, // 70% chance of being connected
            nodes: Math.floor(Math.random() * 3) + 2,
            pods: Math.floor(Math.random() * 20) + 10
        };
    }
    
    async checkScenarioStatus(scenarioName) {
        // Simulate checking scenario status via kubectl
        // In real implementation, this would execute kubectl commands
        
        const scenario = this.scenarios[scenarioName];
        if (!scenario) return;
        
        // Simulate different statuses based on scenario
        const statuses = ['pending', 'running', 'completed', 'failed'];
        const randomStatus = statuses[Math.floor(Math.random() * statuses.length)];
        
        // Update scenario status
        scenario.status = randomStatus;
        
        if (randomStatus === 'running' && !scenario.startTime) {
            scenario.startTime = Date.now();
        }
        
        if (randomStatus === 'completed') {
            scenario.completed = scenario.total;
        } else if (randomStatus === 'running') {
            scenario.completed = Math.floor(Math.random() * scenario.total);
        }
        
        this.updateScenarioDisplay(scenarioName);
        this.updateOverallProgress();
        this.saveProgress();
    }
    
    updateScenarioDisplay(scenarioName) {
        const scenario = this.scenarios[scenarioName];
        const card = document.querySelector(`[data-scenario="${scenarioName}"]`);
        
        if (!card || !scenario) return;
        
        // Update status icon
        const statusElement = document.getElementById(`status-${scenarioName}`);
        const progressElement = document.getElementById(`progress-${scenarioName}`);
        const textElement = document.getElementById(`text-${scenarioName}`);
        const issuesElement = document.getElementById(`issues-${scenarioName}`);
        
        // Update status icon and class
        statusElement.className = `scenario-status ${scenario.status}`;
        card.className = `scenario-card ${scenario.status}`;
        
        switch (scenario.status) {
            case 'pending':
                statusElement.innerHTML = '<i class="fas fa-clock"></i>';
                textElement.textContent = 'Not Started';
                break;
            case 'running':
                statusElement.innerHTML = '<i class="fas fa-play"></i>';
                textElement.textContent = 'In Progress';
                break;
            case 'completed':
                statusElement.innerHTML = '<i class="fas fa-check-circle"></i>';
                textElement.textContent = 'Completed';
                break;
            case 'failed':
                statusElement.innerHTML = '<i class="fas fa-exclamation-triangle"></i>';
                textElement.textContent = 'Failed';
                break;
        }
        
        // Update progress bar
        const progressPercent = (scenario.completed / scenario.total) * 100;
        progressElement.style.width = `${progressPercent}%`;
        
        // Update issues count
        issuesElement.textContent = `${scenario.completed}/${scenario.total}`;
    }
    
    updateOverallProgress() {
        const totalScenarios = Object.keys(this.scenarios).length;
        const completedScenarios = Object.values(this.scenarios).filter(s => s.status === 'completed').length;
        const overallPercent = (completedScenarios / totalScenarios) * 100;
        
        // Update progress bar
        document.getElementById('overallProgress').style.width = `${overallPercent}%`;
        
        // Update stats
        document.getElementById('completedScenarios').textContent = completedScenarios;
        document.getElementById('totalScenarios').textContent = totalScenarios;
        
        // Update time spent
        const timeSpent = Math.floor((Date.now() - this.workshopStartTime) / 60000);
        document.getElementById('timeSpent').textContent = timeSpent;
        
        // Update last updated time
        document.getElementById('lastUpdated').textContent = new Date().toLocaleTimeString();
    }
    
    updateDisplay() {
        Object.keys(this.scenarios).forEach(scenarioName => {
            this.updateScenarioDisplay(scenarioName);
        });
        this.updateOverallProgress();
    }
    
    startAutoRefresh() {
        // Refresh every 30 seconds
        this.refreshInterval = setInterval(() => {
            this.checkClusterStatus();
            this.updateOverallProgress();
        }, 30000);
    }
    
    setupEventListeners() {
        // Auto-refresh scenarios that are running
        setInterval(() => {
            Object.keys(this.scenarios).forEach(scenarioName => {
                if (this.scenarios[scenarioName].status === 'running') {
                    this.checkScenarioStatus(scenarioName);
                }
            });
        }, 10000); // Check every 10 seconds
    }
    
    // Public methods for button interactions
    startScenario(scenarioName) {
        const scenario = this.scenarios[scenarioName];
        if (scenario && scenario.status === 'pending') {
            scenario.status = 'running';
            scenario.startTime = Date.now();
            this.updateScenarioDisplay(scenarioName);
            this.saveProgress();
            
            // Show command to run
            this.showCommand(`./scenario-manager.sh run ${scenarioName} inject`);
        }
    }
    
    checkStatus(scenarioName) {
        this.checkScenarioStatus(scenarioName);
        this.showCommand(`./scenario-manager.sh status ${scenarioName}`);
    }
    
    showHints(scenarioName) {
        this.showCommand(`./scenario-manager.sh hint ${scenarioName}`);
        
        // Show hints in a modal-like overlay
        this.displayHintsModal(scenarioName);
    }
    
    displayHintsModal(scenarioName) {
        // Create hints modal
        const modal = document.createElement('div');
        modal.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.8);
            z-index: 10000;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        `;
        
        const content = document.createElement('div');
        content.style.cssText = `
            background: white;
            border-radius: 12px;
            padding: 30px;
            max-width: 800px;
            max-height: 80vh;
            overflow-y: auto;
            position: relative;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        `;
        
        const closeBtn = document.createElement('button');
        closeBtn.innerHTML = '<i class="fas fa-times"></i>';
        closeBtn.style.cssText = `
            position: absolute;
            top: 15px;
            right: 15px;
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #6c757d;
            padding: 5px;
        `;
        closeBtn.onclick = () => document.body.removeChild(modal);
        
        content.innerHTML = this.getHintsContent(scenarioName);
        content.appendChild(closeBtn);
        modal.appendChild(content);
        document.body.appendChild(modal);
        
        // Close on background click
        modal.onclick = (e) => {
            if (e.target === modal) {
                document.body.removeChild(modal);
            }
        };
    }
    
    getHintsContent(scenarioName) {
        const hintsData = {
            'pod-startup-failures': {
                title: '🐛 Pod Startup Failures - Progressive Hints',
                levels: [
                    {
                        title: 'Level 1 Hints (Start Here)',
                        hints: [
                            'Always start with <code>kubectl get pods -A</code> to see the overall status',
                            'Look for pods in "Pending", "ImagePullBackOff", or "CrashLoopBackOff" states',
                            'Use <code>kubectl describe pod &lt;pod-name&gt;</code> to get detailed information'
                        ]
                    },
                    {
                        title: 'Level 2 Hints (If Still Stuck)',
                        hints: [
                            'Check events with <code>kubectl get events --sort-by=.metadata.creationTimestamp</code>',
                            'For ImagePullBackOff: Check image name, registry access, and credentials',
                            'For Pending pods: Check node resources with <code>kubectl top nodes</code>',
                            'For CrashLoopBackOff: Check logs with <code>kubectl logs &lt;pod-name&gt;</code>'
                        ]
                    },
                    {
                        title: 'Level 3 Hints (Deep Debugging)',
                        hints: [
                            'Check resource requests/limits in pod specifications',
                            'Verify secrets exist: <code>kubectl get secrets</code>',
                            'Check node selectors and taints: <code>kubectl describe nodes</code>',
                            'For persistent issues, check admission controllers and policies'
                        ]
                    }
                ]
            },
            'dns-issues': {
                title: '🌐 DNS Resolution Apocalypse - Progressive Hints',
                levels: [
                    {
                        title: 'Level 1 Hints (Start Here)',
                        hints: [
                            'Test DNS resolution: <code>kubectl run dns-test --image=busybox --rm -it --restart=Never -- nslookup kubernetes.default</code>',
                            'Check CoreDNS pods: <code>kubectl get pods -n kube-system -l k8s-app=kube-dns</code>',
                            'Look at CoreDNS logs: <code>kubectl logs -n kube-system -l k8s-app=kube-dns</code>'
                        ]
                    },
                    {
                        title: 'Level 2 Hints (If Still Stuck)',
                        hints: [
                            'Check CoreDNS config: <code>kubectl get configmap coredns -n kube-system -o yaml</code>',
                            'Verify service endpoints: <code>kubectl get endpoints</code>',
                            'Test service discovery: <code>kubectl run test --image=busybox --rm -it --restart=Never -- nslookup &lt;service-name&gt;</code>',
                            'Check network policies: <code>kubectl get networkpolicies -A</code>'
                        ]
                    },
                    {
                        title: 'Level 3 Hints (Deep Debugging)',
                        hints: [
                            'Check kube-dns service: <code>kubectl get svc kube-dns -n kube-system</code>',
                            'Verify DNS policy in pods: Look for "dnsPolicy" in pod specs',
                            'Check cluster DNS settings: <code>kubectl get nodes -o yaml | grep -A 5 -B 5 dns</code>',
                            'Test external DNS: <code>kubectl run test --image=busybox --rm -it --restart=Never -- nslookup google.com</code>'
                        ]
                    }
                ]
            },
            'rbac-issues': {
                title: '🔐 RBAC Permission Nightmare - Progressive Hints',
                levels: [
                    {
                        title: 'Level 1 Hints (Start Here)',
                        hints: [
                            'Test permissions: <code>kubectl auth can-i &lt;verb&gt; &lt;resource&gt;</code>',
                            'Check what you can do: <code>kubectl auth can-i --list</code>',
                            'Look for "Forbidden" errors in kubectl output'
                        ]
                    },
                    {
                        title: 'Level 2 Hints (If Still Stuck)',
                        hints: [
                            'Check service accounts: <code>kubectl get serviceaccounts -A</code>',
                            'List roles and role bindings: <code>kubectl get roles,rolebindings -A</code>',
                            'Check cluster roles: <code>kubectl get clusterroles,clusterrolebindings</code>',
                            'Test as specific user: <code>kubectl auth can-i &lt;verb&gt; &lt;resource&gt; --as=&lt;user&gt;</code>'
                        ]
                    },
                    {
                        title: 'Level 3 Hints (Deep Debugging)',
                        hints: [
                            'Describe role bindings: <code>kubectl describe rolebinding &lt;binding-name&gt;</code>',
                            'Check pod service account: <code>kubectl get pod &lt;pod-name&gt; -o yaml | grep serviceAccount</code>',
                            'Verify service account tokens: <code>kubectl describe serviceaccount &lt;sa-name&gt;</code>',
                            'Check for missing subjects in role bindings'
                        ]
                    }
                ]
            },
            'node-not-ready': {
                title: '🖥️ Node Health Crisis - Progressive Hints',
                levels: [
                    {
                        title: 'Level 1 Hints (Start Here)',
                        hints: [
                            'Check node status: <code>kubectl get nodes</code>',
                            'Look for "NotReady" or "Unknown" node states',
                            'Check node details: <code>kubectl describe node &lt;node-name&gt;</code>'
                        ]
                    },
                    {
                        title: 'Level 2 Hints (If Still Stuck)',
                        hints: [
                            'Check node resources: <code>kubectl top nodes</code>',
                            'Look at node conditions in <code>kubectl describe node</code> output',
                            'Check kubelet logs on the node (if accessible)',
                            'Verify node capacity vs allocatable resources'
                        ]
                    },
                    {
                        title: 'Level 3 Hints (Deep Debugging)',
                        hints: [
                            'Check for resource pressure: disk, memory, PID pressure',
                            'Look for taints: <code>kubectl describe node | grep -A 5 Taints</code>',
                            'Check pod distribution: <code>kubectl get pods -A -o wide</code>',
                            'Verify cluster autoscaler logs if using autoscaling'
                        ]
                    }
                ]
            },
            'image-pull-errors': {
                title: '📦 Image Registry Disasters - Progressive Hints',
                levels: [
                    {
                        title: 'Level 1 Hints (Start Here)',
                        hints: [
                            'Look for "ImagePullBackOff" or "ErrImagePull" pod status',
                            'Check the exact error: <code>kubectl describe pod &lt;pod-name&gt;</code>',
                            'Verify the image name and tag in the pod specification'
                        ]
                    },
                    {
                        title: 'Level 2 Hints (If Still Stuck)',
                        hints: [
                            'Check if image exists: Try <code>docker pull &lt;image&gt;</code>',
                            'For private registries, check image pull secrets: <code>kubectl get secrets</code>',
                            'Verify service account has access to image pull secrets',
                            'Check registry authentication and network connectivity'
                        ]
                    },
                    {
                        title: 'Level 3 Hints (Deep Debugging)',
                        hints: [
                            'Check node ability to reach registry: Network policies, firewalls',
                            'Verify image pull secret format: <code>kubectl get secret &lt;secret&gt; -o yaml</code>',
                            'Check if using correct registry URL (especially for ECR)',
                            'For ECR: Verify IAM permissions and token expiration'
                        ]
                    }
                ]
            }
        };
        
        const data = hintsData[scenarioName];
        if (!data) return '<h2>No hints available for this scenario</h2>';
        
        let html = `<h2 style="color: #2c3e50; margin-bottom: 20px;">${data.title}</h2>`;
        
        data.levels.forEach((level, index) => {
            const colors = ['#28a745', '#17a2b8', '#6f42c1'];
            html += `
                <div style="margin-bottom: 25px;">
                    <h3 style="color: ${colors[index]}; margin-bottom: 15px;">${level.title}</h3>
                    <ul style="list-style: none; padding: 0;">
            `;
            
            level.hints.forEach((hint, hintIndex) => {
                html += `
                    <li style="margin-bottom: 10px; padding: 10px; background: #f8f9fa; border-radius: 6px; border-left: 4px solid ${colors[index]};">
                        <strong>💡 Hint ${index * 4 + hintIndex + 1}:</strong> ${hint}
                    </li>
                `;
            });
            
            html += '</ul></div>';
        });
        
        html += `
            <div style="margin-top: 30px; padding: 20px; background: #e3f2fd; border-radius: 8px; border-left: 4px solid #2196f3;">
                <strong>🎓 Learning Tip:</strong> Work through hints progressively. Try Level 1 first!<br>
                <strong>🚀 Need Solutions?</strong> Run: <code>./scenario-manager.sh run ${scenarioName} restore</code>
            </div>
        `;
        
        return html;
    }
    
    showCommand(command) {
        // Create a temporary notification
        const notification = document.createElement('div');
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: #2c3e50;
            color: white;
            padding: 15px 20px;
            border-radius: 8px;
            font-family: Monaco, monospace;
            font-size: 14px;
            z-index: 1000;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            animation: slideIn 0.3s ease;
        `;
        notification.textContent = `Run: ${command}`;
        
        document.body.appendChild(notification);
        
        // Auto-remove after 5 seconds
        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 300);
        }, 5000);
        
        // Copy to clipboard
        navigator.clipboard.writeText(command).catch(() => {
            console.warn('Failed to copy command to clipboard');
        });
    }
}

// Commands panel toggle
function toggleCommands() {
    const content = document.getElementById('commandsContent');
    const toggle = document.getElementById('commandsToggle');
    
    if (content.classList.contains('expanded')) {
        content.classList.remove('expanded');
        toggle.style.transform = 'rotate(0deg)';
    } else {
        content.classList.add('expanded');
        toggle.style.transform = 'rotate(180deg)';
    }
}

// Global functions for button interactions
function startScenario(scenarioName) {
    window.progressTracker.startScenario(scenarioName);
}

function checkStatus(scenarioName) {
    window.progressTracker.checkStatus(scenarioName);
}

function showHints(scenarioName) {
    window.progressTracker.showHints(scenarioName);
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// Initialize the progress tracker when the page loads
document.addEventListener('DOMContentLoaded', () => {
    window.progressTracker = new WorkshopProgressTracker();
});

// Handle page visibility changes
document.addEventListener('visibilitychange', () => {
    if (!document.hidden) {
        // Page became visible, refresh data
        window.progressTracker.checkClusterStatus();
        window.progressTracker.updateDisplay();
    }
});

// Handle beforeunload to save progress
window.addEventListener('beforeunload', () => {
    if (window.progressTracker) {
        window.progressTracker.saveProgress();
    }
});
