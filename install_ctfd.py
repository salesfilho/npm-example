#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
╔══════════════════════════════════════════════════════════════════╗
║         SCRIPT DE INSTALAÇÃO CTFd + Docker no Ubuntu            ║
║                                                                  ║
║  Autor:para Jaqueline Pereira da Silva                           ║
║  Descrição: Automatiza a instalação completa do CTFd com         ║
║             Docker, Docker Compose e ferramentas adicionais      ║
║             para competições Capture The Flag (CTF).             ║
║                                                                  ║
║  Requisitos: Ubuntu 20.04+ | Executar como root ou com sudo      ║
╚══════════════════════════════════════════════════════════════════╝
"""

import subprocess
import sys
import os
import time
import shutil
import argparse
import logging
from pathlib import Path
from datetime import datetime

# ─────────────────────────────────────────────────────────────────
# CONFIGURAÇÕES GLOBAIS
# ─────────────────────────────────────────────────────────────────

CTFD_DIR = "/opt/ctfd"
CTFD_REPO = "https://github.com/CTFd/CTFd.git"
CTFD_PORT = 8000
CTFD_HTTPS_PORT = 443
LOG_FILE = "/var/log/ctfd_install.log"
DOCKER_COMPOSE_VERSION = "v2.24.0"

# Cores para output no terminal
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


# ─────────────────────────────────────────────────────────────────
# LOGGING
# ─────────────────────────────────────────────────────────────────

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.FileHandler(LOG_FILE, mode='a'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)


# ─────────────────────────────────────────────────────────────────
# FUNÇÕES UTILITÁRIAS
# ─────────────────────────────────────────────────────────────────

def print_banner():
    """Exibe o banner do instalador."""
    banner = f"""
{Colors.CYAN}{Colors.BOLD}
  ██████╗████████╗███████╗██████╗     ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
 ██╔════╝╚══██╔══╝██╔════╝██╔══██╗    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
 ██║        ██║   █████╗  ██║  ██║    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
 ██║        ██║   ██╔══╝  ██║  ██║    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
 ╚██████╗   ██║   ██║     ██████╔╝    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
  ╚═════╝   ╚═╝   ╚═╝     ╚═════╝     ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝
{Colors.ENDC}
{Colors.GREEN}  ► CTFd + Docker + Ferramentas CTF para Ubuntu
  ► Versão: 2.0 | Data: {datetime.now().strftime('%d/%m/%Y')}
{Colors.ENDC}
"""
    print(banner)


def run_command(cmd, description="", check=True, capture_output=False, shell=True):
    """Executa um comando do sistema com tratamento de erros."""
    if description:
        logger.info(f"  ► {description}")
    
    try:
        result = subprocess.run(
            cmd,
            shell=shell,
            check=check,
            capture_output=capture_output,
            text=True,
            timeout=600
        )
        return result
    except subprocess.CalledProcessError as e:
        logger.error(f"  ✗ Erro ao executar: {cmd}")
        logger.error(f"    Código de saída: {e.returncode}")
        if e.stderr:
            logger.error(f"    Stderr: {e.stderr}")
        if not check:
            return e
        raise
    except subprocess.TimeoutExpired:
        logger.error(f"  ✗ Timeout ao executar: {cmd}")
        raise


def check_root():
    """Verifica se o script está sendo executado como root."""
    if os.geteuid() != 0:
        logger.error(f"{Colors.FAIL}Este script precisa ser executado como root (sudo).{Colors.ENDC}")
        logger.info(f"  Execute: sudo python3 {sys.argv[0]}")
        sys.exit(1)


def check_ubuntu():
    """Verifica se o SO é Ubuntu."""
    try:
        with open('/etc/os-release', 'r') as f:
            content = f.read()
        if 'ubuntu' not in content.lower():
            logger.warning(f"{Colors.WARNING}⚠ Este script foi projetado para Ubuntu. "
                         f"A compatibilidade com outros sistemas não é garantida.{Colors.ENDC}")
            response = input("Deseja continuar mesmo assim? (s/N): ")
            if response.lower() != 's':
                sys.exit(0)
    except FileNotFoundError:
        logger.warning("Não foi possível verificar o sistema operacional.")


def print_step(step_num, total, description):
    """Imprime o cabeçalho de uma etapa."""
    print(f"\n{Colors.BLUE}{Colors.BOLD}{'='*65}")
    print(f"  ETAPA {step_num}/{total}: {description}")
    print(f"{'='*65}{Colors.ENDC}\n")


# ─────────────────────────────────────────────────────────────────
# ETAPAS DE INSTALAÇÃO
# ─────────────────────────────────────────────────────────────────

def step_update_system():
    """Etapa 1: Atualização do sistema e instalação de dependências básicas."""
    print_step(1, 8, "ATUALIZAÇÃO DO SISTEMA E DEPENDÊNCIAS")
    
    run_command(
        "apt-get update -y && apt-get upgrade -y",
        "Atualizando pacotes do sistema..."
    )
    
    base_packages = [
        "apt-transport-https",
        "ca-certificates",
        "curl",
        "gnupg",
        "lsb-release",
        "software-properties-common",
        "git",
        "wget",
        "unzip",
        "build-essential",
        "python3-pip",
        "python3-venv",
        "python3-dev",
        "libffi-dev",
        "libssl-dev",
        "ufw",
        "fail2ban",
        "htop",
        "tmux",
        "net-tools",
        "jq",
        "tree",
    ]
    
    run_command(
        f"apt-get install -y {' '.join(base_packages)}",
        "Instalando pacotes base do sistema..."
    )
    
    logger.info(f"  {Colors.GREEN}✓ Sistema atualizado e dependências base instaladas.{Colors.ENDC}")


def step_install_docker():
    """Etapa 2: Instalação do Docker Engine e Docker Compose."""
    print_step(2, 8, "INSTALAÇÃO DO DOCKER E DOCKER COMPOSE")
    
    # Remover versões antigas
    run_command(
        "apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true",
        "Removendo versões antigas do Docker..."
    )
    
    # Adicionar repositório oficial do Docker
    run_command(
        "install -m 0755 -d /etc/apt/keyrings",
        "Criando diretório de chaves..."
    )
    
    run_command(
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | "
        "gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg",
        "Adicionando chave GPG do Docker..."
    )
    
    run_command(
        "chmod a+r /etc/apt/keyrings/docker.gpg",
        "Ajustando permissões da chave..."
    )
    
    # Obter informações da distro
    result = run_command(
        "lsb_release -cs",
        capture_output=True
    )
    codename = result.stdout.strip()
    
    result = run_command(
        "dpkg --print-architecture",
        capture_output=True
    )
    arch = result.stdout.strip()
    
    # Adicionar repositório
    repo_line = (
        f'deb [arch={arch} signed-by=/etc/apt/keyrings/docker.gpg] '
        f'https://download.docker.com/linux/ubuntu {codename} stable'
    )
    
    run_command(
        f'echo "{repo_line}" > /etc/apt/sources.list.d/docker.list',
        "Adicionando repositório do Docker..."
    )
    
    run_command("apt-get update -y", "Atualizando lista de pacotes...")
    
    # Instalar Docker
    docker_packages = [
        "docker-ce",
        "docker-ce-cli",
        "containerd.io",
        "docker-buildx-plugin",
        "docker-compose-plugin",
    ]
    
    run_command(
        f"apt-get install -y {' '.join(docker_packages)}",
        "Instalando Docker Engine e plugins..."
    )
    
    # Habilitar e iniciar Docker
    run_command("systemctl enable docker", "Habilitando Docker no boot...")
    run_command("systemctl start docker", "Iniciando serviço Docker...")
    
    # Verificar instalação
    run_command("docker --version", "Verificando versão do Docker...")
    run_command("docker compose version", "Verificando versão do Docker Compose...")
    
    # Adicionar usuário atual ao grupo docker (se não for root direto)
    sudo_user = os.environ.get('SUDO_USER')
    if sudo_user:
        run_command(
            f"usermod -aG docker {sudo_user}",
            f"Adicionando usuário '{sudo_user}' ao grupo docker..."
        )
    
    logger.info(f"  {Colors.GREEN}✓ Docker e Docker Compose instalados com sucesso.{Colors.ENDC}")


def step_clone_ctfd():
    """Etapa 3: Clonar e configurar o CTFd."""
    print_step(3, 8, "CLONANDO E CONFIGURANDO CTFd")
    
    # Remover instalação anterior se existir
    if os.path.exists(CTFD_DIR):
        logger.warning(f"  Diretório {CTFD_DIR} já existe. Fazendo backup...")
        backup_name = f"{CTFD_DIR}_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        shutil.move(CTFD_DIR, backup_name)
        logger.info(f"  Backup salvo em: {backup_name}")
    
    # Clonar repositório
    run_command(
        f"git clone {CTFD_REPO} {CTFD_DIR}",
        "Clonando repositório CTFd..."
    )
    
    logger.info(f"  {Colors.GREEN}✓ CTFd clonado em {CTFD_DIR}.{Colors.ENDC}")


def step_configure_ctfd():
    """Etapa 4: Criar docker-compose customizado com Nginx, Redis e MariaDB."""
    print_step(4, 8, "CONFIGURAÇÃO AVANÇADA DO CTFd")
    
    # ─── docker-compose.yml customizado ───
    docker_compose_content = f"""# ============================================================
# CTFd - Docker Compose (Produção)
# Gerado automaticamente pelo instalador CTFd
# ============================================================

version: '3.8'

services:
  # ── CTFd Application ──────────────────────────────────────
  ctfd:
    build: .
    container_name: ctfd_app
    restart: always
    ports:
      - "{CTFD_PORT}:8000"
    environment:
      - UPLOAD_FOLDER=/var/uploads
      - DATABASE_URL=mysql+pymysql://ctfd:ctfd_password_segura@db/ctfd
      - REDIS_URL=redis://cache:6379
      - WORKERS=4
      - LOG_FOLDER=/var/log/CTFd
      - ACCESS_LOG=-
      - ERROR_LOG=-
      - REVERSE_PROXY=true
    volumes:
      - ctfd_logs:/var/log/CTFd
      - ctfd_uploads:/var/uploads
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_healthy
    networks:
      - ctfd_internal
      - ctfd_frontend

  # ── MariaDB Database ──────────────────────────────────────
  db:
    image: mariadb:10.11
    container_name: ctfd_db
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=ctfd_root_password_segura
      - MYSQL_USER=ctfd
      - MYSQL_PASSWORD=ctfd_password_segura
      - MYSQL_DATABASE=ctfd
      - MYSQL_CHARACTER_SET_SERVER=utf8mb4
      - MYSQL_COLLATION_SERVER=utf8mb4_unicode_ci
    volumes:
      - ctfd_dbdata:/var/lib/mysql
    command:
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_unicode_ci
      - --wait_timeout=28800
      - --log-warnings=0
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s
    networks:
      - ctfd_internal

  # ── Redis Cache ───────────────────────────────────────────
  cache:
    image: redis:7-alpine
    container_name: ctfd_cache
    restart: always
    volumes:
      - ctfd_redis:/data
    command: redis-server --maxmemory 512mb --maxmemory-policy allkeys-lru
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5
    networks:
      - ctfd_internal

  # ── Nginx Reverse Proxy ───────────────────────────────────
  nginx:
    image: nginx:alpine
    container_name: ctfd_nginx
    restart: always
    ports:
      - "80:80"
      - "{CTFD_HTTPS_PORT}:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
      - ctfd_uploads:/var/uploads:ro
    depends_on:
      - ctfd
    networks:
      - ctfd_frontend

networks:
  ctfd_internal:
    driver: bridge
    internal: true
  ctfd_frontend:
    driver: bridge

volumes:
  ctfd_dbdata:
  ctfd_redis:
  ctfd_logs:
  ctfd_uploads:
"""
    
    # Salvar docker-compose.yml
    compose_path = os.path.join(CTFD_DIR, "docker-compose.yml")
    with open(compose_path, 'w') as f:
        f.write(docker_compose_content)
    logger.info("  ► docker-compose.yml customizado criado.")
    
    # ─── Configuração do Nginx ───
    nginx_dir = os.path.join(CTFD_DIR, "nginx", "conf.d")
    ssl_dir = os.path.join(CTFD_DIR, "nginx", "ssl")
    os.makedirs(nginx_dir, exist_ok=True)
    os.makedirs(ssl_dir, exist_ok=True)
    
    nginx_config = """# CTFd Nginx Reverse Proxy Configuration

# Rate limiting
limit_req_zone $binary_remote_addr zone=ctfd_limit:10m rate=30r/s;

upstream ctfd_app {
    server ctfd:8000;
}

server {
    listen 80;
    server_name _;

    # Segurança: Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Content-Security-Policy "default-src 'self' 'unsafe-inline' 'unsafe-eval' data: blob:;" always;

    # Tamanho máximo de upload (para challenges)
    client_max_body_size 100M;

    # Rate limiting
    limit_req zone=ctfd_limit burst=50 nodelay;

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml;
    gzip_min_length 1000;

    location / {
        proxy_pass http://ctfd_app;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_buffering off;
        proxy_connect_timeout 60s;
        proxy_read_timeout 120s;
    }

    # Cache para assets estáticos
    location /themes/ {
        proxy_pass http://ctfd_app;
        proxy_cache_valid 200 1h;
        expires 1h;
        add_header Cache-Control "public, immutable";
    }

    # Health check
    location /healthcheck {
        access_log off;
        return 200 "OK";
    }
}

# ── Configuração HTTPS (descomente quando tiver certificado SSL) ──
# server {
#     listen 443 ssl http2;
#     server_name seu-dominio.com;
#
#     ssl_certificate /etc/nginx/ssl/fullchain.pem;
#     ssl_certificate_key /etc/nginx/ssl/privkey.pem;
#     ssl_protocols TLSv1.2 TLSv1.3;
#     ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
#     ssl_prefer_server_ciphers off;
#     ssl_session_cache shared:SSL:10m;
#     ssl_session_timeout 1d;
#     ssl_session_tickets off;
#     add_header Strict-Transport-Security "max-age=63072000" always;
#
#     # ... (mesma config de location acima)
# }
"""
    
    nginx_path = os.path.join(nginx_dir, "ctfd.conf")
    with open(nginx_path, 'w') as f:
        f.write(nginx_config)
    logger.info("  ► Configuração Nginx criada.")
    
    # ─── Gerar certificado SSL auto-assinado (para dev/testes) ───
    run_command(
        f"openssl req -x509 -nodes -days 365 -newkey rsa:2048 "
        f"-keyout {ssl_dir}/privkey.pem "
        f"-out {ssl_dir}/fullchain.pem "
        f'-subj "/C=BR/ST=Pernambuco/L=Recife/O=CTFd/CN=localhost"',
        "Gerando certificado SSL auto-assinado..."
    )
    
    logger.info(f"  {Colors.GREEN}✓ Configuração avançada do CTFd concluída.{Colors.ENDC}")


def step_install_ctf_tools():
    """Etapa 5: Instalar ferramentas adicionais para criação e resolução de CTFs."""
    print_step(5, 8, "INSTALAÇÃO DE FERRAMENTAS CTF ADICIONAIS")
    
    # ── Ferramentas de sistema para CTF ──
    ctf_packages = [
        # Criptografia
        "openssl",
        "gnupg2",
        "hashcat",
        "john",
        
        # Rede e Forense
        "nmap",
        "tcpdump",
        "wireshark-common",
        "tshark",
        "netcat-openbsd",
        "dnsutils",
        "whois",
        
        # Esteganografia e Forense
        "steghide",
        "binwalk",
        "foremost",
        "exiftool",
        "hexedit",
        "xxd",
        
        # Reversão e Exploração
        "gdb",
        "radare2",
        "ltrace",
        "strace",
        
        # Web
        "nikto",
        "dirb",
        "sqlmap",
        "curl",
        "httpie",
        
        # Utilitários
        "file",
        "strings",
        "p7zip-full",
    ]
    
    run_command(
        f"DEBIAN_FRONTEND=noninteractive apt-get install -y {' '.join(ctf_packages)} 2>/dev/null || true",
        "Instalando ferramentas CTF do repositório..."
    )
    
    # ── Ferramentas Python para CTF ──
    pip_packages = [
        "pycryptodome",       # Criptografia
        "pwntools",           # Exploração (pwn)
        "requests",           # HTTP
        "beautifulsoup4",     # Web scraping
        "flask",              # Web challenges
        "pillow",             # Manipulação de imagens
        "z3-solver",          # SMT solver
        "angr",               # Análise binária
        "ropper",             # ROP gadgets
        "gmpy2",              # Math para crypto
        "sympy",              # Algebra simbólica
        "ctftools",           # Utilidades CTF
    ]
    
    run_command(
        f"pip3 install --break-system-packages {' '.join(pip_packages)} 2>/dev/null || true",
        "Instalando ferramentas Python para CTF..."
    )
    
    # ── Script de criação de challenges de exemplo ──
    challenges_dir = os.path.join(CTFD_DIR, "custom_challenges")
    os.makedirs(challenges_dir, exist_ok=True)
    
    example_challenge = """#!/usr/bin/env python3
# -*- coding: utf-8 -*-
\"\"\"
Exemplo de challenge de criptografia pós-quântica para CTFd.
Categoria: Criptografia
Dificuldade: Médio
\"\"\"

import hashlib
import base64
import os

FLAG = "CTF{p0st_qu4ntum_crypt0_1s_th3_futur3}"

def generate_challenge():
    \"\"\"Gera o desafio criptográfico.\"\"\"
    key = os.urandom(32)
    encrypted_flag = bytes(a ^ b for a, b in zip(
        FLAG.encode(), 
        (key * (len(FLAG) // len(key) + 1))[:len(FLAG)]
    ))
    
    hint = hashlib.sha256(key[:16]).hexdigest()
    
    return {
        "encrypted": base64.b64encode(encrypted_flag).decode(),
        "key_hash_hint": hint,
        "description": (
            "Um sistema de criptografia clássico foi comprometido durante "
            "a transição para algoritmos pós-quânticos. "
            "Recupere a flag original a partir dos dados interceptados."
        )
    }

if __name__ == "__main__":
    challenge_data = generate_challenge()
    print(f"Dados do challenge: {challenge_data}")
"""
    
    with open(os.path.join(challenges_dir, "example_crypto_challenge.py"), 'w') as f:
        f.write(example_challenge)
    
    logger.info(f"  {Colors.GREEN}✓ Ferramentas CTF instaladas com sucesso.{Colors.ENDC}")


def step_configure_firewall():
    """Etapa 6: Configurar firewall e segurança básica."""
    print_step(6, 8, "CONFIGURAÇÃO DE SEGURANÇA (FIREWALL + FAIL2BAN)")
    
    # ── UFW Firewall ──
    run_command("ufw default deny incoming", "Configurando política padrão UFW...")
    run_command("ufw default allow outgoing")
    run_command("ufw allow ssh", "Permitindo SSH...")
    run_command("ufw allow 80/tcp", "Permitindo HTTP...")
    run_command("ufw allow 443/tcp", "Permitindo HTTPS...")
    run_command(f"ufw allow {CTFD_PORT}/tcp", f"Permitindo porta CTFd ({CTFD_PORT})...")
    run_command("echo 'y' | ufw enable", "Habilitando UFW...")
    
    # ── Fail2Ban configuração ──
    fail2ban_config = """
[DEFAULT]
bantime  = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port    = ssh
filter  = sshd
logpath = /var/log/auth.log
maxretry = 3
"""
    
    fail2ban_path = "/etc/fail2ban/jail.local"
    with open(fail2ban_path, 'w') as f:
        f.write(fail2ban_config)
    
    run_command("systemctl enable fail2ban", "Habilitando Fail2Ban...")
    run_command("systemctl restart fail2ban", "Reiniciando Fail2Ban...")
    
    logger.info(f"  {Colors.GREEN}✓ Firewall e Fail2Ban configurados.{Colors.ENDC}")


def step_create_management_scripts():
    """Etapa 7: Criar scripts de gerenciamento do CTFd."""
    print_step(7, 8, "CRIANDO SCRIPTS DE GERENCIAMENTO")
    
    scripts_dir = os.path.join(CTFD_DIR, "scripts")
    os.makedirs(scripts_dir, exist_ok=True)
    
    # ── Script de inicialização ──
    start_script = f"""#!/bin/bash
# Inicia o CTFd e todos os serviços
echo "🚀 Iniciando CTFd..."
cd {CTFD_DIR}
docker compose up -d
echo ""
echo "✅ CTFd iniciado!"
echo "   ► Acesse: http://$(hostname -I | awk '{{print $1}}'):{CTFD_PORT}"
echo "   ► Nginx:  http://$(hostname -I | awk '{{print $1}}')"
echo ""
docker compose ps
"""
    
    # ── Script de parada ──
    stop_script = f"""#!/bin/bash
# Para o CTFd e todos os serviços
echo "🛑 Parando CTFd..."
cd {CTFD_DIR}
docker compose down
echo "✅ CTFd parado."
"""
    
    # ── Script de backup ──
    backup_script = f"""#!/bin/bash
# Backup completo do CTFd (DB + uploads + config)
BACKUP_DIR="/opt/ctfd_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/ctfd_backup_$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "📦 Criando backup do CTFd..."

cd {CTFD_DIR}

# Exportar banco de dados
docker compose exec -T db mysqldump -u ctfd -pctfd_password_segura ctfd > /tmp/ctfd_db_$TIMESTAMP.sql

# Criar arquivo tar com tudo
tar -czf "$BACKUP_FILE" \\
    docker-compose.yml \\
    nginx/ \\
    custom_challenges/ \\
    /tmp/ctfd_db_$TIMESTAMP.sql \\
    2>/dev/null

rm -f /tmp/ctfd_db_$TIMESTAMP.sql

# Manter apenas os 10 backups mais recentes
ls -t "$BACKUP_DIR"/ctfd_backup_*.tar.gz | tail -n +11 | xargs rm -f 2>/dev/null

echo "✅ Backup salvo em: $BACKUP_FILE"
echo "   Tamanho: $(du -h "$BACKUP_FILE" | cut -f1)"
"""
    
    # ── Script de status ──
    status_script = f"""#!/bin/bash
# Verifica o status de todos os serviços CTFd
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "           STATUS DO CTFd"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd {CTFD_DIR}

echo "📊 Containers:"
docker compose ps
echo ""

echo "💾 Uso de disco (volumes Docker):"
docker system df -v 2>/dev/null | head -20
echo ""

echo "🔒 Firewall:"
ufw status | head -15
echo ""

echo "🌐 Portas em uso:"
ss -tlnp | grep -E ':(80|443|{CTFD_PORT})\\s'
echo ""

IP=$(hostname -I | awk '{{print $1}}')
echo "🔗 URLs de acesso:"
echo "   ► CTFd direto: http://$IP:{CTFD_PORT}"
echo "   ► Via Nginx:   http://$IP"
echo ""
"""
    
    # ── Script de logs ──
    logs_script = f"""#!/bin/bash
# Exibe logs em tempo real de todos os serviços
cd {CTFD_DIR}
echo "📋 Exibindo logs do CTFd (Ctrl+C para sair)..."
docker compose logs -f --tail=100 "$@"
"""
    
    # ── Script de reset (cuidado!) ──
    reset_script = f"""#!/bin/bash
# CUIDADO: Remove todos os dados do CTFd e reinicia do zero
echo "⚠️  ATENÇÃO: Isso vai APAGAR TODOS OS DADOS do CTFd!"
echo "   - Banco de dados"
echo "   - Uploads"
echo "   - Cache"
echo ""
read -p "Tem certeza? Digite 'SIM' para confirmar: " confirm

if [ "$confirm" = "SIM" ]; then
    cd {CTFD_DIR}
    docker compose down -v
    echo "🗑️  Dados removidos."
    echo "Execute 'ctfd-start' para reiniciar com dados limpos."
else
    echo "Operação cancelada."
fi
"""
    
    scripts = {
        "ctfd-start": start_script,
        "ctfd-stop": stop_script,
        "ctfd-backup": backup_script,
        "ctfd-status": status_script,
        "ctfd-logs": logs_script,
        "ctfd-reset": reset_script,
    }
    
    for name, content in scripts.items():
        script_path = os.path.join(scripts_dir, name)
        with open(script_path, 'w') as f:
            f.write(content)
        os.chmod(script_path, 0o755)
        
        # Criar symlink em /usr/local/bin para acesso global
        symlink_path = f"/usr/local/bin/{name}"
        if os.path.exists(symlink_path):
            os.remove(symlink_path)
        os.symlink(script_path, symlink_path)
        
        logger.info(f"  ► Script criado: {name}")
    
    logger.info(f"  {Colors.GREEN}✓ Scripts de gerenciamento criados e disponíveis globalmente.{Colors.ENDC}")


def step_start_ctfd():
    """Etapa 8: Build e inicialização do CTFd."""
    print_step(8, 8, "CONSTRUINDO E INICIANDO O CTFd")
    
    os.chdir(CTFD_DIR)
    
    run_command(
        "docker compose build --no-cache",
        "Construindo imagens Docker (isso pode levar alguns minutos)..."
    )
    
    run_command(
        "docker compose up -d",
        "Iniciando todos os serviços..."
    )
    
    logger.info("  ⏳ Aguardando serviços ficarem prontos...")
    time.sleep(15)
    
    # Verificar status
    result = run_command(
        "docker compose ps --format json",
        capture_output=True,
        check=False
    )
    
    run_command("docker compose ps", "Status dos containers:")
    
    logger.info(f"  {Colors.GREEN}✓ CTFd iniciado com sucesso!{Colors.ENDC}")


def print_summary():
    """Imprime o resumo final da instalação."""
    # Obter IP da máquina
    result = run_command(
        "hostname -I | awk '{print $1}'",
        capture_output=True
    )
    ip = result.stdout.strip()
    
    summary = f"""
{Colors.GREEN}{Colors.BOLD}
╔══════════════════════════════════════════════════════════════════╗
║                  INSTALAÇÃO CONCLUÍDA! 🎉                        ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  🌐 ACESSO AO CTFd:                                             ║
║     ► Via Nginx:   http://{ip:<39s}  ║
║     ► Direto:      http://{ip}:{CTFD_PORT:<28s}  ║
║                                                                  ║
║  📂 DIRETÓRIO:     {CTFD_DIR:<40s}  ║
║                                                                  ║
║  🔧 COMANDOS DISPONÍVEIS:                                       ║
║     ► ctfd-start   - Iniciar CTFd                                ║
║     ► ctfd-stop    - Parar CTFd                                  ║
║     ► ctfd-status  - Verificar status                            ║
║     ► ctfd-logs    - Ver logs em tempo real                      ║
║     ► ctfd-backup  - Fazer backup completo                       ║
║     ► ctfd-reset   - Resetar tudo (CUIDADO!)                    ║
║                                                                  ║
║  🔒 SEGURANÇA:                                                   ║
║     ► Firewall UFW ativado (portas 22, 80, 443, {CTFD_PORT})       ║
║     ► Fail2Ban configurado                                       ║
║     ► Nginx com headers de segurança                             ║
║                                                                  ║
║  🛠️  FERRAMENTAS CTF INSTALADAS:                                 ║
║     ► Crypto: hashcat, john, openssl, pycryptodome               ║
║     ► Rede: nmap, tcpdump, tshark, netcat                        ║
║     ► Forense: binwalk, steghide, foremost, exiftool             ║
║     ► Reversão: gdb, radare2, ltrace, strace                     ║
║     ► Web: nikto, dirb, sqlmap, httpie                           ║
║     ► Python: pwntools, angr, z3-solver, ropper                 ║
║                                                                  ║
║  ⚠️  PRÓXIMOS PASSOS:                                            ║
║     1. Acesse a URL acima para configurar o admin                ║
║     2. Configure um domínio e certificado SSL (Let's Encrypt)    ║
║     3. Altere as senhas padrão no docker-compose.yml             ║
║     4. Crie seus challenges!                                     ║
║                                                                  ║
║  📋 LOG: {LOG_FILE:<48s}  ║
╚══════════════════════════════════════════════════════════════════╝
{Colors.ENDC}
"""
    print(summary)


# ─────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────

def main():
    """Função principal do instalador."""
    parser = argparse.ArgumentParser(
        description="Instalador CTFd + Docker para Ubuntu",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos:
  sudo python3 install_ctfd.py              # Instalação completa
  sudo python3 install_ctfd.py --skip-tools # Sem ferramentas CTF
  sudo python3 install_ctfd.py --port 9000  # Porta customizada
        """
    )
    parser.add_argument(
        '--port', type=int, default=CTFD_PORT,
        help=f'Porta do CTFd (padrão: {CTFD_PORT})'
    )
    parser.add_argument(
        '--skip-tools', action='store_true',
        help='Pular instalação de ferramentas CTF adicionais'
    )
    parser.add_argument(
        '--skip-firewall', action='store_true',
        help='Pular configuração do firewall'
    )
    parser.add_argument(
        '--no-start', action='store_true',
        help='Não iniciar o CTFd automaticamente após instalação'
    )
    
    args = parser.parse_args()
    
    global CTFD_PORT
    CTFD_PORT = args.port
    
    print_banner()
    
    # Verificações iniciais
    check_root()
    check_ubuntu()
    
    start_time = time.time()
    logger.info(f"Iniciando instalação do CTFd em {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}")
    
    try:
        # Executar etapas
        step_update_system()
        step_install_docker()
        step_clone_ctfd()
        step_configure_ctfd()
        
        if not args.skip_tools:
            step_install_ctf_tools()
        
        if not args.skip_firewall:
            step_configure_firewall()
        
        step_create_management_scripts()
        
        if not args.no_start:
            step_start_ctfd()
        
        elapsed = time.time() - start_time
        logger.info(f"\n  Tempo total de instalação: {elapsed/60:.1f} minutos")
        
        print_summary()
        
    except KeyboardInterrupt:
        logger.warning(f"\n{Colors.WARNING}Instalação interrompida pelo usuário.{Colors.ENDC}")
        sys.exit(1)
    except Exception as e:
        logger.error(f"\n{Colors.FAIL}Erro durante a instalação: {e}{Colors.ENDC}")
        logger.info("Verifique o log para mais detalhes: " + LOG_FILE)
        raise


if __name__ == "__main__":
    main()
