#!/usr/bin/env bash

set -e

#################################### Variáveis
export SOURCE="${HOME}/.2FA_Store"

#################################### Teste
# gpg       = Criptografia Simétrica
# oathtools = Gerar senhas 2FA
for check in 'gpg' 'oathtools'; do
    if ! which "$check" &>/dev/null; then
        echo "Necessita do software $check instalado"
        exit 1
    fi
done

#################################### Funções
function start()
{
    if [[ ! -d "$SOURCE" ]];then
        mkdir -v "$SOURCE"
        chmod 0700 "$SOURCE"
    fi
}

function die()
{
    echo "$@"
    exit 1  
}

function newKey() # Adiciona uma nova chave
{
    if [[ -n "$1" ]]; then
        local service="$1"
    else
        read -ep "Qual o nome do serviço? " service
        [[ -z "$service" ]] && die "Necessita do nome do serviço"
    fi
    read -ep "Chave secreta do serviço ${service}: " secretKey
    [[ -z "$service" ]] && die "Necessita do nome do serviço"
    gpg --quit ----symmetric --out ${SOURCE}/${service} <<< "$secretKey"   

}

#################################### Início

start   

# 1. Adicionar uma nova chave
# 2. Gerar uma nova senha
# 3. Listar o serviços disponíveis

case $1 in
    --new|-n) newKey "$2" ;;
    --totp|-t) : ;;
    --list|-l) : ;;
esac



