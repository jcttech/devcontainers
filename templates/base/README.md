# Base Development Container Template

A general-purpose development container with Node.js and Claude Code integration.

## Features

- **Node.js 20**: Latest LTS version of Node.js
- **Claude Code**: AI-powered coding assistant from Anthropic
- **Git with Delta**: Enhanced git diff viewer for better code review
- **Zsh with Oh My Zsh**: Modern shell with Powerline10k theme
- **Network Firewall**: Restricts outbound connections for security
- **Development Tools**: vim, nano, fzf, gh CLI, and more
- **VS Code Extensions**: ESLint, Prettier, GitLens, and Claude Code

## Usage

1. Copy this template to your project:
   ```bash
   cp -r /path/to/devcontainers/templates/base/.devcontainer /path/to/your/project/
   ```

2. Customize `devcontainer.json` as needed

3. Open your project in VS Code and select "Reopen in Container"

## Build Arguments

Customize the container by modifying build args in `devcontainer.json`:

- `TZ`: Timezone (default: America/Los_Angeles)
- `CLAUDE_CODE_VERSION`: Claude Code version (default: latest)
- `GIT_DELTA_VERSION`: Git Delta version (default: 0.18.2)
- `ZSH_IN_DOCKER_VERSION`: Zsh in Docker script version (default: 1.2.0)

## Network Security

The firewall script restricts outbound connections to:
- GitHub (web, api, git)
- npm registry
- Anthropic API
- Sentry.io
- Statsig
- VS Code marketplace

To add additional domains, edit `init-firewall.sh` and add to the domains list.

## User Configuration

The container runs as the `node` user (non-root) for security. Command history and Claude configuration are persisted in Docker volumes.

## Workspace

The workspace is mounted at `/workspace` with delegated consistency for better performance.
