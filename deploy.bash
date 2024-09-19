#!/bin/bash
set -e

# Verifica se o IP do container foi fornecido como argumento
if [ $# -eq 0 ]; then
    echo "Erro: Por favor, forneça o IP do container como argumento."
    echo "Uso: $0 <IP_DO_CONTAINER>"
    exit 1
fi

CONTAINER_IP="$1"
WORKSPACE=$(basename "$WORKSPACE")
REMOTE_PATH="/home/$WORKSPACE"

# Função para logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Função para executar comandos SSH
run_ssh_command() {
    ssh -o StrictHostKeyChecking=no root@$CONTAINER_IP "$1"
}

# Função para copiar arquivos via SCP
run_scp_command() {
    scp -o StrictHostKeyChecking=no -r "$1" root@$CONTAINER_IP:"$2"
}

# Limpeza e preparação
log "Iniciando processo de deployment"
rm -rf .git
printenv

# Executando build
log "Executando o arquivo de build..."
if ! bash ./scripts/build.bash; then
    log "Erro: Falha na construção da aplicação."
    exit 1
fi
log "Aplicação construída com sucesso."

# Enviando arquivos
log "Enviando arquivos para container..."
if ! run_scp_command "$(pwd)" "/home"; then
    log "Erro: Falha ao enviar arquivos para container."
    exit 1
fi
log "Arquivos copiados com sucesso."

# Inicializando serviço
log "Inicializando serviço"
run_ssh_command "cd $REMOTE_PATH"
if ! run_ssh_command "cd $REMOTE_PATH && bash ./scripts/service.bash"; then
    log "Erro: Falha ao inicializar serviço no container."
    exit 1
fi
log "Serviço iniciado com sucesso."

log "Processo de deployment concluído"
