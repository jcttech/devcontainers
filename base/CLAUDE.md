# Claude Code Network Access

## Web Search

Web search works normally - use it freely for research.

## Network Access (Package Installs, Git, etc.)

Direct network access (pip, npm, git clone) is blocked by default.
When you get a connection error (timeout, connection refused, etc.):

1. Output a network request on its own line:
   ```
   [NETWORK_REQUEST: domain.com]
   ```

2. Wait for the response:
   - `[NETWORK_APPROVED: domain.com]` → retry your command
   - `[NETWORK_DENIED: domain.com]` → find alternative approach

Example:
```
$ pip install pytest
ERROR: Could not connect to pypi.org

[NETWORK_REQUEST: pypi.org]

[NETWORK_APPROVED: pypi.org]

$ pip install pytest
Successfully installed pytest-8.0.0
```

Common domains you may need to request:
- pypi.org, files.pythonhosted.org - pip
- registry.npmjs.org - npm
- github.com, objects.githubusercontent.com - git
- crates.io - cargo
