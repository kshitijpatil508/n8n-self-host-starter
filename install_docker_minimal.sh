#!/usr/bin/env bash
# install_docker_minimal.sh
# Minimal, cross-friendly installer/checker for Docker on Ubuntu/Debian systems.
# Usage:
#   chmod +x install_docker_minimal.sh
#   sudo ./install_docker_minimal.sh
#
# The script:
#  - checks if "docker" command exists
#  - if missing, installs Docker using the official convenience script
#  - enables & starts the docker service
#  - ensures the invoking (non-root) user is added to the "docker" group
#  - tests Docker with "hello-world"
#
# Notes:
#  - Run as root (sudo). The script will re-run itself with sudo if invoked as non-root.
#  - Review before running. Use on Ubuntu/Debian-based systems.

set -euo pipefail

REQUIRED_USER="${SUDO_USER:-$(whoami)}"

function echo_header {
  echo
  echo "======================================"
  echo "  n8n - minimal docker installer"
  echo "======================================"
  echo
}

if [ "$EUID" -ne 0 ]; then
  echo "Script requires sudo/root. Re-running with sudo..."
  exec sudo bash "$0" "$@"
fi

echo_header
echo "Invoking user: $REQUIRED_USER"
echo

# 1) Check if docker exists
if command -v docker >/dev/null 2>&1; then
  echo "Docker is already installed: $(docker --version)"
else
  echo "Docker not found. Installing Docker (official convenience script)..."
  # Download & run official script
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  rm -f get-docker.sh
  echo "Docker installation attempted."
fi

# 2) Enable & start docker service
echo
echo "Enabling and starting docker.service..."
if command -v systemctl >/dev/null 2>&1; then
  systemctl enable --now docker
else
  echo "systemctl not found. Attempting to start dockerd directly..."
  if command -v dockerd >/dev/null 2>&1; then
    nohup dockerd >/var/log/dockerd.log 2>&1 &
    sleep 3
  else
    echo "Cannot start Docker: neither systemctl nor dockerd available."
    exit 1
  fi
fi

# 3) Ensure docker group & permissions
echo
echo "Ensuring docker group and adding user '$REQUIRED_USER' to it (if not already)."
if ! getent group docker >/dev/null; then
  groupadd docker || true
fi

if id -nG "$REQUIRED_USER" | grep -qw docker; then
  echo "User $REQUIRED_USER is already in docker group."
else
  usermod -aG docker "$REQUIRED_USER"
  echo "Added $REQUIRED_USER to docker group. Please log out and back in (or run 'newgrp docker') to apply."
fi

# 4) Quick permission check of the socket
if [ -S /var/run/docker.sock ]; then
  ls -l /var/run/docker.sock || true
else
  echo "Warning: /var/run/docker.sock not found yet. Docker may not be running correctly."
fi

# 5) Test Docker
echo
echo "Testing Docker with 'hello-world' (this will pull an image)."
set +e
docker run --rm hello-world
RET=$?
set -e

if [ "$RET" -eq 0 ]; then
  echo
  echo "✅ Docker is running correctly. Starting Your Container... running 'docker compose up -d' in your project."
  docker compose up -d
  echo "You are all Set! Access n8n at http://localhost:5678 or https://example.yourdomain.com (if set your subdomain)"

  exit 0
else
  echo
  echo "❌ Docker test failed (exit code: $RET)."
  echo "Suggestions:"
  echo " - run 'sudo systemctl status docker' and 'docker info' for diagnostics"
  echo " - re-login or run 'newgrp docker' and try again"
  echo " - if using a non-systemd distro, ensure dockerd is running"
  exit $RET
fi

# 3) Ensure docker group & permissions
echo
echo "Ensuring docker group and adding user '$REQUIRED_USER' to it (if not already)."
if ! getent group docker >/dev/null; then
  groupadd docker || true
fi

if id -nG "$REQUIRED_USER" | grep -qw docker; then
  echo "User $REQUIRED_USER is already in docker group."
else
  usermod -aG docker "$REQUIRED_USER"
  newgrp docker
  echo "Added $REQUIRED_USER to docker group. Please log out and back in (or run 'newgrp docker') to apply."
fi

