# Go Development Container Template

A specialized development container for Go projects.

## Features

- **Go**: Configurable version (default: 1.21)
- **Node.js**: Required for Claude Code
- **Claude Code**: AI-powered coding assistant
- **Go Tools**: gopls, delve, goimports, golangci-lint
- **Auto-download**: Runs `go mod download` on container creation
- **VS Code Extensions**: Go, GitLens, and Claude Code
- **Network Firewall**: Secure development environment
- **Zsh with Oh My Zsh**: Modern shell with Go plugin
- **GOPATH**: Persisted in Docker volume

## Usage

1. Copy this template to your project:
   ```bash
   cp -r /path/to/devcontainers/templates/go/.devcontainer /path/to/your/project/
   ```

2. Ensure your project has a `go.mod` file

3. Open your project in VS Code and select "Reopen in Container"

4. The container will automatically run `go mod download`

## Build Arguments

Customize the Go version in `devcontainer.json`:

```json
"args": {
  "GO_VERSION": "1.21"
}
```

Available versions: 1.20, 1.21, 1.22, etc.

## Pre-installed Tools

- `gopls`: Go language server
- `delve`: Go debugger
- `goimports`: Import management and formatting
- `golangci-lint`: Linter aggregator

## Recommended Project Structure

```
your-project/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   └── init-firewall.sh
├── go.mod
├── go.sum
├── main.go
├── cmd/
├── pkg/
└── internal/
```

## Environment Variables

- `GOPATH`: Set to `/go` (persisted in volume)
- `GO111MODULE`: Set to `on`
- `PATH`: Includes `/go/bin` for installed tools

## User Configuration

The container runs as the `developer` user (UID 1000). The GOPATH is shared via a Docker volume for persistence across rebuilds.

## VS Code Settings

The template includes Go-specific settings:
- `go.formatTool`: goimports
- `go.lintTool`: golangci-lint
- `go.useLanguageServer`: true (gopls)

## Security

The firewall restricts outbound connections. Access to Go module proxy (proxy.golang.org, sum.golang.org) is configured in the allowed domains.
