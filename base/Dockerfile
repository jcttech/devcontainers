FROM mcr.microsoft.com/devcontainers/python:3.12

ARG TZ
ENV TZ="$TZ"

ARG CLAUDE_CODE_VERSION=latest
ARG GIT_DELTA_VERSION=0.18.2
ARG ZSH_IN_DOCKER_VERSION=1.2.0

# Install basic development tools and iptables/ipset (from Claude Code official)
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
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install git-delta for better diffs
RUN ARCH=$(dpkg --print-architecture) && \
    wget "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
    dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
    rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

# Install uv (fast Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

# Install Node.js (required for Claude Code CLI)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
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
RUN mkdir -p /workspaces /home/${USERNAME}/.claude && \
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
    -x

# Install Claude Code CLI via npm (official method)
USER root
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}

# Common Python dev tools
RUN uv pip install --system \
    ruff \
    pytest \
    ipython

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
                "ms-python.python", \
                "ms-python.vscode-pylance", \
                "charliermarsh.ruff", \
                "tamasfe.even-better-toml", \
                "eamodio.gitlens" \
            ] \
        } \
    } \
}'

USER ${USERNAME}
