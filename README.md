# n8n Self-Host Starter Kit 🚀

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![n8n](https://img.shields.io/badge/n8n-FF6D5A?style=for-the-badge&logo=n8n&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Caddy](https://img.shields.io/badge/Caddy-00ADD8?style=for-the-badge&logo=caddy&logoColor=white)

**A production-ready, secure, and scalable boilerplate for self-hosting n8n on AWS EC2, DigitalOcean, or any generic VPS.**

---

## 📖 Overview

This repository provides a "batteries-included" configuration to deploy **n8n** (the workflow automation tool) with a robust backend stack. Unlike simple SQLite deployments, this setup is designed for **reliability** and **AI workloads**.

### Why This Stack?

| Feature | Technology | Benefit |
| :--- | :--- | :--- |
| **Zero-Downtime SSL** | **Caddy** | Automatic HTTPS handling with Let's Encrypt. No manual cert renewal required. |
| **AI Ready** | **PostgreSQL + pgvector** | Includes the `pgvector` extension, enabling vector embeddings for AI/LLM agents within n8n. |
| **Data Reliability** | **PostgreSQL** | Far superior concurrency and data integrity compared to the default SQLite database. |
| **Portability** | **Docker Compose** | The entire stack is containerized. Move between servers in minutes. |

---

## ✅ Prerequisites

Before you begin, ensure you have the following:

1.  **A Virtual Private Server (VPS):** AWS EC2 (t3.medium recommended), DigitalOcean Droplet, or Hetzner Cloud running Ubuntu/Debian.
2.  **Domain Name:** A domain (e.g., `n8n.example.com`) with an **A Record** pointing to your server's Public IP address.
3.  **Docker & Docker Compose:** Installed on your server.

> **Need Docker?** Run this on your server:
> `curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh`

---

## 🛠️ Detailed Deployment Guide (AWS / VPS)

Follow these steps to get your instance running in under 10 minutes.

### 1. Clone the Repository
SSH into your server and clone this project:

```bash
git clone https://github.com/kshitijpatil508/n8n-self-host-starter.git
cd n8n-self-host-starter
```

### 2. Configure Environment Variables
Create a `.env` file based on the example to store your secrets securely.

```bash
cp .env.example .env
nano .env
```

*Edit the values in `.env` to match your preferences (see the [Configuration Table](#configuration-variables) below).*

### 3. Configure Caddy (SSL)
Open the `Caddyfile` to set your domain and email for SSL registration.

```bash
nano Caddyfile
```

**Replace the placeholders:**
```text
n8n.yourdomain.com {
    reverse_proxy n8n:5678
}
```

### 4. Start the Stack
Launch the containers in detached mode:

```bash
docker compose up -d
```

### 5. Verification
Check that all containers are running healthy:

```bash
docker compose ps
```

🎉 **Success!** Navigate to `https://n8n.yourdomain.com` in your browser to finish the setup.

---

## ⚡ Simplified Guide: Hostinger / One-Click

**Using Hostinger?**
If you are using Hostinger's **VPS App Hosting**, you may not need this manual repository. Hostinger offers a 1-Click Install for n8n.

* **Pros:** Extremely fast setup, managed interface.
* **Cons:** Standard installations usually use SQLite. If you require **pgvector** for AI Embeddings, you should follow the **Detailed Guide** above instead to ensure PostgreSQL is configured correctly.

---

## ⚙️ Configuration Variables

These variables in your `.env` (or `docker-compose.yml`) control the stack.

| Variable | Description | Default / Example |
| :--- | :--- | :--- |
| `DOMAIN_NAME` | The subdomain where n8n will live. | `n8n.example.com` |
| `SSL_EMAIL` | Email used for Let's Encrypt notifications. | `admin@example.com` |
| `DB_POSTGRESDB_USER` | Username for the Postgres database. | `n8n_user` |
| `DB_POSTGRESDB_PASSWORD` | **Critical:** Strong password for the DB. | `ChangeMe123!` |
| `DB_POSTGRESDB_DATABASE` | Name of the database. | `n8n` |
| `N8N_ENCRYPTION_KEY` | **Critical:** Encrypts credentials stored in n8n. | Generate a random string. |
| `N8N_BASIC_AUTH_USER` | Optional: Basic Auth username for extra security. | `admin` |
| `N8N_BASIC_AUTH_PASSWORD` | Optional: Basic Auth password. | `password` |
| `WEBHOOK_URL` | Explicit URL for webhooks (required for proper routing). | `https://n8n.example.com/` |

---

## 🛡️ Maintenance & Updates

**To update n8n to the latest version:**

```bash
# Pull the latest images
docker compose pull

# Restart the stack with new images
docker compose up -d
```

**To backup your data:**
Your data is persisted in the `n8n_data` and `postgres_data` Docker volumes. Ensure you regularly backup these volumes or use a snapshotting service provided by your VPS host.

---

### 🤝 Contributing
Found a bug or want to improve the stack? PRs are welcome!
