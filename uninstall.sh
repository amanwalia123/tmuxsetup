#!/usr/bin/env bash

# ============================================
# Tmux Setup Uninstallation Script
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

# Remove tmux configuration
remove_config() {
    if [[ -f "$HOME/.tmux.conf" ]]; then
        print_info "Removing tmux configuration..."
        rm "$HOME/.tmux.conf"
        print_success "Configuration removed: $HOME/.tmux.conf"
    else
        print_warning "No tmux configuration found at $HOME/.tmux.conf"
    fi
}

# Restore backup if available
restore_backup() {
    # Find the most recent backup
    BACKUP_FILE=$(ls -t "$HOME/.tmux.conf.backup."* 2>/dev/null | head -n1)
    
    if [[ -n "$BACKUP_FILE" ]]; then
        read -p "Found backup: $BACKUP_FILE. Would you like to restore it? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp "$BACKUP_FILE" "$HOME/.tmux.conf"
            print_success "Backup restored to $HOME/.tmux.conf"
        fi
    fi
}

# Remove tmux plugins directory (if using TPM)
remove_plugins() {
    if [[ -d "$HOME/.tmux/plugins" ]]; then
        read -p "Remove tmux plugins directory? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$HOME/.tmux/plugins"
            print_success "Plugins directory removed"
        fi
    fi
}

# Kill all tmux sessions
kill_sessions() {
    if command -v tmux &> /dev/null; then
        if tmux list-sessions &> /dev/null; then
            read -p "Kill all running tmux sessions? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                tmux kill-server
                print_success "All tmux sessions killed"
            fi
        fi
    fi
}

# Main uninstallation process
main() {
    echo -e "${YELLOW}"
    echo "╔════════════════════════════════════════╗"
    echo "║   Tmux Setup Uninstallation Script    ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    print_warning "This will remove your tmux configuration."
    read -p "Are you sure you want to continue? (y/n) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Uninstallation cancelled."
        exit 0
    fi
    
    # Kill sessions first (if requested)
    kill_sessions
    
    # Remove configuration
    remove_config
    
    # Restore backup (if available)
    restore_backup
    
    # Remove plugins (if any)
    remove_plugins
    
    echo
    print_success "Uninstallation complete!"
    print_info "Note: This script does not uninstall tmux itself."
    print_info "To uninstall tmux:"
    print_info "  macOS: brew uninstall tmux"
    print_info "  Linux: sudo apt-get remove tmux (or yum/dnf/pacman)"
}

# Run main function
main
