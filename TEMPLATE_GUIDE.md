# Template Selection Guide

Use this guide to choose the right devcontainer template for your project.

## Quick Reference

| Template | Best For | Key Tools | Language Version |
|----------|----------|-----------|------------------|
| **Base** | General development, Node.js projects | Node.js, npm, Claude Code | Node 20 |
| **Node** | TypeScript/JavaScript projects | TypeScript, ts-node, nodemon | Node 20 (configurable) |
| **Python** | Python applications | Black, Pylint, Pytest, IPython | Python 3.11 (configurable) |
| **Go** | Go applications | gopls, delve, goimports, golangci-lint | Go 1.21 (configurable) |

## Decision Tree

```
Start here
    |
    ├─ Working with Python? ──> Use Python template
    |
    ├─ Working with Go? ──> Use Go template
    |
    ├─ Working with TypeScript/JavaScript?
    |   ├─ Need TypeScript tools? ──> Use Node template
    |   └─ Just need Node.js? ──> Use Base template
    |
    └─ General development? ──> Use Base template
```

## Template Comparison

### Base Template
- **Use when**: You need a general-purpose container or working with Node.js
- **Pros**: Lightweight, fast to build, includes essential tools
- **Cons**: No language-specific tooling beyond Node.js

### Node Template
- **Use when**: Building Node.js or TypeScript applications
- **Pros**: TypeScript support, auto npm install, nodemon for hot reload
- **Cons**: Slightly larger than base template
- **Best for**: Web apps, APIs, TypeScript libraries

### Python Template
- **Use when**: Building Python applications
- **Pros**: Python-specific linting and formatting, virtual environment support
- **Cons**: Requires Node.js for Claude Code (larger image)
- **Best for**: Python scripts, web apps (Django/Flask), data science, ML

### Go Template
- **Use when**: Building Go applications
- **Pros**: Full Go toolchain, debugger, linting, GOPATH persistence
- **Cons**: Requires Node.js for Claude Code
- **Best for**: Go microservices, CLI tools, APIs

## Mixing Languages

If you need multiple languages in one project:

1. **Start with the primary language template**
2. **Modify the Dockerfile** to add additional language support
3. **Update devcontainer.json** to add relevant VS Code extensions

Example: Adding Python to Node template:
```dockerfile
# Add to Dockerfile after apt-get install
RUN apt-get update && apt-get install -y python3 python3-pip
```

## Custom Requirements

All templates can be customized:
- Edit `Dockerfile` to add packages or tools
- Modify `devcontainer.json` for VS Code settings
- Update `init-firewall.sh` to allow additional domains
- Change build args for different versions

## Getting Started

1. Choose your template
2. Copy to your project: `cp -r templates/[name]/ /your/project/.devcontainer/`
3. Customize as needed
4. Open in VS Code and select "Reopen in Container"
