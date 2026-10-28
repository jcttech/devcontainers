# Rust + Leptos devcontainer - extends rust
#
# Bakes in the WASM toolchain (wasm32 target, cargo-leptos, wasm-bindgen-cli,
# wasm-opt) plus postgresql-client + jq so downstream CI runners and
# devcontainers don't reinstall on every cold start. See jcttech/trading
# Spec #185 for the rationale.
#
# Bumping a pinned tool: change its ARG default below (WASM_BINDGEN_VERSION,
# BINARYEN_VERSION, CHROME_VERSION, CARGO_LEPTOS_VERSION / LEPTOS_VERSION --
# the last two also have workflow defaults in .github/workflows/build.yml that
# must move with them). The build smoke test reads WASM_BINDGEN_VERSION,
# BINARYEN_VERSION and CHROME_VERSION from this file, so it cannot drift.
#
# Merging publishes NOTHING: build.yml pushes images only on an X.Y.Z tag push
# or a manual dispatch (a pull request builds and smoke-tests without pushing).
# Every publish re-tags :latest for base, rust and rust-leptos at once, so time
# a tag for when the downstream pins are ready -- e.g. jcttech/trading pins
# the wasm-bindgen crate to exactly WASM_BINDGEN_VERSION, and cargo-leptos
# uses the wasm-bindgen on PATH whatever its version, so a :latest with a new
# CLI breaks its web build until its pin PR merges (tag, then that PR).
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
ARG LEPTOS_VERSION=0.8.22
ARG CARGO_LEPTOS_VERSION=0.3.11
ENV LEPTOS_VERSION=${LEPTOS_VERSION}
RUN cargo install cargo-leptos --version "${CARGO_LEPTOS_VERSION}" --locked

# wasm-bindgen-cli pinned to match the workspace wasm-bindgen pin: the CLI
# refuses a module built against a different wasm-bindgen schema, and
# cargo-leptos runs whichever wasm-bindgen is on PATH. Bump in lockstep with
# the downstream Cargo.toml pins (jcttech/trading: image tag first, then the
# pin PR). 0.2.129: jcttech/trading Story #751 (eframe 0.37 needs >= 0.2.126).
ARG WASM_BINDGEN_VERSION=0.2.129
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
# Bumping Chrome: set CHROME_VERSION to the current Stable from
# https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json
# (any entry of known-good-versions-with-downloads.json works too) -- chrome
# and chromedriver ship from the same version directory, so they can never
# skew. Compare the zip's chrome-linux64/deb.deps against the runtime libs
# below, and keep the libs' Debian names in step with the base image (trixie
# names the t64 transition's packages *t64). The build smoke test checks both
# versions against this ARG and loads a page headless.
USER root
ARG CHROME_VERSION=156.0.8078.73
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "${ARCH}" != "amd64" ]; then \
        echo "Chrome for Testing: no linux-${ARCH} builds published — skipping bake"; \
    else \
        apt-get update && apt-get install -y --no-install-recommends \
            ca-certificates fonts-liberation libasound2t64 \
            libatk-bridge2.0-0t64 libatk1.0-0t64 libatspi2.0-0t64 libcairo2 \
            libcups2t64 libdbus-1-3 libdrm2 libexpat1 libgbm1 \
            libglib2.0-0t64 libgtk-3-0t64 libnspr4 libnss3 libpango-1.0-0 \
            libudev1 libx11-6 libxcb1 libxcomposite1 libxdamage1 libxext6 \
            libxfixes3 libxkbcommon0 libxrandr2 unzip xdg-utils \
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
