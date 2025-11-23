# n8n Self-Host Starter Kit 🚀

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![n8n](https://img.shields.io/badge/n8n-FF6D5A?style=for-the-badge&logo=n8n&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Caddy](https://img.shields.io/badge/Caddy-00ADD8?style=for-the-badge&logo=caddy&logoColor=white)

**A fast, production-ready starter to self-host n8n with HTTPS, PostgreSQL (+pgvector ready), and a secure defaults-first setup.**

---

## 📖 Overview

This repo gives you a minimal, repeatable way to run **n8n** in production using Docker Compose, automatic HTTPS via Caddy, and PostgreSQL (pgvector-ready).  
The goal: **clone → edit three values in `.env` → run one command → done**.

---

## ✅ Prerequisites

1. A VPS (AWS EC2, DigitalOcean, Hetzner, Hostinger VPS, etc.)
2. A domain (DuckDNS is fine) pointing to your server public IP.
3. **Inbound firewall rules (VERY important):**
   - **80/tcp** → Required for HTTP + Let’s Encrypt challenge  
   - **443/tcp** → Required for HTTPS  
   - **22/tcp** → SSH access  
4. Docker & Docker Compose installed.

---

## 🛠️ Quick Deployment

### 1. Clone the repo
```bash
git clone https://github.com/kshitijpatil508/n8n-self-host-starter.git
cd n8n-self-host-starter
```

### 2. Edit the `.env` file (ONLY 3 required fields)

Open `.env`:
```bash
nano .env
```

Update ONLY these:
```bash
DOMAIN_NAME=example.duckdns.org
N8N_ENCRYPTION_KEY=your_secret_encryption_key_here
POSTGRES_PASSWORD=supersecurepassword
```

---

## 🐳 Install Docker (manual or automatic)

### **Manual Docker installation**
```bash
bash <(curl -fsSL https://get.docker.com)
sudo systemctl enable docker
sudo systemctl start docker
```

### Add your user to docker group:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Test Docker:
```bash
docker run --rm hello-world
docker compose version
```

If both work, you're good.

---

### ⭐ OR — Use the included installer script (recommended)

Instead of doing everything manually, just run:

```bash
sudo ./install_docker_minimal.sh
```

This script automatically:

- ✅ Installs Docker  
- ✅ Starts & enables the service  
- ✅ Adds your user to docker group  
- ✅ Verifies Docker & Compose installation  
- ✅ Runs `hello-world` test  
- ✅ Fixes permission issues if needed  

No need to configure anything — just run it.

---

## 🔐 Encryption Key (MUST READ)

`N8N_ENCRYPTION_KEY` encrypts all credentials inside n8n.

- Must be set **before first run**  
- Back it up somewhere safe  
- Losing it = losing encrypted credentials

### Recover the auto-generated key (if you forgot to set it)

Run this **inside the folder containing your `docker-compose.yml`:**

```bash
docker exec $(docker compose ps -q n8n) grep encryptionKey /home/node/.n8n/config
```

Copy the value → update `.env` → restart.

---

## 🚀 Start Your n8n Instance

```bash
docker compose up -d
```

Then access:

```
https://<YOUR_DOMAIN_NAME>
```

Caddy will automatically issue certificates and handle HTTPS.

---

## ⚙️ Configuration Summary

| Variable | Required | Description |
|---------|----------|-------------|
| `DOMAIN_NAME` | ✅ | Your domain |
| `N8N_ENCRYPTION_KEY` | ✅ | Critical encryption key |
| `POSTGRES_PASSWORD` | ✅ | DB password |
| `GENERIC_TIMEZONE` | optional | Default timezone |

---

## 🛡️ Maintenance

**Update n8n:**
```bash
docker compose pull
docker compose up -d
```

**Backup volumes:**
- `n8n_data`
- `postgres_data`

---

## 🆓 Free Domain (DuckDNS)

Use a free DuckDNS subdomain instead of buying a domain:

1. Visit https://duckdns.org  
2. Sign in (GitHub/Google/Reddit)  
3. Add a subdomain → set your public IP  
4. Use it as `DOMAIN_NAME` in `.env`

Works perfectly with Caddy + HTTPS.

---

## 🤝 Contributing
PRs welcome!

