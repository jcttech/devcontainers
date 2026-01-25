# Devcontainers

Pre-built devcontainer images with Claude Code CLI, common development tools, and language-specific toolchains.

## Images

| Image | Description |
|-------|-------------|
| `ghcr.io/jcttech/devcontainer-base` | Claude Code CLI + common tools (zsh, fzf, git-delta, gh) |
| `ghcr.io/jcttech/devcontainer-python` | Base + Python 3.12 + uv |
| `ghcr.io/jcttech/devcontainer-rust` | Base + Rust toolchain |
| `ghcr.io/jcttech/devcontainer-python-rust` | Python + Rust combined |

## Usage

### 1. Copy a template to your project

```bash
cp -r ~/jcttech/devcontainers/templates/python .devcontainer
```

### 2. Update the namespace in `.devcontainer/devcontainer.json`

```json
"image": "ghcr.io/jcttech/devcontainer-python:latest",
```

### 3. Open in VS Code

- Open the project folder
- Click "Reopen in Container" when prompted
- Or: Command Palette → "Dev Containers: Reopen in Container"

### CLI usage

```bash
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . zsh
```

## Versioning

Pin to a specific version instead of `latest` for stability:

```json
"image": "ghcr.io/jcttech/devcontainer-python:v1.0",
```

Available tags:
- `latest` - Most recent build
- `v1.0`, `v1.1`, etc. - Specific releases

## Building Images

### Automatic (GitHub Actions)

Images are built and pushed automatically:
- **On push to main** → tagged as `latest`
- **On version tag** → tagged with version (e.g., `v1.0`)

To release a new version:
```bash
git tag v1.0
git push origin v1.0
```

### Manual (local)

```bash
# Build all images locally
NAMESPACE=jcttech VERSION=v1.0 ./build.sh

# Push to GitHub Container Registry
docker push ghcr.io/jcttech/devcontainer-base --all-tags
docker push ghcr.io/jcttech/devcontainer-python --all-tags
docker push ghcr.io/jcttech/devcontainer-rust --all-tags
docker push ghcr.io/jcttech/devcontainer-python-rust --all-tags
```

## Image Hierarchy

```
base (Claude Code + tools)
├── python (+ Python 3.12 + uv)
│   └── python-rust (+ Rust)
└── rust (+ Rust)
```

## What's Included

### Base Image
- Claude Code CLI
- zsh with powerlevel10k
- fzf, git-delta, gh CLI
- nano, vim, jq
- Network firewall (restricts to allowed domains)

### Python Image
- Python 3.12
- uv (fast package manager)
- ruff, pytest, ipython

### Rust Image
- Rust toolchain (rustup)
- rustfmt, clippy
- cargo-watch, cargo-edit

## Network Firewall

The images include a firewall that restricts network access to:
- GitHub (api, web, git)
- PyPI (pypi.org, files.pythonhosted.org)
- crates.io
- npm registry
- Anthropic API
- VS Code marketplace

Run manually if needed:
```bash
sudo /usr/local/bin/init-firewall.sh
```

## Environment Variables

The templates pass through `ANTHROPIC_API_KEY` from your host. Set it in your shell:

```bash
export ANTHROPIC_API_KEY="your-key"
```

## Persisted Volumes

The templates configure volumes for:
- `~/.claude` - Claude Code configuration
- `/commandhistory` - Shell history
- `~/.cargo/registry` - Cargo cache (Rust images)
