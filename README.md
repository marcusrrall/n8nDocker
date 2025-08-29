# 🚀 n8n com Docker Compose + Makefile

[🇺🇸 Read in English](./README.en.md)
Este projeto traz uma configuração **simples e organizada** para rodar o [n8n](https://n8n.io) usando **Docker Compose** e um **Makefile** que facilita os comandos mais comuns no dia a dia.

---

## 📦 Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Make](https://www.gnu.org/software/make/)

---

## ⚙️ Configuração inicial

1. Copie o arquivo de exemplo `.env.example` para `.env`:
   ```bash
   cp .env.example .env
   ```
2. Abra o arquivo `.env` e ajuste as variáveis de ambiente:
   - `N8N_BASIC_AUTH_USER` → Usuário para acessar o painel do n8n
   - `N8N_BASIC_AUTH_PASSWORD` → Senha para acessar o painel
   - `N8N_ENCRYPTION_KEY` → Chave longa e aleatória para criptografar credenciais (use `openssl rand -base64 48`)
   - `TZ` → Fuso horário, ex: `America/Araguaina`

⚠️ O arquivo `.env` **não deve ser versionado no Git** (já está no `.gitignore`).  
O `.env.example` serve apenas como referência para novos desenvolvedores.

---

## ⚙️ Como usar

### 1. Subir o container

```bash
make up
```

➡️ Sobe os serviços em segundo plano (`docker compose up -d`).

### 2. Parar os serviços

```bash
make stop
```

➡️ Para os containers sem remover.

### 3. Derrubar tudo

```bash
make down
```

➡️ Remove containers, mantendo volumes e rede.

### 4. Reiniciar

```bash
make restart
```

### 5. Ver status

```bash
make ps
```

### 6. Ver logs em tempo real

```bash
make logs
```

### 7. Atualizar imagens

```bash
make pull
make rebuild
```

- `pull` → baixa versões mais recentes da imagem.
- `rebuild` → reconstrói (se houver build) e sobe novamente.

### 8. Acessar o container

```bash
make shell
```

➡️ Abre um shell (`bash` ou `sh`) dentro do container do n8n.

### 9. Backup dos dados

```bash
make backup
```

➡️ Cria um backup da pasta `n8n_data` em um `.tgz` com timestamp.

### 10. Restaurar backup

```bash
make restore FILE=backup-n8n-20250101-120000.tgz
```

➡️ Restaura o backup informado.

### 11. Limpeza de recursos não usados

```bash
make prune
```

➡️ Executa `docker system prune -f`.

---

## 🗂 Estrutura do projeto

```bash
.
├── docker-compose.yml   # Configuração do n8n
├── Makefile             # Comandos automatizados
├── .env.example         # Modelo de variáveis de ambiente
├── n8n_data/            # Volume local persistente (ignorado pelo Git)
└── README.md            # Este arquivo
```

---

## 🌐 Acesso

Após rodar `make up`, acesse no navegador:

```
http://localhost:5678
```

Usuário e senha são definidos no arquivo `.env` (variáveis `N8N_BASIC_AUTH_USER` e `N8N_BASIC_AUTH_PASSWORD`).

---

## 🛠 Dicas

- Personalize as variáveis no `Makefile` (`PROJECT_NAME`, `DATA_DIR`, etc).
- Para produção, considere usar **PostgreSQL** em vez de SQLite local.
- Combine com **Traefik ou Nginx** se quiser HTTPS e domínio próprio.
- Use o `N8N_ENCRYPTION_KEY` para garantir segurança das credenciais.

---

Feito com 💻 por MarcusRall
