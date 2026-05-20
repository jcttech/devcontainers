#!/usr/bin/env bash
# Seed the csm-plugin into the user's ~/.claude/plugins/csm/ directory.
#
# The plugin directory lives inside the `claude-config-shared` volume, so
# anything baked into the image at /home/vscode/.claude is hidden once the
# volume is mounted. This script runs from postStartCommand on every
# container start and force-copies the frozen artifacts from
# /etc/csm-plugin/ into the volume so image-version bumps propagate.
set -euo pipefail

PLUGIN_HOME="${HOME}/.claude/plugins/csm"
mkdir -p "${PLUGIN_HOME}/bin" "${PLUGIN_HOME}/.claude-plugin"

install -m 0755 /etc/csm-plugin/team "${PLUGIN_HOME}/bin/team"
install -m 0644 /etc/csm-plugin/plugin.json "${PLUGIN_HOME}/.claude-plugin/plugin.json"
