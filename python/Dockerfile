# Python devcontainer - extends base
ARG REGISTRY=ghcr.io
ARG NAMESPACE=jcttech
ARG BASE_VERSION=latest

FROM ${REGISTRY}/${NAMESPACE}/devcontainer-base:${BASE_VERSION}

USER root

# Install Python 3.12
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.12 \
    python3.12-venv \
    python3.12-dev \
    python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3.12 /usr/bin/python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python

# Install uv for vscode user
USER vscode
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/vscode/.local/bin:${PATH}"

# Common Python dev tools
RUN uv tool install ruff && \
    uv tool install pytest && \
    uv tool install ipython

# VS Code extensions for Python
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
