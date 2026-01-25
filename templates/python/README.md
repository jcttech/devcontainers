# Python Development Container Template

A specialized development container for Python projects.

## Features

- **Python**: Configurable version (default: 3.11)
- **Node.js**: Required for Claude Code
- **Claude Code**: AI-powered coding assistant
- **Python Tools**: Black, Pylint, Pytest, IPython, virtualenv
- **Auto-install**: Runs `pip install --user -r requirements.txt` if present
- **VS Code Extensions**: Python, Pylance, Black Formatter, GitLens, and Claude Code
- **Network Firewall**: Secure development environment
- **Zsh with Oh My Zsh**: Modern shell with Python and pip plugins

## Usage

1. Copy this template to your project:
   ```bash
   cp -r /path/to/devcontainers/templates/python/.devcontainer /path/to/your/project/
   ```

2. Create a `requirements.txt` file in your project root (optional)

3. Open your project in VS Code and select "Reopen in Container"

4. The container will automatically install dependencies from `requirements.txt`

## Build Arguments

Customize the Python version in `devcontainer.json`:

```json
"args": {
  "PYTHON_VERSION": "3.11"
}
```

Available versions: 3.8, 3.9, 3.10, 3.11, 3.12, etc.

## Pre-installed Tools

- `black`: Code formatter
- `pylint`: Linter
- `pytest`: Testing framework
- `ipython`: Enhanced Python REPL
- `virtualenv`: Virtual environment management

## Recommended Project Structure

```
your-project/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   └── init-firewall.sh
├── requirements.txt
├── src/
│   └── your_module/
└── tests/
```

## Environment Variables

- `PYTHONUNBUFFERED`: Set to `1` for immediate output
- `DEVCONTAINER`: Set to `true` for environment detection

## User Configuration

The container runs as the `developer` user (UID 1000). Python packages installed with `--user` flag are stored in the user's home directory.

## Security

The firewall restricts outbound connections. PyPI access is configured through the allowed domains.
