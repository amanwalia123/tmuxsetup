#!/usr/bin/env bash

# ============================================
# Tmux Setup Installation Script
# Compatible with Mac and Linux
# ============================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_info "Detected OS: macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        print_info "Detected OS: Linux"
    else
        print_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

# Check if tmux is installed
check_tmux() {
    if command -v tmux &> /dev/null; then
        TMUX_VERSION=$(tmux -V | cut -d' ' -f2)
        print_info "Tmux is already installed (version: $TMUX_VERSION)"
        return 0
    else
        print_warning "Tmux is not installed"
        return 1
    fi
}

# Install tmux based on OS
install_tmux() {
    print_info "Installing tmux..."
    
    if [[ "$OS" == "macos" ]]; then
        if command -v brew &> /dev/null; then
            brew install tmux
        else
            print_error "Homebrew is not installed. Please install Homebrew first:"
            print_error "https://brew.sh/"
            exit 1
        fi
    elif [[ "$OS" == "linux" ]]; then
        if command -v apt-get &> /dev/null; then
            print_info "Using apt-get..."
            sudo apt-get update
            sudo apt-get install -y tmux
        elif command -v yum &> /dev/null; then
            print_info "Using yum..."
            sudo yum install -y tmux
        elif command -v dnf &> /dev/null; then
            print_info "Using dnf..."
            sudo dnf install -y tmux
        elif command -v pacman &> /dev/null; then
            print_info "Using pacman..."
            sudo pacman -S --noconfirm tmux
        else
            print_error "Could not find a supported package manager (apt-get, yum, dnf, pacman)"
            exit 1
        fi
    fi
    
    if check_tmux; then
        print_success "Tmux installed successfully!"
    else
        print_error "Failed to install tmux"
        exit 1
    fi
}

# Backup existing tmux configuration
backup_config() {
    if [[ -f "$HOME/.tmux.conf" ]]; then
        BACKUP_FILE="$HOME/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Existing tmux config found. Creating backup at: $BACKUP_FILE"
        cp "$HOME/.tmux.conf" "$BACKUP_FILE"
        print_success "Backup created successfully!"
    fi
}

# Install tmux configuration
install_config() {
    print_info "Installing tmux configuration..."
    
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    CONFIG_FILE="$SCRIPT_DIR/.tmux.conf"
    
    # If config file doesn't exist locally, download it from GitHub
    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_info "Downloading configuration file from GitHub..."
        CONFIG_URL="https://raw.githubusercontent.com/amanwalia123/tmuxsetup/main/.tmux.conf"
        
        # Try curl first, then wget
        if command -v curl &> /dev/null; then
            if ! curl -fsSL "$CONFIG_URL" -o "$HOME/.tmux.conf.tmp"; then
                print_error "Failed to download configuration file with curl"
                exit 1
            fi
        elif command -v wget &> /dev/null; then
            if ! wget -q "$CONFIG_URL" -O "$HOME/.tmux.conf.tmp"; then
                print_error "Failed to download configuration file with wget"
                exit 1
            fi
        else
            print_error "Neither curl nor wget is available. Please install one of them first:"
            if [[ "$OS" == "linux" ]]; then
                print_error "  Ubuntu/Debian: sudo apt-get install curl"
                print_error "  CentOS/RHEL: sudo yum install curl"
                print_error "  Fedora: sudo dnf install curl"
                print_error "  Arch: sudo pacman -S curl"
            fi
            exit 1
        fi
        
        if [[ ! -f "$HOME/.tmux.conf.tmp" ]]; then
            print_error "Failed to download configuration file"
            exit 1
        fi
        
        CONFIG_FILE="$HOME/.tmux.conf.tmp"
    fi
    
    # Backup existing config
    backup_config
    
    # Copy new config
    cp "$CONFIG_FILE" "$HOME/.tmux.conf"
    
    # Clean up temporary file if it was downloaded
    if [[ -f "$HOME/.tmux.conf.tmp" ]]; then
        rm "$HOME/.tmux.conf.tmp"
    fi
    
    print_success "Configuration installed to $HOME/.tmux.conf"
}

# Install dependencies for clipboard support
install_clipboard_support() {
    print_info "Installing clipboard support..."
    
    if [[ "$OS" == "linux" ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y xclip
        elif command -v yum &> /dev/null; then
            sudo yum install -y xclip
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y xclip
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm xclip
        else
            print_warning "Could not install xclip. Clipboard support may not work."
            print_info "You can manually install xclip later for clipboard support."
        fi
    fi
}

# Check for basic dependencies
check_dependencies() {
    print_info "Checking basic dependencies..."
    
    local missing_deps=()
    
    # Check for curl or wget (needed for downloading config)
    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        missing_deps+=("curl or wget")
    fi
    
    # Check for basic shell tools
    if ! command -v cut &> /dev/null; then
        missing_deps+=("cut")
    fi
    
    if ! command -v date &> /dev/null; then
        missing_deps+=("date")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Please install them using your package manager:"
        if [[ "$OS" == "linux" ]]; then
            print_info "  Ubuntu/Debian: sudo apt-get install curl coreutils"
            print_info "  CentOS/RHEL: sudo yum install curl coreutils"
            print_info "  Fedora: sudo dnf install curl coreutils"
            print_info "  Arch: sudo pacman -S curl coreutils"
        fi
        return 1
    fi
    
    print_success "All dependencies are available"
    return 0
}

# Display usage information
show_usage() {
    cat << EOF

${GREEN}Tmux Setup Installation Complete!${NC}

${BLUE}Quick Start:${NC}
  1. Start tmux: ${YELLOW}tmux${NC}
  2. Create new session: ${YELLOW}tmux new -s mysession${NC}
  3. Attach to session: ${YELLOW}tmux attach -t mysession${NC}
  4. List sessions: ${YELLOW}tmux ls${NC}

${BLUE}Key Bindings (Prefix: Ctrl+a):${NC}
  Ctrl+a |       - Split pane vertically
  Ctrl+a -       - Split pane horizontally
  Ctrl+a h/j/k/l - Navigate panes (Vim-style)
  Ctrl+a c       - Create new window
  Ctrl+a n/p     - Next/Previous window
  Ctrl+a r       - Reload config
  Ctrl+a [       - Enter copy mode (Esc to exit)
  Ctrl+a S       - Synchronize panes
  Ctrl+a x       - Kill current pane
  Ctrl+a X       - Kill current window

${BLUE}Mouse Support:${NC}
  - Click to select pane
  - Click and drag to resize panes
  - Scroll to navigate history

${BLUE}Configuration File:${NC}
  ~/.tmux.conf

${BLUE}To reload configuration:${NC}
  ${YELLOW}tmux source-file ~/.tmux.conf${NC}
  Or press: ${YELLOW}Ctrl+a r${NC} inside tmux

${BLUE}For more information, see:${NC}
  README.md

EOF
}

# Main installation process
main() {
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════╗"
    echo "║   Tmux Setup Installation Script      ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Detect OS
    detect_os
    
    # Check basic dependencies first
    if ! check_dependencies; then
        print_error "Please install the missing dependencies and run the script again."
        exit 1
    fi
    
    # Check if tmux is installed, if not, install it
    if ! check_tmux; then
        read -p "Would you like to install tmux? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_tmux
        else
            print_error "Tmux is required. Exiting..."
            exit 1
        fi
    fi
    
    # Install configuration
    install_config
    
    # Install clipboard support (Linux only)
    if [[ "$OS" == "linux" ]]; then
        read -p "Would you like to install clipboard support (xclip)? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_clipboard_support
        fi
    fi
    
    # Show usage information
    show_usage
    
    print_success "Installation complete! Enjoy your tmux setup!"
}

# Run main function
main
