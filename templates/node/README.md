# Node.js Development Container Template

A specialized development container for Node.js and TypeScript projects.

## Features

- **Node.js**: Configurable version (default: 20)
- **TypeScript**: Full TypeScript support with ts-node and nodemon
- **Claude Code**: AI-powered coding assistant
- **Auto-install**: Runs `npm install` on container creation
- **VS Code Extensions**: ESLint, Prettier, GitLens, TypeScript, and Claude Code
- **Network Firewall**: Secure development environment
- **Zsh with Oh My Zsh**: Modern shell with npm plugin

## Usage

1. Copy this template to your project:
   ```bash
   cp -r /path/to/devcontainers/templates/node/.devcontainer /path/to/your/project/
   ```

2. Open your project in VS Code and select "Reopen in Container"

3. The container will automatically run `npm install` on first creation

## Build Arguments

Customize the Node.js version in `devcontainer.json`:

```json
"args": {
  "NODE_VERSION": "20"
}
```

Available versions: 18, 20, 21, etc.

## Pre-installed Global Tools

- `typescript`: TypeScript compiler
- `ts-node`: Execute TypeScript directly
- `nodemon`: Auto-restart on file changes
- `@anthropic-ai/claude-code`: Claude Code CLI

## Recommended Project Structure

```
your-project/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   └── init-firewall.sh
├── package.json
├── tsconfig.json
├── src/
└── tests/
```

## Environment Variables

- `NODE_OPTIONS`: Set to `--max-old-space-size=4096` for better performance
- `NPM_CONFIG_PREFIX`: Global npm packages location

## Security

The firewall restricts outbound connections. npm registry access is pre-configured.
