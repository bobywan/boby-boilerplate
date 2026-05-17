#!/usr/bin/env bash
# sync-boilerplate.sh
# Synchronise les fichiers de config depuis boby-boilerplate vers ce projet.
# À lancer depuis la racine du projet à synchroniser.
#
# Usage :
#   ./scripts/sync-boilerplate.sh           # branche main
#   BRANCH=feat/xxx ./scripts/sync-boilerplate.sh  # branche custom

set -euo pipefail

# Envelopper dans main() : bash parse la fonction entièrement en mémoire,
# ce qui permet au script de se mettre à jour sans causer de crash.
main() {
  local REPO="bobywan/boby-boilerplate"
  local BRANCH="${BRANCH:-main}"
  local BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

  local reset="\033[0m" bold="\033[1m" green="\033[32m"
  local yellow="\033[33m" red="\033[31m" dim="\033[2m"

  # Détection Next.js
  local is_nextjs=false
  if ls next.config.* &>/dev/null 2>&1 || ([ -f "package.json" ] && grep -q '"next"' package.json); then
    is_nextjs=true
  fi

  echo ""
  if [ "$is_nextjs" = true ]; then
    echo -e "${bold}  Sync depuis ${yellow}${REPO}${reset}${bold} (${BRANCH}) — mode Next.js${reset}"
  else
    echo -e "${bold}  Sync depuis ${yellow}${REPO}${reset}${bold} (${BRANCH}) — mode universel${reset}"
  fi
  echo ""

  local errors=0

  # Fichiers universels
  # Note : sync-boilerplate.sh lui-même n'est pas auto-mis à jour pour éviter
  # un bug de lecture de fichier remplacé en cours d'exécution. Pour le mettre
  # à jour manuellement : curl -fsSL ${BASE_URL}/scripts/sync-boilerplate.sh -o scripts/sync-boilerplate.sh
  local files=(
    "biome.json"
    ".nvmrc"
    ".vscode/settings.json"
    ".vscode/extensions.json"
    ".cursor/rules/project-stack.mdc"
    ".cursor/rules/typescript-react.mdc"
    ".cursor/rules/tailwind.mdc"
    ".cursor/skills/boilerplate-conventions/SKILL.md"
    "scripts/init-project.sh"
  )

  # Fichiers Next.js uniquement
  if [ "$is_nextjs" = true ]; then
    files+=(
      "tsconfig.json"
      ".github/workflows/ci.yml"
      ".cursor/rules/nextjs-app-router.mdc"
      "scripts/dev-start.mjs"
    )
  fi

  for file in "${files[@]}"; do
    local dir
    dir="$(dirname "$file")"
    [ "$dir" != "." ] && mkdir -p "$dir"
    if curl -fsSL "${BASE_URL}/${file}" -o "$file" 2>/dev/null; then
      echo -e "  ${green}✓${reset} ${file}"
    else
      echo -e "  ${red}✗${reset} ${file} ${dim}(erreur — fichier introuvable sur ${BRANCH})${dim}"
      errors=$((errors + 1))
    fi
  done

  echo ""

  # Fichier .code-workspace renommé selon le projet courant
  local project_name workspace_target
  project_name="$(basename "$PWD")"
  workspace_target="${project_name}.code-workspace"
  if curl -fsSL "${BASE_URL}/boby-boilerplate.code-workspace" -o "$workspace_target" 2>/dev/null; then
    for old_ws in ./*.code-workspace; do
      [ "$old_ws" = "./${workspace_target}" ] && continue
      rm -f "$old_ws"
      echo -e "  ${dim}~${reset} ${old_ws#./} supprimé (remplacé)"
    done
    echo -e "  ${green}✓${reset} ${workspace_target}"
  else
    echo -e "  ${red}✗${reset} .code-workspace ${dim}(erreur de téléchargement)${dim}"
    errors=$((errors + 1))
  fi

  echo ""

  # Merge des scripts boilerplate dans package.json local
  if [ -f "package.json" ] && command -v node &>/dev/null; then
    local tmp_pkg
    tmp_pkg="$(mktemp)"
    if curl -fsSL "${BASE_URL}/package.json" -o "$tmp_pkg" 2>/dev/null; then
      node - "$tmp_pkg" <<'EOF'
const fs = require("fs");
const [,, remotePath] = process.argv;
const local = JSON.parse(fs.readFileSync("package.json", "utf8"));
const remote = JSON.parse(fs.readFileSync(remotePath, "utf8"));
const merged = { ...local, scripts: { ...local.scripts, ...remote.scripts } };
fs.writeFileSync("package.json", JSON.stringify(merged, null, 2) + "\n");
EOF
      echo -e "  ${green}✓${reset} package.json : scripts mis à jour"
    else
      echo -e "  ${yellow}!${reset} package.json : impossible de récupérer le package.json distant"
    fi
    rm -f "$tmp_pkg"
  fi

  echo ""

  if [ "$errors" -eq 0 ]; then
    echo -e "  ${bold}Sync terminé.${reset} Pense à relancer ${yellow}npm install${reset} si les configs ont changé."
  else
    echo -e "  ${bold}Sync terminé avec ${red}${errors} erreur(s)${reset}. Vérifie les fichiers marqués ✗."
  fi

  echo ""
}

main "$@"
