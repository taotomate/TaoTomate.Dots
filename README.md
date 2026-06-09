# TaoTomate.Dots

Orquestador e instalador de configuraciones y directivas de agentes de Inteligencia Artificial (Antigravity, Claude Code, OpenCode y Hermes).

Este repositorio sincroniza tu configuración centralizada desde [agent-config](https://github.com/taotomate/agent-config) a través de **enlaces simbólicos (symlinks)** en Windows de forma automática y segura.

## Arquitectura

Para mantener un entorno limpio y desacoplado, este repositorio integra tu configuración general mediante un submódulo Git:

```
TaoTomate.Dots/
├── install.ps1          <- Script de instalación de symlinks
└── agent-config/        <- Submódulo apuntando a taotomate/agent-config
```

---

## Mapeos del Instalador

Al ejecutar `install.ps1`, el script realiza los siguientes enlaces simbólicos:

| Source (in `agent-config/`) | Destination (in User Profile) | Symlink Type | Target Agent / App |
|-----------------------------|-------------------------------|--------------|-------------------|
| `shared/` | `~/.gemini/config/skills/_shared` | Directory | Antigravity 2.0 / CLI |
| `skills/` (subcarpetas) | `~/.gemini/config/skills/*` | Directory | Antigravity 2.0 / CLI |
| `shared/agents.md` | `~/.clauderules` | Archivo | Claude Code |
| `shared/agents.md` | `~/.config/opencode/AGENTS.md` | Archivo | OpenCode CLI |
| `shared/agents.md` | `~/.hermes/SOUL.md` | Archivo | Hermes Agent |
| `skills/` (subcarpetas) | `~/.hermes/skills/*` | Directory | Hermes Agent |
| `.wezterm.lua` | `~/.wezterm.lua` | Archivo | WezTerm Emulator |
| `starship.toml` | `~/.config/starship.toml` | Archivo | Starship Prompt |

---

## Tipografías (Nerd Fonts)

La configuración de WezTerm requiere la fuente **Iosevka Nerd Font** para poder renderizar correctamente los glifos y el arte en la terminal.

### Instalación Manual de Fuentes en Windows:
1. Descargá el archivo zip oficial de **Iosevka Term Nerd Font** desde el sitio de [Nerd Fonts Downloads](https://www.nerdfonts.com/font-downloads) (buscá "Iosevka").
2. Extraé el zip descargado.
3. Seleccioná todos los archivos `.ttf` extraídos, hacé clic derecho y elegí **Instalar para todos los usuarios** (o **Instalar**).


---

## Requisitos

Para que Windows permita crear enlaces simbólicos sin requerir elevación de permisos, asegurate de tener activado el **Modo de Desarrollador (Developer Mode)**:
1. Ir a **Configuración > Privacidad y seguridad > Para desarrolladores**.
2. Activar el interruptor de **Modo de desarrollador**.

*Nota: Si no tenés activado el Modo de Desarrollador, deberás correr la terminal de PowerShell como Administrador para ejecutar el instalador.*

---

## Instrucciones de Instalación

1. Clona este repositorio y asegurate de inicializar los submódulos:
   ```powershell
   git clone --recursive https://github.com/taotomate/TaoTomate.Dots.git
   cd TaoTomate.Dots
   ```
2. Ejecuta el instalador:
   ```powershell
   .\install.ps1
   ```

El script se encargará de realizar un backup automático (con extensión `.bak_TIMESTAMP`) de cualquier directorio o archivo de configuración existente para que nunca pierdas datos previos.
