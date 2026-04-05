<h1 align="center">
  <br>
  <img src="https://em-content.zobj.net/source/apple/391/sun-with-face_1f31e.png" width="80" alt="GMT">
  <br>
  Good Morning Terminal
  <br>
</h1>

<p align="center">
  <strong>A warm home screen that greets you every time you open your terminal.</strong>
</p>

<p align="center">
  <a href="#installation">Installation</a> •
  <a href="#features">Features</a> •
  <a href="#commands">Commands</a> •
  <a href="#configuration">Configuration</a> •
  <a href="#i18n">Languages</a> •
  <a href="#contributing">Contributing</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-0.1.0-blue?style=flat-square" alt="Version">
  <img src="https://img.shields.io/badge/shell-bash%20%7C%20zsh-green?style=flat-square" alt="Shell">
  <img src="https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/license-MIT-orange?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/startup-%3C%20100ms-brightgreen?style=flat-square" alt="Performance">
</p>

<p align="center">
  <a href="README.ko.md">한국어</a>
</p>

---

```
 ┌────────────────────────────────────────────────────┐
 │  ☀ Good morning, kyoungmin!                         │
 │  Sun, 4/6 · 9:23 AM                                │
 │  Seoul 18°C Clear                                   │
 └────────────────────────────────────────────────────┘

 📂 Recent Projects
  [1] ~/projects/my-app           3h ago
  [2] ~/projects/blog              yesterday
  [3] ~/work/api-server            3d ago

  Jump to a project → gmt go 1

 ⚙ System
  git 2.43.0    node 20.11.0    python 3.12.2
  branch: main  ✓ clean         npm 10.2.4

 📋 Today's Goal: Finish API endpoints

  [ ] Design login page
  [✓] Design DB schema
  [ ] Write README

  gmt add "task"  ·  gmt done 1  ·  gmt goal "goal"

 📊 Activity (12 weeks)
  Mon  ░░▓▓░░▓▓▓░░░▓▓░░▓▓▓▓░░▓░░░▓▓▓░▓▓░░▓▓▓░░▓▓░░▓▓▓▓
  Wed  ░▓▓░░▓▓▓░░░░▓▓▓░▓▓▓░░░▓▓░░▓▓▓░░▓▓▓░▓▓▓░░▓▓▓░▓▓▓▓
  Fri  ░░▓░░░▓▓░░░░░▓▓░░▓▓░░░░▓░░░▓▓░░░▓▓░░▓▓░░░▓░░░▓▓░
  ·····················································today
```

## Why?

Vibe-coding tools like Cursor and Claude Code are bringing new people to the terminal every day. But a default terminal greets you with nothing but a blank prompt — cold and intimidating.

**Good Morning Terminal** is a shell script dashboard that runs automatically when you open your terminal. It shows a time-aware greeting, today's tasks, recent project shortcuts, system status, and an activity log — all at a glance.

> No dependencies. No frameworks. Pure shell. Under 100ms.

## Features

- **Time-aware Greeting** — Morning/afternoon/evening greeting + weather via [wttr.in](https://wttr.in)
- **Recent Projects** — Auto-tracks git projects on `cd`, jump back with `gmt go 1`
- **To-Do List** — Lightweight task management with `gmt add "task"`
- **Daily Goal** — Set a daily goal with `gmt goal "goal"` (auto-expires at midnight)
- **System Info** — git, node, python versions + current branch status
- **Activity Heatmap** — GitHub-style contribution graph for your terminal activity
- **i18n** — Korean and English built-in. Community translations welcome!
- **Blazing Fast** — ~100ms startup. Cache-first design, minimal subshells

## Requirements

- **Shell**: bash 3.2+ or zsh 5.0+
- **OS**: macOS or Linux
- **Optional**: `curl` (for weather)

No other external dependencies. Pure shell scripts.

## Installation

### One-liner

```bash
git clone https://github.com/coldpak/gmt.git ~/.gmt && bash ~/.gmt/install.sh
```

### Manual

```bash
git clone https://github.com/coldpak/gmt.git ~/.gmt
echo 'source ~/.gmt/gmt.sh' >> ~/.zshrc   # or ~/.bashrc
source ~/.zshrc
```

An interactive onboarding wizard will start on first run.

## Commands

| Command | Description |
|---------|-------------|
| `gmt` | Show home screen |
| `gmt add "task"` | Add a task |
| `gmt done <N>` | Toggle task completion |
| `gmt rm <N>` | Remove a task |
| `gmt goal "goal"` | Set today's goal |
| `gmt go <N>` | Jump to a recent project |
| `gmt list` | Show task list only |
| `gmt clear` | Remove all completed tasks |
| `gmt config` | Edit settings |
| `gmt setup` | Re-run onboarding wizard |
| `gmt help` | Show help |
| `gmt version` | Show version |

## Configuration

Edit `~/.gmt/config.sh` directly or run `gmt config`.

```bash
GMT_USERNAME=""              # Leave empty to use $USER
GMT_LANG="auto"              # auto | ko | en | ja | zh
GMT_WEATHER_ENABLED=true     # Show weather
GMT_WEATHER_CITY="Seoul"     # City name for wttr.in
GMT_WEATHER_CACHE_TTL=1800   # Weather cache TTL in seconds
GMT_MODULES="greeting projects sysinfo todos activity"
GMT_PROJECTS_COUNT=5         # Number of recent projects to show
GMT_ACTIVITY_WEEKS=12        # Weeks to show in heatmap
```

### Reordering Modules

Change `GMT_MODULES` to reorder or hide modules:

```bash
# Show todos first
GMT_MODULES="todos greeting projects"

# Hide system info
GMT_MODULES="greeting projects todos activity"
```

## i18n

GMT supports multiple languages. Currently bundled:

| Language | File | Status |
|----------|------|--------|
| English | `lang/en.sh` | Built-in |
| Korean | `lang/ko.sh` | Built-in |
| Japanese | `lang/ja.sh` | Community |
| Chinese | `lang/zh.sh` | Community |

### Adding a Language

1. Copy `lang/en.sh` to `lang/{code}.sh`
2. Translate all `L_` variables
3. Submit a PR

```bash
cp ~/.gmt/lang/en.sh ~/.gmt/lang/fr.sh
# Edit fr.sh with your translations
```

All user-facing strings are managed via `L_` variables. Command names (`gmt add`, etc.) are not translated.

## Project Structure

```
~/.gmt/
├── gmt.sh              # Main entry point (sourced by shell rc)
├── config.sh           # User configuration
├── install.sh          # Installer script
├── modules/
│   ├── onboarding.sh   # First-run setup wizard
│   ├── greeting.sh     # Greeting + time + weather
│   ├── projects.sh     # Recent projects & quick jump
│   ├── sysinfo.sh      # System info (git, node, python)
│   ├── todos.sh        # To-do list & daily goal
│   └── activity.sh     # Activity heatmap
├── lang/
│   ├── ko.sh           # Korean
│   └── en.sh           # English
├── lib/
│   ├── colors.sh       # ANSI color utilities
│   ├── layout.sh       # Box drawing & alignment
│   ├── cache.sh        # TTL-based file cache
│   └── compat.sh       # Cross-platform wrappers
├── data/               # User data (auto-generated)
│   ├── todos.txt
│   ├── goal.txt
│   ├── activity.log
│   └── projects.log
└── cache/              # Cached data (auto-generated)
```

## Performance

Designed for **under 100ms** perceived startup time.

- All external calls (weather API, version checks) are cached
- Cache misses trigger background refresh — never blocks rendering
- Minimal subshells and pipes; prefers bash builtins
- Heatmap rendering is cached and only regenerated when activity.log changes

## Cross-Platform

Supports both macOS and Linux. BSD/GNU differences are handled automatically in `lib/compat.sh`.

| Feature | macOS | Linux |
|---------|-------|-------|
| File mtime | `stat -f %m` | `stat -c %Y` |
| sed in-place | `sed -i ''` | `sed -i` |
| Reverse file | `tail -r` | `tac` |

## Uninstall

```bash
# Remove source line from shell rc
# zsh:
sed -i '' '/gmt\.sh/d' ~/.zshrc

# bash:
sed -i '/gmt\.sh/d' ~/.bashrc

# Remove GMT directory
rm -rf ~/.gmt
```

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

- **Add a language** — Translate `lang/en.sh` into your language
- **New modules** — Create a `modules/your_module.sh` with a `_gmt_yourmodule_render` function
- **Bug reports** — Open an issue with your OS, shell version, and `gmt version` output
- **Ideas** — Feature requests are welcome in Issues

### Development

```bash
# Clone to a test directory (not ~/.gmt)
git clone https://github.com/coldpak/gmt.git ~/gmt-dev
cd ~/gmt-dev

# Test without affecting your real installation
GMT_DIR="$(pwd)" bash -c 'source gmt.sh'
```

## Inspiration

- [wtfutil/wtf](https://github.com/wtfutil/wtf) — Terminal dashboard (Go)
- [dylanaraps/neofetch](https://github.com/dylanaraps/neofetch) — System info tool
- GitHub contribution graph

## License

[MIT](LICENSE) © 2026 Good Morning Terminal Contributors

---

<p align="center">
  Made with shell scripts and morning coffee.<br>
  <sub>If GMT brightens your terminal, consider giving it a star!</sub>
</p>
