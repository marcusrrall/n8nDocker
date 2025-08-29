# 🚀 n8n with Docker Compose + Makefile

[🇧🇷 Leia em Português](./README.md)
This project provides a **simple and organized** setup to run [n8n](https://n8n.io) using **Docker Compose** and a **Makefile** that simplifies common commands for everyday use.

---

## 📦 Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Make](https://www.gnu.org/software/make/)

---

## ⚙️ Initial setup

1. Copy the example environment file `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
2. Open the `.env` file and adjust the environment variables:
   - `N8N_BASIC_AUTH_USER` → Username to access the n8n panel
   - `N8N_BASIC_AUTH_PASSWORD` → Password to access the panel
   - `N8N_ENCRYPTION_KEY` → Long random string to encrypt credentials (use `openssl rand -base64 48`)
   - `TZ` → Timezone, e.g., `America/Araguaina`

⚠️ The `.env` file **must not be versioned in Git** (already in `.gitignore`).  
The `.env.example` is just a reference for new developers.

---

## ⚙️ Usage

### 1. Start the container

```bash
make up
```

➡️ Starts the services in the background (`docker compose up -d`).

### 2. Stop the services

```bash
make stop
```

➡️ Stops the containers without removing them.

### 3. Take everything down

```bash
make down
```

➡️ Removes containers, keeps volumes and network.

### 4. Restart

```bash
make restart
```

### 5. Check status

```bash
make ps
```

### 6. Follow logs in real time

```bash
make logs
```

### 7. Update images

```bash
make pull
make rebuild
```

- `pull` → pulls the latest image versions.
- `rebuild` → rebuilds (if there is a build) and restarts.

### 8. Access the container

```bash
make shell
```

➡️ Opens a shell (`bash` or `sh`) inside the n8n container.

### 9. Backup data

```bash
make backup
```

➡️ Creates a `.tgz` backup of the `n8n_data` folder with timestamp.

### 10. Restore backup

```bash
make restore FILE=backup-n8n-20250101-120000.tgz
```

➡️ Restores the specified backup.

### 11. Cleanup unused resources

```bash
make prune
```

➡️ Runs `docker system prune -f`.

---

## 🗂 Project structure

```bash
.
├── docker-compose.yml   # n8n configuration
├── Makefile             # Automated commands
├── .env.example         # Environment variable template
├── n8n_data/            # Local persistent volume (ignored by Git)
└── README.md            # This file
```

---

## 🌐 Access

After running `make up`, open in your browser:

```
http://localhost:5678
```

The username and password are defined in the `.env` file (variables `N8N_BASIC_AUTH_USER` and `N8N_BASIC_AUTH_PASSWORD`).

---

## 🛠 Tips

- Customize variables in the `Makefile` (`PROJECT_NAME`, `DATA_DIR`, etc).
- For production, consider using **PostgreSQL** instead of local SQLite.
- Combine with **Traefik or Nginx** if you want HTTPS and a custom domain.
- Use `N8N_ENCRYPTION_KEY` to secure stored credentials.

---

Made with 💻 by MarcusRall
