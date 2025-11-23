# n8n Self-Host Starter Kit 🚀

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![n8n](https://img.shields.io/badge/n8n-FF6D5A?style=for-the-badge&logo=n8n&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Caddy](https://img.shields.io/badge/Caddy-00ADD8?style=for-the-badge&logo=caddy&logoColor=white)

**A production-ready, secure, and extremely simple boilerplate for self-hosting n8n with HTTPS + PostgreSQL + pgvector. Just edit your `.env` and run one command.**

---

## 📖 Overview

This template gives you a fully automated production deployment of **n8n** using:

- **Caddy** for automatic HTTPS (zero config, no file editing)
- **PostgreSQL + pgvector** for AI-ready workflows
- **Docker Compose** for portability and easy updates

Everything is pre‑configured in `docker-compose.yml`.  
**No need to edit Caddyfile** — HTTPS is handled automatically through the Caddy command inside the compose file.

---

## ✅ Prerequisites

Before you start:

1. A VPS (AWS EC2, DigitalOcean, Hetzner, Hostinger VPS)
2. A domain pointing to your server's IP
3. Docker + Docker Compose installed  
   Install Docker:
   ```
   curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
   ```
---

## 🆓 Use a Free Domain with DuckDNS (No Payment Needed)

You don’t need to buy a domain to use this starter kit.  
You can get a **completely free domain** from DuckDNS in under 1 minute.

### How to Get a Free DuckDNS Domain

1. Go to **https://www.duckdns.org**  
2. Sign in using GitHub / Google / Reddit  
3. Choose a name → click **Add Domain**  
4. Enter your server’s public IP in the “IP” field  
5. Click **Update IP** — and you're done 🎉

Your free domain will look like: **yourname.duckdns.org**

Set it in your `.env`:
```bash
DOMAIN_NAME=example.duckdns.org
```
Caddy will automatically generate HTTPS for it.

---

## 🛠️ Deployment Guide (Only 1 File to Edit)

### 1. Clone the Repository
```bash
git clone https://github.com/kshitijpatil508/n8n-self-host-starter.git
cd n8n-self-host-starter
```

### 2. Edit the `.env` File (VERY IMPORTANT)
You already have `.env` included in the repo — just edit it:

```bash
nano .env
```

### Required values to update:

| Variable | Why It's Important |
|---------|---------------------|
| `DOMAIN_NAME` | Your n8n domain (required for HTTPS) |
| `SSL_EMAIL` | Email for Let's Encrypt |
| `N8N_ENCRYPTION_KEY` | **CRITICAL — MUST be set before first run** |
| `POSTGRES_PASSWORD` | Secure DB password |

---

## 🔐 ⚠️ About the Encryption Key (MUST READ)

Your `N8N_ENCRYPTION_KEY` secures **all your credentials** inside n8n.

### ✔️ Rules:
- **MUST be set before running n8n for the first time**
- **Store a backup somewhere safe** (password manager, notes vault, etc.)
- Losing this key means losing access to all encrypted credentials forever

### ❗ If You Forgot to Set the Key Before First Run:
If you accidentally started n8n without setting the key:

Run this command to recover the auto‑generated key:

```bash
docker exec $(docker compose ps -q n8n) grep encryptionKey /home/node/.n8n/config
```

**SAVE IT IMMEDIATELY**, then put it inside `.env`.

---

## 🚀 Start the Stack

```bash
docker compose up -d
```

That’s it.

Caddy will automatically:
- Request HTTPS certificates
- Enable SSL
- Reverse‑proxy n8n securely

Your instance will be available at:

```
https://<your DOMAIN_NAME>
```

---

## ⚙️ Configuration Variables Summary

| Variable | Description | Example |
|---------|-------------|---------|
| `DOMAIN_NAME` | Domain for your n8n instance | `n8n.example.com` |
| `SSL_EMAIL` | Email for SSL certificate | `admin@example.com` |
| `GENERIC_TIMEZONE` | Server timezone | `Asia/Kolkata` |
| `N8N_ENCRYPTION_KEY` | **Critical security key** | random string |
| `POSTGRES_USER` | Database user | `n8n` |
| `POSTGRES_PASSWORD` | Strong DB password | `change_me` |
| `POSTGRES_DB` | DB name | `n8n` |

---

## 🛡️ Maintenance & Updates

### Update n8n:
```bash
docker compose pull
docker compose up -d
```

### Backup volumes:
- `n8n_data`
- `postgres_data`

Use snapshots or manual volume backups.

---

### 🤝 Contributing

Found a bug or want to improve the stack? PRs are welcome!
