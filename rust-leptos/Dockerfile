# Rust + Leptos devcontainer - extends rust
#
# Bakes in the WASM toolchain (wasm32 target, cargo-leptos, wasm-bindgen-cli,
# wasm-opt) plus postgresql-client + jq so downstream CI runners and
# devcontainers don't reinstall on every cold start. See jcttech/trading
# Spec #185 for the rationale.
#
# Bumping the WASM toolchain: bump the WASM_BINDGEN_VERSION / BINARYEN_VERSION
# ARGs below, merge, :latest republishes to GHCR. Downstream consumers pick up
# the new versions on next pull.
ARG REGISTRY=ghcr.io
ARG NAMESPACE=jcttech
ARG BASE_VERSION=latest

FROM ${REGISTRY}/${NAMESPACE}/devcontainer-rust:${BASE_VERSION}

USER root

# Postgres client + jq for projects with database-test or schema-survey CI.
# (jq is already installed in the base image but listed explicitly here so a
# future base-image change doesn't silently regress the rust-leptos contract.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    jq \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER vscode

# wasm32 target (Leptos hydrate-side compile).
RUN rustup target add wasm32-unknown-unknown

# cargo-leptos — orchestrates SSR + hydrate halves.
# LEPTOS_VERSION is the leptos *crate* version, exposed as an env var for
# project scaffolding; CARGO_LEPTOS_VERSION pins the CLI, which versions
# independently of the framework.
ARG LEPTOS_VERSION=0.8.19
ARG CARGO_LEPTOS_VERSION=0.3.7
ENV LEPTOS_VERSION=${LEPTOS_VERSION}
RUN cargo install cargo-leptos --version "${CARGO_LEPTOS_VERSION}" --locked

# wasm-bindgen-cli pinned to match the workspace wasm-bindgen pin
# (cargo-leptos refuses to build on a mismatch). Bump in lockstep with the
# downstream Cargo.toml pins.
ARG WASM_BINDGEN_VERSION=0.2.108
RUN cargo install wasm-bindgen-cli --version "${WASM_BINDGEN_VERSION}" --locked --force

# wasm-opt (binaryen) — strongest size-optimisation pass for the WASM bundle.
# Multi-arch download branches on dpkg --print-architecture so the same
# Dockerfile works for amd64 (ARC runners) and arm64 (Apple Silicon).
USER root
ARG BINARYEN_VERSION=version_119
RUN ARCH=$(dpkg --print-architecture) && \
    case ${ARCH} in \
        amd64) BINARYEN_ARCH="x86_64-linux" ;; \
        arm64) BINARYEN_ARCH="aarch64-linux" ;; \
        *) echo "Unsupported architecture: ${ARCH}" >&2; exit 1 ;; \
    esac && \
    curl -sSL "https://github.com/WebAssembly/binaryen/releases/download/${BINARYEN_VERSION}/binaryen-${BINARYEN_VERSION}-${BINARYEN_ARCH}.tar.gz" \
      | tar -xz -C /tmp && \
    cp "/tmp/binaryen-${BINARYEN_VERSION}/bin/wasm-opt" /usr/local/bin/ && \
    cp -r "/tmp/binaryen-${BINARYEN_VERSION}/lib/." /usr/local/lib/ 2>/dev/null || true && \
    rm -rf "/tmp/binaryen-${BINARYEN_VERSION}"

USER vscode

# VS Code extensions for Rust + Leptos / WASM work (inherits the rust-image
# extensions list and adds web-stack helpers).
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
                "rust-lang.rust-analyzer", \
                "bradlc.vscode-tailwindcss", \
                "leptos-community.leptos" \
            ] \
        } \
    } \
}'

# ── Chrome for Testing + matched chromedriver (browser e2e) ────────────────
# jcttech/trading Story #310: the web-e2e CI job downloaded Chrome + a
# version-matched chromedriver from dl.google.com / the CfT CDN on EVERY
# cold ARC pod (~1–2 min per run) — and those fetches were an observed
# network-flake surface (2 of 4 infra failures on 2026-07-04). Baking a
# PINNED CfT pair keeps browser + driver matched by construction and
# removes both the setup time and the egress dependency.
#
# CfT publishes linux binaries for x86_64 only — arm64 images (Apple
# Silicon local dev) skip the bake and fall back to the consumer's own
# install path (jcttech/trading scripts/install-chromedriver.sh or the
# workflow's guarded install step).
#
# Bumping Chrome: bump CHROME_VERSION to any version listed in
# https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json
# — chrome and chromedriver ship from the same version directory, so they
# can never skew.
USER root
ARG CHROME_VERSION=150.0.7871.46
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "${ARCH}" != "amd64" ]; then \
        echo "Chrome for Testing: no linux-${ARCH} builds published — skipping bake"; \
    else \
        apt-get update && apt-get install -y --no-install-recommends \
            ca-certificates fonts-liberation libasound2 libatk-bridge2.0-0 \
            libatk1.0-0 libatspi2.0-0 libcairo2 libcups2 libdbus-1-3 \
            libdrm2 libgbm1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 \
            libpango-1.0-0 libx11-6 libxcb1 libxcomposite1 libxdamage1 \
            libxext6 libxfixes3 libxkbcommon0 libxrandr2 unzip xdg-utils \
        && apt-get clean && rm -rf /var/lib/apt/lists/* && \
        CDN="https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64" && \
        curl -fsSL --retry 5 --retry-all-errors "${CDN}/chrome-linux64.zip" -o /tmp/chrome.zip && \
        curl -fsSL --retry 5 --retry-all-errors "${CDN}/chromedriver-linux64.zip" -o /tmp/chromedriver.zip && \
        mkdir -p /opt/chrome-for-testing && \
        unzip -q /tmp/chrome.zip -d /opt/chrome-for-testing && \
        unzip -q -j /tmp/chromedriver.zip '*/chromedriver' -d /opt/chrome-for-testing && \
        ln -sf /opt/chrome-for-testing/chrome-linux64/chrome /usr/local/bin/google-chrome && \
        ln -sf /opt/chrome-for-testing/chromedriver /usr/local/bin/chromedriver && \
        rm -f /tmp/chrome.zip /tmp/chromedriver.zip && \
        google-chrome --version && chromedriver --version; \
    fi
USER vscode
