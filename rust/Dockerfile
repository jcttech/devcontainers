# Rust devcontainer - extends base
ARG REGISTRY=ghcr.io
ARG NAMESPACE=jcttech
ARG BASE_VERSION=latest

FROM ${REGISTRY}/${NAMESPACE}/devcontainer-base:${BASE_VERSION}

USER root

# Install build essentials for Rust.
#
# `mold` is the modern memory-efficient linker — typically 2-5× less
# peak memory than GNU `ld` for large Rust binaries (workspaces with
# many rlibs / utoipa-gen / proc-macro-heavy graphs). Projects opt in
# via their own `.cargo/config.toml` (`rustflags = ["-C",
# "link-arg=-fuse-ld=mold"]` plus `linker = "clang"`) — `clang` is
# included via `libclang-dev`'s transitive deps but the link path
# fall-back to `cc` works on `gcc` 12+ as well. Added for jcttech/trading
# Bug #201 ARC OOM mitigation; benefits any rust consumer that hits
# memory pressure during release-build linking.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libssl-dev \
    protobuf-compiler \
    libclang-dev \
    mold \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Rust for vscode user
USER vscode
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/vscode/.cargo/bin:${PATH}"

RUN . "$HOME/.cargo/env" && \
    rustup component add rustfmt clippy && \
    cargo install cargo-watch cargo-edit

# Install sccache for shared compilation caching
USER root
ARG SCCACHE_VERSION=0.13.0
RUN ARCH=$(dpkg --print-architecture) && \
    case ${ARCH} in \
        amd64) SCCACHE_ARCH="x86_64-unknown-linux-musl" ;; \
        arm64) SCCACHE_ARCH="aarch64-unknown-linux-musl" ;; \
    esac && \
    wget "https://github.com/mozilla/sccache/releases/download/v${SCCACHE_VERSION}/sccache-v${SCCACHE_VERSION}-${SCCACHE_ARCH}.tar.gz" && \
    tar xzf "sccache-v${SCCACHE_VERSION}-${SCCACHE_ARCH}.tar.gz" && \
    mv "sccache-v${SCCACHE_VERSION}-${SCCACHE_ARCH}/sccache" /usr/local/bin/sccache && \
    chmod +x /usr/local/bin/sccache && \
    rm -rf "sccache-v${SCCACHE_VERSION}-${SCCACHE_ARCH}" "sccache-v${SCCACHE_VERSION}-${SCCACHE_ARCH}.tar.gz"
USER vscode

ENV RUSTC_WRAPPER="/usr/local/bin/sccache"
ENV SCCACHE_DIR="/home/vscode/.sccache"
ENV SCCACHE_CACHE_SIZE="5G"

# VS Code extensions for Rust (Python extensions inherited from base)
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
                "tamasfe.even-better-toml", \
                "rust-lang.rust-analyzer" \
            ] \
        } \
    } \
}'
