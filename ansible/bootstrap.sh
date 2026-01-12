#!/bin/bash
set -e

# Homelab PaaS Bootstrap Script
# Installs Ansible and deploys full system to Debian 12 LXC container

REPO_URL="https://github.com/jamesphenry/homelab-paas.git"
INSTALL_DIR="/opt/homelab-paas"

echo "==> Homelab PaS Bootstrap Script"
echo "==> Running on $(hostname)"

# Check for Debian
if [ ! -f /etc/debian_version ]; then
    echo "Error: This script requires Debian 12"
    exit 1
fi

# Update system
echo "==> Updating system packages..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get upgrade -y -qq

# Install prerequisites
echo "==> Installing prerequisites..."
apt-get install -y -qq curl wget gnupg apt-transport-https ca-certificates git

# Install Ansible
echo "==> Installing Ansible..."
if ! command -v ansible &> /dev/null; then
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main" > /etc/apt/sources.list.d/ansible.list
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 2>/dev/null || true
    apt-get update -qq
    apt-get install -y -qq ansible
fi

# Clone repository
echo "==> Cloning Homelab PaaS repository..."
if [ -d "$INSTALL_DIR" ]; then
    echo "Repository already exists at $INSTALL_DIR, pulling latest..."
    cd "$INSTALL_DIR"
    git pull origin main
else
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# Run Ansible playbook
echo "==> Running Ansible playbook..."
cd "$INSTALL_DIR/ansible"
ansible-playbook -i inventory local.yml --become

echo ""
echo "==> Bootstrap Complete!"
echo "==> Access your dashboard at: http://$(hostname -I | awk '{print $1}'):8080"
echo "==> Gitea available at: http://$(hostname -I | awk '{print $1}'):3000"
echo "==> Monitoring API at: http://$(hostname -I | awk '{print $1}'):5000"
echo ""
echo "Login with your system credentials via PAM authentication."
echo ""
echo "Next steps:"
echo "  1. Access the dashboard to create your first experiment"
echo "  2. Run 'opencode' to customize this system"
echo "  3. See AGENTS.md for development guide"
