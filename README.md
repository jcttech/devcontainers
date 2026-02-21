# Devcontainers

Pre-built devcontainer images with Claude Code CLI, common development tools, and language-specific toolchains.

## Images

| Image | Description |
|-------|-------------|
| `ghcr.io/jcttech/devcontainer-base` | Claude Code CLI + agent worker + common tools (zsh, fzf, git-delta, gh) |
| `ghcr.io/jcttech/devcontainer-python` | Base + Python 3.13 + uv |
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
"image": "ghcr.io/jcttech/devcontainer-python:1.0.0",
```

Available tags:
- `latest` - Most recent build
- `1.0.0`, `1.1.0`, etc. - Semver releases

## Building Images

### Automatic (GitHub Actions)

Images are built and pushed automatically:
- **On version tag** → tagged with version (e.g., `1.0.0`) + `latest`
- **Manual trigger** → optionally specify version, or defaults to `latest`

To release a new version:
```bash
git tag 1.0.0
git push origin 1.0.0
```

### Manual (local)

The base image requires a `GITHUB_TOKEN` to download the agent-worker package from the private `claude-session-manager` repo:

```bash
# Build all images locally
GITHUB_TOKEN=ghp_xxx NAMESPACE=jcttech VERSION=v1.0 ./build.sh

# Push to GitHub Container Registry
docker push ghcr.io/jcttech/devcontainer-base --all-tags
docker push ghcr.io/jcttech/devcontainer-python --all-tags
docker push ghcr.io/jcttech/devcontainer-rust --all-tags
docker push ghcr.io/jcttech/devcontainer-python-rust --all-tags
```

## Image Hierarchy

```
base (Debian Trixie + Claude Code + agent worker + tools)
├── python (+ Python 3.13 + uv)
│   └── python-rust (+ Rust)
└── rust (+ Rust)
```

## What's Included

### Base Image
- Debian Trixie (Python 3.13)
- Claude Code CLI
- Agent worker (gRPC service on port 50051 for claude-session-manager)
- zsh with powerlevel10k
- fzf, git-delta, gh CLI
- nano, vim, jq

### Python Image
- Python 3.13
- uv (fast package manager)
- ruff, pytest, ipython

### Rust Image
- Rust toolchain (rustup)
- rustfmt, clippy
- cargo-watch, cargo-edit

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
