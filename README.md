🛠️ domain-info

**domain-info** es una herramienta CLI en Bash para obtener información actualizada de dominios, diseñada para **soporte técnico de hosting, DNS y correo**.

A diferencia del comando `whois`, esta herramienta:
- Usa **RDAP (JSON moderno)** como fuente principal
- Consulta **DNS en vivo** para NS reales
- Tiene **fallback WHOIS** sanitizado
- Nunca se rompe por errores de formato o acentos
- Presenta la información de forma clara y legible


## 🚀 Características

- Obtiene **NS reales publicados en DNS**
- Fecha de **registro** y **expiración**
- **Estado del dominio** (active / clientHold / serverHold / etc.)
- **Proveedor / Registrador**
- Normaliza estados EPP (`ok → active`)
- Salida bonita en terminal
- Modo `--json` para integración con otros scripts
- Compatible con **macOS y Linux**


## 📦 Requisitos

- `bash`
- `curl`
- `jq`
- `dig`
- (opcional) `whois` para fallback

### Instalar dependencias

**macOS (Homebrew)**:
```bash```
brew install jq bind

⚡ Instalación rápida

curl -fsSL https://raw.githubusercontent.com/deivy-ramirez/domain-info-cli/main/install.sh | bash

Luego recarga tu terminal o ejecuta:

source ~/.zshrc
o
source ~/.bashrc

🖥️ Uso básico

domain-info google.com

También acepta:

- domain-info https://midominio.com/ruta
- domain-info usuario@midominio.com

🧠 ¿Por qué no usar solo whois?

El comando whois:

- Cambia formatos según registrador
- Tiene bloqueos y rate-limit
- No siempre muestra datos completos

domain-info combina:

- RDAP moderno
- DNS real en vivo
- WHOIS saneado como respaldo

Resultado: más confiable y estable para soporte técnico.

🛠️ Solución de problemas

dig: command not found
- Instala bind-utils:
  brew install bind

jq: command not found
- Instala jq:
  brew install jq

👨‍💻 Autor

**Deivy Steven Ramirez Molina**
