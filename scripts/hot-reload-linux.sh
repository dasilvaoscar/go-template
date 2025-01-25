#!/bin/bash

# Diretório a ser monitorado
WATCH_DIR="."

# Porta que será monitorada para encerrar processos
PORT=8080

# Função para encerrar processos na porta especificada
kill_process_on_port() {
  echo "Encerrando processos na porta $PORT..."
  fuser -k "$PORT/tcp" || echo "Nenhum processo na porta $PORT para encerrar."
}

# Função para iniciar o servidor
start_server() {
  echo "Iniciando o servidor..."
  go run main.go &
}

# Encerrar qualquer processo existente na porta antes de iniciar
kill_process_on_port

# Iniciar o servidor pela primeira vez
start_server

# Loop infinito para monitorar mudanças
while true; do
  # Monitorar alterações em arquivos .go no diretório
  inotifywait -e modify -e create -e delete -r "$WATCH_DIR" --include '.*\.go$'

  # Reiniciar o servidor após alterações
  kill_process_on_port
  start_server
done
