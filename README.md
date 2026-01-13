# git-colorblame

A git tool that displays `git blame` output with age-based heatmap coloring. Older commits appear in cold colors (purple/blue), newer commits in hot colors (yellow/orange).

![git-colorblame example](docs/colorblame.png)

## Features

- Plasma-inspired color gradient for modern terminals
- Pager support (uses your configured git pager or `less`)
- Pass-through support for git blame options like `-L`

## Requirements

- Python 3.10+
- Git
- Terminal with 24-bit (true color) support

## Installation

```bash
git clone <repo-url> git-colorblame
cd git-colorblame
./install.sh
```

This adds `git colorblame` as a global git alias.

## Usage

```bash
# Basic usage
git colorblame <file>

# Blame specific line range
git colorblame -L 10,50 <file>

# Disable pager (output directly)
git colorblame --no-pager <file>

# Disable colors (for piping)
git colorblame --no-color <file>

# Force light/dark background mode
git colorblame --light <file>
git colorblame --dark <file>

# Or set via environment variable
export COLORBLAME_BACKGROUND=light
```

## Color Scale

The heatmap represents commit age relative to the file's history:

| Age | Color |
|-----|-------|
| Uncommitted | **White** |
| Oldest | Purple |
| ↓ | Blue |
| ↓ | Teal |
| ↓ | Green |
| ↓ | Yellow |
| Newest | Orange |

Uncommitted changes (staged or unstaged) are highlighted in white (dark background) or dark gray (light background) to stand out from the age gradient.

## Configuration

Configure via git config:

```bash
# Set background mode permanently
git config --global colorblame.background light

# Disable pager by default
git config --global colorblame.pager false
```

| Config Key | Values | Description |
|------------|--------|-------------|
| `colorblame.background` | `light`, `dark` | Terminal background mode |
| `colorblame.pager` | `true`, `false` | Enable/disable pager |

**Background detection priority:**
1. `--light` / `--dark` flags
2. `COLORBLAME_BACKGROUND` environment variable
3. `colorblame.background` git config
4. `COLORFGBG` environment variable (set by some terminals)
5. Defaults to dark

## Pager

The pager is determined in this order:
1. `GIT_PAGER` environment variable
2. `git config core.pager`
3. `PAGER` environment variable
4. `less -R` (if available)

## Uninstall

```bash
git config --global --unset alias.colorblame
```

## License

MIT
