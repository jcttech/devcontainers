#!/bin/bash
# Start Podman's Docker-compatible socket at /var/run/docker.sock
# Run as root (via sudo) so the socket is at the conventional path.

set -euo pipefail

SOCKET_PATH="/var/run/docker.sock"

# Start podman system service in the background
podman system service --time=0 "unix://${SOCKET_PATH}" &

# Wait briefly for socket to appear
for i in $(seq 1 10); do
    [ -S "${SOCKET_PATH}" ] && break
    sleep 0.5
done

# Allow the vscode user to access the socket
chmod 666 "${SOCKET_PATH}"
