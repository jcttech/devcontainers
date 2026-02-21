FROM mcr.microsoft.com/devcontainers/base:trixie

ARG TZ
ENV TZ="$TZ"

ARG CLAUDE_CODE_VERSION=latest
ARG GH_VERSION=2.86.0
ARG GIT_DELTA_VERSION=0.18.2
ARG ZSH_IN_DOCKER_VERSION=1.2.0

# Install basic development tools and Python
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
    jq \
    nano \
    vim \
    curl \
    wget \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Podman and Docker compatibility tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    podman \
    podman-docker \
    uidmap \
    slirp4netns \
    fuse-overlayfs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI from official release
RUN ARCH=$(dpkg --print-architecture) && \
    wget "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${ARCH}.deb" && \
    dpkg -i "gh_${GH_VERSION}_linux_${ARCH}.deb" && \
    rm "gh_${GH_VERSION}_linux_${ARCH}.deb"

# Install agent worker and gRPC dependencies for claude-session-manager
ARG AGENT_WORKER_VERSION=2.0.0
RUN pip install --break-system-packages \
    grpcio>=1.60.0 \
    protobuf>=4.25.0 \
    https://github.com/jcttech/claude-session-manager/releases/download/agent-worker/v${AGENT_WORKER_VERSION}/agent_worker-${AGENT_WORKER_VERSION}-py3-none-any.whl

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

# Copy Claude network access instructions
COPY CLAUDE.md /CLAUDE.md

# Install Podman socket startup script
COPY start-podman-socket.sh /usr/local/bin/start-podman-socket.sh
RUN chmod +x /usr/local/bin/start-podman-socket.sh
ENV DOCKER_HOST=unix:///var/run/docker.sock

# Set default shell to zsh
ENV SHELL=/bin/zsh
ENV EDITOR=nano
ENV VISUAL=nano

# VS Code extensions
EXPOSE 50051

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
    }, \
    "postStartCommand": "sudo /usr/local/bin/start-podman-socket.sh && python3 -m agent_worker --port 50051 &" \
}'

USER ${USERNAME}
