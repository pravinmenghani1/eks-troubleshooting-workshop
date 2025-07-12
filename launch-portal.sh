#!/bin/bash

# Launch Progress Portal Script
# This script starts a local web server for the workshop progress portal

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_banner() {
    clear
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    📊 EKS TROUBLESHOOTING WORKSHOP - PROGRESS PORTAL 📊                     ║
║                                                                              ║
║    Track your debugging journey with real-time progress updates!             ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# Check if Python is available
check_python() {
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
        return 0
    elif command -v python &> /dev/null; then
        PYTHON_CMD="python"
        return 0
    else
        return 1
    fi
}

# Check if Node.js is available
check_node() {
    if command -v node &> /dev/null && command -v npx &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Start Python HTTP server
start_python_server() {
    local port=${1:-8080}
    echo -e "${CYAN}Starting Python HTTP server on port $port...${NC}"
    
    cd progress-portal
    
    if [[ "$PYTHON_CMD" == "python3" ]]; then
        $PYTHON_CMD -m http.server $port
    else
        $PYTHON_CMD -m SimpleHTTPServer $port
    fi
}

# Start Node.js server
start_node_server() {
    local port=${1:-8080}
    echo -e "${CYAN}Starting Node.js HTTP server on port $port...${NC}"
    
    cd progress-portal
    npx http-server -p $port -o
}

# Find available port
find_available_port() {
    local port=8080
    while lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; do
        ((port++))
    done
    echo $port
}

# Main function
main() {
    print_banner
    
    # Check if progress-portal directory exists
    if [ ! -d "progress-portal" ]; then
        print_error "Progress portal directory not found!"
        print_info "Make sure you're running this script from the workshop root directory."
        exit 1
    fi
    
    # Find available port
    PORT=$(find_available_port)
    print_info "Using port: $PORT"
    
    # Try to start server
    if check_python; then
        print_success "Python found: $PYTHON_CMD"
        print_info "Starting progress portal..."
        echo ""
        echo -e "${GREEN}🚀 Progress Portal will be available at:${NC}"
        echo -e "${YELLOW}   http://localhost:$PORT${NC}"
        echo ""
        echo -e "${CYAN}📋 Instructions:${NC}"
        echo "1. Keep this terminal window open"
        echo "2. Open the URL above in your browser"
        echo "3. Use the portal to track your workshop progress"
        echo "4. Press Ctrl+C to stop the server"
        echo ""
        echo -e "${YELLOW}Starting server in 3 seconds...${NC}"
        sleep 3
        
        # Open browser automatically (macOS/Linux)
        if command -v open &> /dev/null; then
            open "http://localhost:$PORT" 2>/dev/null &
        elif command -v xdg-open &> /dev/null; then
            xdg-open "http://localhost:$PORT" 2>/dev/null &
        fi
        
        start_python_server $PORT
        
    elif check_node; then
        print_success "Node.js found"
        print_info "Starting progress portal with Node.js..."
        echo ""
        echo -e "${GREEN}🚀 Progress Portal will be available at:${NC}"
        echo -e "${YELLOW}   http://localhost:$PORT${NC}"
        echo ""
        start_node_server $PORT
        
    else
        print_error "Neither Python nor Node.js found!"
        echo ""
        echo -e "${YELLOW}To use the progress portal, install one of the following:${NC}"
        echo ""
        echo -e "${CYAN}Option 1 - Python:${NC}"
        echo "  macOS: brew install python3"
        echo "  Ubuntu/Debian: sudo apt install python3"
        echo "  CentOS/RHEL: sudo yum install python3"
        echo ""
        echo -e "${CYAN}Option 2 - Node.js:${NC}"
        echo "  macOS: brew install node"
        echo "  Ubuntu/Debian: sudo apt install nodejs npm"
        echo "  CentOS/RHEL: sudo yum install nodejs npm"
        echo ""
        echo -e "${CYAN}Alternative - Manual:${NC}"
        echo "  Open progress-portal/index.html directly in your browser"
        echo "  (Some features may not work without a web server)"
        exit 1
    fi
}

# Handle Ctrl+C gracefully
trap 'echo -e "\n${YELLOW}Shutting down progress portal...${NC}"; exit 0' INT

# Show help
show_help() {
    echo "EKS Troubleshooting Workshop - Progress Portal Launcher"
    echo ""
    echo "This script starts a local web server for the workshop progress portal."
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -p, --port     Specify port number (default: auto-detect)"
    echo ""
    echo "Examples:"
    echo "  $0             # Start with auto-detected port"
    echo "  $0 -p 3000     # Start on port 3000"
    echo ""
    echo "Requirements:"
    echo "  - Python 3.x OR Node.js"
    echo "  - Web browser"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Run main function
main
