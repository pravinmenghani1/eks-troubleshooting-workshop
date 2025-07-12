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
