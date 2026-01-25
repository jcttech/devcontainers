# Rust devcontainer - extends base
ARG REGISTRY=ghcr.io
ARG NAMESPACE=jcttech
ARG BASE_VERSION=latest

FROM ${REGISTRY}/${NAMESPACE}/devcontainer-base:${BASE_VERSION}

USER root

# Install build essentials for Rust
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libssl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Rust for vscode user
USER vscode
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/vscode/.cargo/bin:${PATH}"

RUN . "$HOME/.cargo/env" && \
    rustup component add rustfmt clippy && \
    cargo install cargo-watch cargo-edit

# VS Code extensions for Rust
LABEL devcontainer.metadata='{ \
    "customizations": { \
        "vscode": { \
            "extensions": [ \
                "anthropic.claude-code", \
                "eamodio.gitlens", \
                "fill-labs.dependi", \
                "tamasfe.even-better-toml", \
                "rust-lang.rust-analyzer" \
            ] \
        } \
    } \
}'
