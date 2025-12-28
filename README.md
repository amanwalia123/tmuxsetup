# Tmux Setup

A cross-platform tmux configuration that works seamlessly on both macOS and Linux. This setup includes sensible defaults, useful key bindings, and an easy installation process.

## Features

### 🎨 Visual Enhancements
- True color support with optimized terminal settings
- Custom status bar with useful information (session, time, user, hostname)
- Color-coded pane borders for better visibility
- Clean and minimal design
- Automatic window renaming based on current command
- Enhanced cursor shape support in modern terminals

### ⌨️ Improved Key Bindings
- **Prefix changed to `Ctrl+a`** (more ergonomic than default `Ctrl+b`)
- Intuitive pane splitting: `|` for vertical, `-` for horizontal
- Vim-style pane navigation (`h`, `j`, `k`, `l`)
- Alt+Arrow keys for quick pane switching (no prefix needed)
- Easy pane resizing with `H`, `J`, `K`, `L`
- Mouse support enabled for clicking, dragging, and scrolling

### 🚀 Productivity Features
- Copy mode with vi key bindings
- Clipboard integration (macOS and Linux)
- Pane synchronization toggle
- 50,000 line scrollback buffer
- Windows and panes start at index 1 (easier to reach)
- Automatic window renumbering
- Current path preserved when creating new windows/panes

### 🔧 Quality of Life
- No escape key delay
- Activity monitoring
- Easy config reload (`Ctrl+a r`)
- Automatic OS detection for platform-specific features

## Quick Start

### Installation

#### One-Liner Installation (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/amanwalia123/tmuxsetup/main/install.sh | bash
```

#### Manual Installation
1. Clone this repository:
```bash
git clone https://github.com/amanwalia123/tmuxsetup.git
cd tmuxsetup
```

2. Run the installation script:
```bash
./install.sh
```

The script will:
- Detect your operating system (macOS or Linux)
- Install tmux if not already installed
- Backup your existing tmux config (if any)
- Install the new configuration
- Optionally install clipboard support (Linux)

### Manual Installation

If you prefer to install manually:

1. Copy the configuration file:
```bash
cp .tmux.conf ~/.tmux.conf
```

2. Install tmux:
   - **macOS**: `brew install tmux`
   - **Ubuntu/Debian**: `sudo apt-get install tmux`
   - **CentOS/RHEL**: `sudo yum install tmux`
   - **Fedora**: `sudo dnf install tmux`
   - **Arch**: `sudo pacman -S tmux`

3. (Linux only) Install clipboard support:
```bash
sudo apt-get install xclip  # Ubuntu/Debian
# or
sudo yum install xclip      # CentOS/RHEL
```

4. Start tmux:
```bash
tmux
```

## Usage

### Basic Commands

Start a new tmux session:
```bash
tmux
```

Start a named session:
```bash
tmux new -s myproject
```

List all sessions:
```bash
tmux ls
```

Attach to a session:
```bash
tmux attach -t myproject
```

Detach from session (inside tmux):
```
Ctrl+a d
```

### Key Bindings Reference

**Note**: The prefix key is `Ctrl+a` (not the default `Ctrl+b`)

#### Window Management
| Key Binding | Action |
|-------------|--------|
| `Ctrl+a c` | Create new window |
| `Ctrl+a ,` | Rename current window |
| `Ctrl+a n` | Next window |
| `Ctrl+a p` | Previous window |
| `Ctrl+a 0-9` | Switch to window by number |
| `Ctrl+a X` | Kill current window |
| `Ctrl+Shift+Left` | Previous window (no prefix) |
| `Ctrl+Shift+Right` | Next window (no prefix) |

#### Pane Management
| Key Binding | Action |
|-------------|--------|
| `Ctrl+a \|` | Split pane vertically |
| `Ctrl+a -` | Split pane horizontally |
| `Ctrl+a h` | Move to left pane |
| `Ctrl+a j` | Move to bottom pane |
| `Ctrl+a k` | Move to top pane |
| `Ctrl+a l` | Move to right pane |
| `Alt+Arrow` | Move to pane (no prefix) |
| `Ctrl+a H` | Resize pane left |
| `Ctrl+a J` | Resize pane down |
| `Ctrl+a K` | Resize pane up |
| `Ctrl+a L` | Resize pane right |
| `Ctrl+a x` | Kill current pane |
| `Ctrl+a S` | Synchronize panes (type in all at once) |

#### Copy Mode & Other
| Key Binding | Action |
|-------------|--------|
| `Ctrl+a [` | Enter copy mode |
| `Ctrl+a Esc` | Enter copy mode |
| `v` | Begin selection (in copy mode) |
| `y` | Copy selection (in copy mode) |
| `Ctrl+a r` | Reload configuration |
| `Ctrl+a ?` | List all key bindings |
| `Ctrl+a Space` | Switch to last pane |
| `Ctrl+a Tab` | Switch to last window |
| `Ctrl+a C-k` | Clear pane history |
| `Ctrl+a z` | Toggle pane zoom |
| `Ctrl+a C-u` | Swap with previous pane |
| `Ctrl+a C-d` | Swap with next pane |
| `Ctrl+a b` | Break pane into new window |
| `Ctrl+a J` | Join pane from another window |
| `Ctrl+a s` | Show session tree |
| `Ctrl+a d` | Detach from session |

#### Mouse Support
- Click to select a pane
- Click and drag pane borders to resize
- Scroll wheel to navigate history
- Double-click to select word
- Triple-click to select line

## Configuration

The main configuration file is `~/.tmux.conf`. You can customize it to your liking.

### Reload Configuration

After making changes to `.tmux.conf`, reload it without restarting tmux:

Inside tmux:
```
Ctrl+a r
```

Or from the command line:
```bash
tmux source-file ~/.tmux.conf
```

### Customization Tips

Edit `~/.tmux.conf` and modify:
- Colors: Look for `colour` settings in the status bar section
- Key bindings: Add your own `bind` commands
- Prefix key: Change `set -g prefix` to your preferred key
- Status bar: Customize `status-left` and `status-right`

## Uninstallation

To remove this tmux configuration:

```bash
./uninstall.sh
```

The script will:
- Remove the configuration file
- Optionally restore your previous backup
- Optionally kill all tmux sessions
- Optionally remove plugin directories

Note: This does not uninstall tmux itself.

## Advanced Features

### Tmux Plugin Manager (TPM)

The configuration includes commented-out support for TPM. To enable:

1. Install TPM:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

2. Uncomment the plugin section at the bottom of `~/.tmux.conf`

3. Reload tmux config and install plugins:
```
Ctrl+a r
Ctrl+a I  (capital I to install)
```

Recommended plugins:
- `tmux-resurrect`: Save and restore tmux sessions
- `tmux-continuum`: Automatic session saving
- `tmux-yank`: Enhanced clipboard support

## Troubleshooting

### Colors not displaying correctly
Make sure your terminal supports 256 colors:
```bash
echo $TERM  # should show something like "xterm-256color" or "screen-256color"
```

### Clipboard not working on Linux
Install xclip:
```bash
sudo apt-get install xclip
```

### Mouse not working
Mouse support requires tmux 2.1+. Check your version:
```bash
tmux -V
```

### Key bindings not working
Make sure you're using the correct prefix (`Ctrl+a`, not `Ctrl+b`)

## Compatibility

- **tmux**: 2.1+ (mouse support requires 2.1+)
- **macOS**: 10.10+
- **Linux**: Most modern distributions

## Contributing

Feel free to submit issues and pull requests for improvements!

## License

This configuration is provided as-is for personal and commercial use.

## Resources

- [Tmux Manual](https://man.openbsd.org/tmux.1)
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

---

**Happy tmuxing! 🚀**
