# Devcontainer Templates

This repository contains a collection of default devcontainer templates with all the tooling required for development. These templates are based on the [Claude devcontainer](https://github.com/anthropics/claude-code/tree/main/.devcontainer) and include security features, development tools, and best practices.

## Available Templates

### Base Template
- **Location**: `templates/base/`
- **Description**: A general-purpose development container based on Node.js with Claude Code integration
- **Features**:
  - Node.js 20
  - Claude Code AI assistant
  - Git with Delta for better diffs
  - Zsh with Oh My Zsh and Powerline10k theme
  - Network firewall for security
  - VS Code extensions (ESLint, Prettier, GitLens)

### Node.js Template
- **Location**: `templates/node/`
- **Description**: Specialized template for Node.js/TypeScript development
- **Features**:
  - All base template features
  - TypeScript, ts-node, and nodemon pre-installed
  - ESLint and Prettier configuration
  - Automatic npm install on container creation
  - TypeScript VS Code extension

### Python Template
- **Location**: `templates/python/`
- **Description**: Template for Python development
- **Features**:
  - Python 3.11 (configurable)
  - Node.js for Claude Code
  - Black formatter, Pylint, and Pytest
  - IPython and virtualenv
  - Python VS Code extensions (Python, Pylance, Black Formatter)
  - Automatic requirements.txt installation

### Go Template
- **Location**: `templates/go/`
- **Description**: Template for Go development
- **Features**:
  - Go 1.21 (configurable)
  - Node.js for Claude Code
  - Go development tools (gopls, delve, goimports, golangci-lint)
  - Go VS Code extension
  - Automatic go mod download on container creation

## Usage

### Quick Setup (Recommended)

Use the provided setup script for easy installation:

```bash
# Clone this repository
git clone https://github.com/jcttech/devcontainers.git

# Run the setup script
./devcontainers/setup.sh /path/to/your/project

# Follow the prompts to select a template
```

The script will:
- List available templates
- Copy the selected template to your project
- Provide next steps

### Manual Setup

1. Copy the template directory to your project's `.devcontainer` folder:
   ```bash
   cp -r templates/node/.devcontainer /path/to/your/project/
   ```

2. Customize the configuration:
   - Edit `devcontainer.json` to adjust settings
   - Modify `Dockerfile` to add additional tools
   - Update build args for version changes

3. Open your project in VS Code and select "Reopen in Container"

### Customization

Each template can be customized by modifying the build arguments in `devcontainer.json`:

**Base/Node Template:**
```json
"args": {
  "TZ": "${localEnv:TZ:America/Los_Angeles}",
  "CLAUDE_CODE_VERSION": "latest",
  "NODE_VERSION": "20"
}
```

**Python Template:**
```json
"args": {
  "PYTHON_VERSION": "3.11"
}
```

**Go Template:**
```json
"args": {
  "GO_VERSION": "1.21"
}
```

## Security Features

All templates include a network firewall (`init-firewall.sh`) that:
- Restricts outbound network access to approved domains
- Allows access to GitHub, npm, Anthropic API, and VS Code marketplace
- Blocks access to other external sites by default
- Can be customized to add additional allowed domains

To add additional allowed domains, edit the `init-firewall.sh` script in your template.

## Common Features

All templates include:
- **Claude Code**: AI-powered coding assistant
- **Git Delta**: Enhanced git diff viewer
- **Zsh with Oh My Zsh**: Modern shell with plugins
- **History persistence**: Command history persists across container rebuilds
- **VS Code integration**: Pre-configured extensions and settings
- **Non-root user**: Containers run as non-root for security

## Requirements

- Docker Desktop or Docker Engine
- Visual Studio Code with Remote - Containers extension
- Sufficient disk space for Docker images

## Additional Resources

- **[Template Selection Guide](TEMPLATE_GUIDE.md)**: Help choosing the right template for your project
- **[Examples](EXAMPLES.md)**: Practical examples of using each template
- **Template READMEs**: Each template has its own README with specific details

## Contributing

To add a new template:
1. Create a new directory under `templates/`
2. Include `devcontainer.json`, `Dockerfile`, and `init-firewall.sh`
3. Add documentation in a README.md file
4. Update this main README with template information

## License

These templates are provided as-is for development purposes.
