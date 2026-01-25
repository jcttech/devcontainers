# Build on top of the base image
ARG REGISTRY=ghcr.io
ARG NAMESPACE=jcttech
ARG BASE_VERSION=latest

FROM ${REGISTRY}/${NAMESPACE}/devcontainer-base:${BASE_VERSION}

USER root

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install common Rust tools
RUN . "$HOME/.cargo/env" && \
    rustup component add rustfmt clippy && \
    cargo install cargo-watch cargo-edit

# Also install Rust for the vscode user
USER vscode
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/vscode/.cargo/bin:${PATH}"

RUN . "$HOME/.cargo/env" && \
    rustup component add rustfmt clippy

# Additional VS Code extensions for Rust
LABEL devcontainer.metadata='{ \
    "customizations": { \
        "vscode": { \
            "extensions": [ \
                "anthropic.claude-code", \
                "ms-python.python", \
                "ms-python.vscode-pylance", \
                "charliermarsh.ruff", \
                "tamasfe.even-better-toml", \
                "eamodio.gitlens", \
                "rust-lang.rust-analyzer" \
            ] \
        } \
    } \
}'
