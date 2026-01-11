#!/usr/bin/env bash
set -euo pipefail

# =========================
# Config (EDITA ESTO)
# =========================
OWNER="deivy-ramirez"
REPO="domain-info"          # <-- nombre del repo en GitHub
BRANCH="main"
BIN_NAME="domain-info"      # <-- nombre del script ejecutable dentro del repo (archivo)
RAW_BASE="https://raw.githubusercontent.com/deivy-ramirez/domain-info-cli/main"


# =========================
# Rutas
# =========================
TARGET_DIR="${HOME}/.local/bin"
TARGET_PATH="${TARGET_DIR}/${BIN_NAME}"

# =========================
# Helpers
# =========================
msg()  { printf "%b\n" "$*"; }
ok()   { msg "✅ $*"; }
warn() { msg "⚠️  $*"; }
err()  { msg "❌ $*" >&2; }
die()  { err "$*"; exit 1; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || return 1
}

detect_shell_rc() {
  # Preferir shell actual, pero cubrir varios
  local shell_name rc
  shell_name="$(basename "${SHELL:-bash}")"
  case "$shell_name" in
    zsh)  rc="${HOME}/.zshrc" ;;
    bash) rc="${HOME}/.bashrc" ;;
    *)    rc="${HOME}/.profile" ;;
  esac
  echo "$rc"
}

ensure_path_line() {
  local rc_file="$1"
  local line='export PATH="$HOME/.local/bin:$PATH"'

  # Crear archivo si no existe
  [[ -f "$rc_file" ]] || touch "$rc_file"

  # Ya existe?
  if grep -Fqs "$line" "$rc_file"; then
    ok "PATH ya estaba configurado en $rc_file"
    return 0
  fi

  echo "" >> "$rc_file"
  echo "# Added by ${BIN_NAME} installer" >> "$rc_file"
  echo "$line" >> "$rc_file"
  ok "Agregado ~/.local/bin al PATH en $rc_file"
}

install_deps_hint() {
  local os
  os="$(uname -s 2>/dev/null || echo "")"

  msg ""
  warn "Dependencias faltantes. Instálalas y vuelve a ejecutar el instalador."
  msg "Requeridas: curl, jq, dig"
  msg ""

  if [[ "$os" == "Darwin" ]]; then
    msg "macOS (Homebrew):"
    msg "  brew install jq"
    msg "  brew install bind   # para dig"
    msg ""
  else
    msg "Linux (ejemplos):"
    msg "  Debian/Ubuntu:"
    msg "    sudo apt update && sudo apt install -y jq dnsutils curl"
    msg "  CentOS/RHEL:"
    msg "    sudo yum install -y jq bind-utils curl"
    msg "  Fedora:"
    msg "    sudo dnf install -y jq bind-utils curl"
    msg ""
  fi
}

# =========================
# Checks
# =========================
need_cmd curl || die "curl no está instalado."
need_cmd jq   || { install_deps_hint; die "jq no está instalado."; }

# dig puede llamarse dig; si no está, damos hint
if ! need_cmd dig; then
  install_deps_hint
  die "dig no está instalado."
fi

# =========================
# Install
# =========================
mkdir -p "$TARGET_DIR"
ok "Directorio destino: $TARGET_DIR"

URL="${RAW_BASE}/${BIN_NAME}"

ok "Descargando ${BIN_NAME}..."
if ! curl -fsSL --connect-timeout 8 --max-time 25 "$URL" -o "$TARGET_PATH"; then
  die "No pude descargar: $URL (revisa OWNER/REPO/BRANCH y que el archivo exista)."
fi

chmod +x "$TARGET_PATH"
ok "Instalado: $TARGET_PATH"

# =========================
# PATH
# =========================
# Si ya está en PATH, perfecto. Si no, agregar a rc.
if command -v "$BIN_NAME" >/dev/null 2>&1; then
  ok "${BIN_NAME} ya está disponible en PATH"
else
  rc_file="$(detect_shell_rc)"
  ensure_path_line "$rc_file"
  warn "Recarga tu terminal o ejecuta:"
  msg "  source \"$rc_file\""
fi

# =========================
# Final
# =========================
msg ""
ok "Listo. Prueba:"
msg "  ${BIN_NAME} google.com"
msg "  ${BIN_NAME} --json google.com | jq"
