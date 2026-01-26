FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG TZ
ENV TZ="$TZ"

ARG CLAUDE_CODE_VERSION=latest
ARG GIT_DELTA_VERSION=0.18.2
ARG ZSH_IN_DOCKER_VERSION=1.2.0

# Install basic development tools, Python, and iptables/ipset
RUN apt-get update && apt-get install -y --no-install-recommends \
    less \
    git \
    procps \
    sudo \
    fzf \
    zsh \
    man-db \
    unzip \
    gnupg2 \
    gh \
    iptables \
    ipset \
    iproute2 \
    dnsutils \
    aggregate \
    jq \
    nano \
    vim \
    curl \
    wget \
    python3.12 \
    python3.12-venv \
    python3.12-dev \
    python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3.12 /usr/bin/python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python

# Install git-delta for better diffs
RUN ARCH=$(dpkg --print-architecture) && \
    wget "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
    dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
    rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

# Install Node.js (required for some Claude plugins like claude-mem)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Persist bash history
ARG USERNAME=vscode
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir -p /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $USERNAME /commandhistory

# Set `DEVCONTAINER` environment variable
ENV DEVCONTAINER=true

# Create workspace and config directories
RUN mkdir -p /workspaces /home/${USERNAME}/.claude/skills /etc/claude-code/.claude/skills && \
    chown -R ${USERNAME}:${USERNAME} /workspaces /home/${USERNAME}/.claude

WORKDIR /workspaces

# Set up zsh with powerlevel10k theme
USER ${USERNAME}
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v${ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
    -p git \
    -p fzf \
    -a "source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null || true" \
    -a "source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null || true" \
    -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    -a "[ -f ~/.claude/settings.json ] || cp /etc/claude/default-settings.json ~/.claude/settings.json >/dev/null 2>&1 || true" \
    -a "[ -L ~/.claude.json ] || ln -sf ~/.claude/mcp-config.json ~/.claude.json >/dev/null 2>&1 || true" \
    -a "[ -f ~/.claude/mcp-config.json ] || cp /etc/claude/default-mcp.json ~/.claude/mcp-config.json >/dev/null 2>&1 || true" \
    -x

# Install uv and Python dev tools
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"
RUN uv tool install ruff && \
    uv tool install pytest && \
    uv tool install ipython && \
    uv tool install specify-cli --from git+https://github.com/jayctran/spec-kit.git

# Install bun (required for claude-mem plugin)
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/home/${USERNAME}/.bun/bin:${PATH}"

# Install Claude Code CLI via native installer (as vscode user)
RUN curl -fsSL https://claude.ai/install.sh | bash -s -- ${CLAUDE_CODE_VERSION}
USER root
RUN ln -sf /home/${USERNAME}/.claude/local/claude /usr/local/bin/claude

# Add default Claude settings and MCP config
RUN mkdir -p /etc/claude && \
    cat > /etc/claude/default-settings.json << 'EOF'
{
  "permissions": {
    "allow": [
      "mcp__github__*"
    ]
  }
}
EOF
RUN cat > /etc/claude/default-mcp.json << 'EOF'
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    }
  }
}
EOF

# Set default shell to zsh
ENV SHELL=/bin/zsh
ENV EDITOR=nano
ENV VISUAL=nano

# Copy firewall script
COPY init-firewall.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-firewall.sh && \
    echo "${USERNAME} ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/${USERNAME}-firewall && \
    chmod 0440 /etc/sudoers.d/${USERNAME}-firewall

# VS Code extensions
LABEL devcontainer.metadata='{ \
    "customizations": { \
        "vscode": { \
            "extensions": [ \
                "anthropic.claude-code", \
                "eamodio.gitlens", \
                "fill-labs.dependi", \
                "ms-python.python", \
                "ms-python.vscode-pylance", \
                "charliermarsh.ruff", \
                "tamasfe.even-better-toml" \
            ] \
        } \
    } \
}'

USER ${USERNAME}
