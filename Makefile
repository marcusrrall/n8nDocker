# Makefile para orquestrar n8n com Docker Compose

# Detecta automaticamente se existe "docker compose" (v2) ou "docker-compose" (v1)
DC := $(shell command -v docker-compose >/dev/null 2>&1 && echo docker-compose || echo docker compose)

# Nome do projeto (aparece em nomes de containers, redes, etc.)
PROJECT_NAME ?= n8n

# Arquivo compose
COMPOSE_FILE ?= docker-compose.yml

# Diretório de dados (precisa casar com o volume do compose)
DATA_DIR ?= n8n_data

# Usuário/Grupo para ajustar permissões do diretório de dados (opcional)
HOST_UID ?= $(shell id -u)
HOST_GID ?= $(shell id -g)

# ===== Alvos principais =====

.PHONY: help
help: ## Mostra esta ajuda
	@echo "Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

.PHONY: up
up: ensure-data-dir ## Sobe os serviços em segundo plano
	$(DC) -p $(PROJECT_NAME) -f $(COMPOSE_FILE) up -d

.PHONY: down
down: ## Para e remove containers, mantendo volumes
	$(DC) -p $(PROJECT_NAME) -f $(COMPOSE_FILE) down

.PHONY: restart
restart: ## Reinicia os serviços
	$(DC) -p $(PROJECT_NAME) -f $(COMPOSE_FILE) restart

.PHONY: logs
logs: ## Segue os logs do n8n
	$(DC) -p $(PROJECT_NAME) -f $(COMPOSE_FILE) logs -f n8n

.PHONY: ps
ps: ## Lista o status dos serviços
	$(DC) -p $(PROJECT_NAME) -f $(COMPOSE_FILE) ps

.PHONY: pull
pull: ## Atualiza as imagens
	$(DC) -p $(PROJECT_NAME) -f $(COMPOSE_FILE) pull

.PHONY: rebuild
rebuild: ## Reconstrói (se houver build) e reinicia
	$(DC) -p $(PROJECT_NAME) -f $(COMPOSE_FILE) up -d --build

.PHONY: shell
shell: ## Abre um shell dentro do container do n8n
	$(DC) -p $(PROJECT_NAME) -f $(COMPOSE_FILE) exec n8n bash || \
	$(DC) -p $(PROJECT_NAME) -f $(COMPOSE_FILE) exec n8n sh

.PHONY: stop
stop: ## Para os serviços sem remover
	$(DC) -p $(PROJECT_NAME) -f $(COMPOSE_FILE) stop

.PHONY: start
start: ## Inicia serviços parados
	$(DC) -p $(PROJECT_NAME) -f $(COMPOSE_FILE) start

.PHONY: restart-clean
restart-clean: down prune up ## Reinicia limpando recursos não usados

# ===== Utilitários =====

.PHONY: ensure-data-dir
ensure-data-dir: ## Cria o diretório de dados com permissões corretas
	@mkdir -p $(DATA_DIR)
	@chown -R $(HOST_UID):$(HOST_GID) $(DATA_DIR) || true

.PHONY: prune
prune: ## Limpa recursos Docker não usados (atenção!)
	docker system prune -f

.PHONY: backup
backup: ensure-data-dir ## Faz backup da pasta de dados em .tar.gz
	@timestamp=$$(date +'%Y%m%d-%H%M%S'); \
	tar -czf backup-n8n-$$timestamp.tgz $(DATA_DIR); \
	echo "Backup criado: backup-n8n-$$timestamp.tgz"

.PHONY: restore
restore: ## Restaura um backup: make restore FILE=backup-n8n-YYYYMMDD-HHMMSS.tgz
ifndef FILE
	$(error Informe o arquivo: make restore FILE=backup-n8n-XXXX.tgz)
endif
	tar -xzf $(FILE)
	@echo "Backup restaurado em $(DATA_DIR)."
