#!/bin/bash
set -e

# ==============================================================================
# AWS EC2 One-Command Initialization Script for Gaming Castle
# Supports: Ubuntu 22.04 LTS / 24.04 LTS
# ==============================================================================

echo "=========================================================="
echo "🎮 Gaming Castle - EC2 Production Setup"
echo "=========================================================="

# 1. Update and install prerequisites
echo "📦 [1/6] Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git ufw fail2ban ca-certificates gnupg

# 2. Install Docker Engine and Docker Compose V2
echo "🐳 [2/6] Installing Docker Engine & Docker Compose V2..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 3. Add current user to docker group (run without sudo)
echo "👤 [3/6] Configuring user permissions for Docker..."
sudo usermod -aG docker "$USER"

# 4. Configure 4GB Swap file (Protects against Java OOM errors)
if [ ! -f /swapfile ]; then
    echo "💾 [4/6] Creating 4GB Swap memory..."
    sudo fallocate -l 4G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
else
    echo "💾 [4/6] Swapfile already exists. Skipping."
fi

# 5. Set up application directories
echo "📁 [5/6] Creating deployment folder structure..."
mkdir -p /home/ubuntu/gaming-castle/infra
cd /home/ubuntu/gaming-castle/infra

if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "⚠️ Created /home/ubuntu/gaming-castle/infra/.env from .env.example."
        echo "👉 PLEASE EDIT .env with your real database passwords and JWT secrets!"
    fi
fi

# 6. Configure Firewall (UFW)
echo "🛡️ [6/6] Configuring UFW Firewall..."
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'
sudo ufw allow 4200/tcp comment 'Frontend direct'
sudo ufw allow 8080/tcp comment 'API Gateway direct'
sudo ufw --force enable

echo ""
echo "=========================================================="
echo "✅ EC2 Server Initialization Completed Successfully!"
echo "=========================================================="
echo "NEXT STEPS:"
echo "1. Run: newgrp docker"
echo "2. Log into GitHub Container Registry (ghcr.io):"
echo "   echo \"YOUR_GITHUB_PAT\" | docker login ghcr.io -u YOUR_GITHUB_USER --password-stdin"
echo "3. Edit /home/ubuntu/gaming-castle/infra/.env with your production secrets."
echo "4. Push code to 'main' branch or trigger CD workflow from GitHub Actions!"
echo "=========================================================="
