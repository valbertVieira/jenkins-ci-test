#!/bin/bash

# Variáveis de ambiente opiocionais
possibles_keys=()  # Array para armazenar as chaves possiveis

# Verifica se o arquivo .env template existe
if [ -f ".env.prod" ]; then
 while read -r LINE; do  # Le cada linha do arquivo

    # Verifica se a linha contém um sinal de igual e não é um comentário
    # e se a linha não está vazia
    if [[ $LINE == *'='* ]] && [[ $LINE != '#'* ]]; then 
        
        # Separando a linha em chave
        key="${LINE%%=*}"
        value="${LINE#*=}"

        # Removendo espaços em branco extras, se houver
        key=$(echo "$key" | sed 's/^[[:space:]]*//')
        value=$(echo "$value" | sed 's/^[[:space:]]*//')
        possibles_keys+=("$key")  # Adiciona a chave ao array possiveis_keys

    fi
  done < .env.prod
else
    echo "[Build] Falha: O arquivo template.env não foi encontrado."
    exit 1
fi

env_values=()

for var in $(env)
do
    # Separa a chave e o valor usando o sinal de igual "=" como delimitador
    key="${var%%=*}"
    value="${var#*=}"

    for i in "${!possibles_keys[@]}"; do
        if [ "$key" == "${possibles_keys[$i]}" ]; then
            env_values+=("$key=$value")
            unset 'possibles_keys[i]'
        fi
    done
done

# Verifica se todas as variáveis obrigatórias foram definidas
invalid_keys=()
for item in "${possibles_keys[@]}"; do
    invalid_keys+=("$item")
done

if [ ${#invalid_keys[@]} -gt 0 ]; then
    echo "[Build] Falha: As seguintes variaveis de ambiente sao obrigatorias e nao foram definidas:"
    for item in "${invalid_keys[@]}"; do
        echo "$item"
    done
    exit 1
fi

# Cria o arquivo .env
> .env

for item in "${env_values[@]}"; do
    echo "$item" >> .env
done

echo "[Build] Sucesso: Arquivo .env criado."
