# Examples: Using Devcontainer Templates

This document provides practical examples of using each template.

## Example 1: Node.js/TypeScript Web API

**Scenario**: You're building a REST API with Express and TypeScript

**Template**: Node

**Steps**:
```bash
# 1. Copy the template to your project
cp -r templates/node/.devcontainer /path/to/my-api/

# 2. Your project structure:
my-api/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   └── init-firewall.sh
├── src/
│   └── index.ts
├── package.json
└── tsconfig.json

# 3. Open in VS Code
code /path/to/my-api

# 4. Reopen in Container
# VS Code will build the container and run npm install automatically
```

**What you get**:
- TypeScript compiler and IntelliSense
- ESLint and Prettier configured
- Auto-restart with nodemon
- Claude Code for AI assistance

---

## Example 2: Python Data Science Project

**Scenario**: You're working on a machine learning project with scikit-learn

**Template**: Python

**Steps**:
```bash
# 1. Copy the template
cp -r templates/python/.devcontainer /path/to/ml-project/

# 2. Create requirements.txt
cd /path/to/ml-project
cat > requirements.txt << EOF
numpy
pandas
scikit-learn
matplotlib
jupyter
EOF

# 3. Your project structure:
ml-project/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   └── init-firewall.sh
├── data/
├── notebooks/
├── src/
├── requirements.txt
└── README.md

# 4. Open in VS Code
code /path/to/ml-project

# Container will automatically install requirements.txt
```

**What you get**:
- Python 3.11 with pip
- All packages from requirements.txt installed
- Jupyter, Pylint, Black pre-configured
- IPython for interactive development

---

## Example 3: Go Microservice

**Scenario**: You're building a microservice with Go and gRPC

**Template**: Go

**Steps**:
```bash
# 1. Copy the template
cp -r templates/go/.devcontainer /path/to/my-service/

# 2. Initialize your Go module
cd /path/to/my-service
cat > go.mod << EOF
module github.com/yourname/my-service

go 1.21
EOF

# 3. Your project structure:
my-service/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   └── init-firewall.sh
├── cmd/
│   └── server/
│       └── main.go
├── internal/
│   └── service/
├── pkg/
├── go.mod
└── go.sum

# 4. Open in VS Code
code /path/to/my-service

# Container will run go mod download automatically
```

**What you get**:
- Go 1.21 with modules enabled
- gopls for IntelliSense
- Delve debugger configured
- golangci-lint for code quality

---

## Example 4: Customizing a Template

**Scenario**: You need Python with additional database tools

**Template**: Python (customized)

**Steps**:
```bash
# 1. Copy the template
cp -r templates/python/.devcontainer /path/to/my-app/

# 2. Edit the Dockerfile to add PostgreSQL client
cd /path/to/my-app/.devcontainer
```

Edit `Dockerfile` and add after the apt-get install section:
```dockerfile
# Add PostgreSQL client and Redis CLI
RUN apt-get update && apt-get install -y \
  postgresql-client \
  redis-tools \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
```

Edit `requirements.txt`:
```
psycopg2-binary
redis
sqlalchemy
alembic
```

**What you get**:
- Python environment with database tools
- PostgreSQL and Redis clients for debugging
- All Python ORM tools installed

---

## Example 5: Multi-stage Development (Frontend + Backend)

**Scenario**: You have a monorepo with Node.js backend and React frontend

**Template**: Node (customized)

**Steps**:
```bash
# 1. Copy the template
cp -r templates/node/.devcontainer /path/to/monorepo/

# 2. Your project structure:
monorepo/
├── .devcontainer/
├── packages/
│   ├── backend/
│   │   ├── package.json
│   │   └── src/
│   └── frontend/
│       ├── package.json
│       └── src/
├── package.json (root)
└── turbo.json

# 3. Modify postCreateCommand in devcontainer.json
```

Edit `devcontainer.json`:
```json
"postCreateCommand": "npm install && npm run build",
```

**What you get**:
- Monorepo support with workspaces
- TypeScript for both frontend and backend
- Automatic installation of all workspace dependencies

---

## Example 6: Adding Custom Allowed Domains

**Scenario**: You need to access a private npm registry

**Template**: Any

**Steps**:
```bash
# 1. Copy your chosen template
cp -r templates/node/.devcontainer /path/to/my-project/

# 2. Edit init-firewall.sh
cd /path/to/my-project/.devcontainer
```

Edit `init-firewall.sh` and add your domain to the list:
```bash
# Find this section:
for domain in \
    "registry.npmjs.org" \
    "api.anthropic.com" \
    # ... other domains ...
    "your-private-registry.company.com"; do  # Add your domain here
```

**What you get**:
- Access to your private registry
- Maintained security with firewall
- All other template features

---

## Testing Your Template

After setting up your devcontainer:

1. **Verify the environment**:
   ```bash
   # Check installed tools
   node --version
   python --version
   go version
   
   # Check Claude Code
   claude --version
   ```

2. **Test the firewall**:
   ```bash
   # This should fail (blocked)
   curl https://example.com
   
   # This should work (allowed)
   curl https://api.github.com
   ```

3. **Test your development tools**:
   ```bash
   # Node: Run TypeScript
   npx ts-node src/index.ts
   
   # Python: Run tests
   pytest
   
   # Go: Run your app
   go run cmd/server/main.go
   ```

## Tips

- **Rebuild container**: If you modify Dockerfile or devcontainer.json, use "Rebuild Container" from VS Code
- **Clean start**: Delete volumes with `docker volume prune` for a fresh start
- **Performance**: Use `consistency=delegated` for faster file sync on Mac/Windows
- **Debugging**: Check container logs with `docker logs <container-id>`
