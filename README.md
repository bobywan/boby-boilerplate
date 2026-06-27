# boby-boilerplate

[![CI](https://github.com/bobywan/boby-boilerplate/actions/workflows/ci.yml/badge.svg)](https://github.com/bobywan/boby-boilerplate/actions/workflows/ci.yml)
[![TypeScript](https://img.shields.io/badge/TypeScript-5-blue?logo=typescript)](https://www.typescriptlang.org/)
[![Next.js](https://img.shields.io/badge/Next.js-16-black?logo=next.js)](https://nextjs.org/)
[![Node](https://img.shields.io/badge/Node.js-24%20LTS-green?logo=node.js)](https://nodejs.org/)
[![Biome](https://img.shields.io/badge/Biome-lint%20%26%20format-60A5FA?logo=biome)](https://biomejs.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Boilerplate Next.js (App Router) fullstack, prêt à l'emploi pour démarrer un nouveau projet rapidement.

## Stack

| Outil      | Usage                        |
| ---------- | ---------------------------- |
| Next.js 16 | Framework fullstack          |
| TypeScript | Typage strict                |
| BiomeJS    | Lint + format (remplace ESLint + Prettier) |
| Node.js 24 | Runtime LTS                  |

## Démarrage rapide

```bash
# 1. Créer le projet depuis le boilerplate (sans historique git)
npx degit bobywan/boby-boilerplate mon-projet
cd mon-projet
git init

# 2. Utiliser la bonne version de Node (nvm ou fnm)
nvm use   # ou: fnm use

# 3. Installer les dépendances
npm install

# 4. Initialiser le projet (renomme le workspace, met à jour package.json)
npm run init-project

# 5. Copier les variables d'environnement
cp .env.example .env.local

# 6. Lancer le serveur de développement
npm run dev
```

L'application sera disponible sur [http://localhost:3000](http://localhost:3000).

## Mise à jour depuis le boilerplate

### Projet qui utilise déjà le boilerplate

```bash
npm run sync
```

### Projet existant sans le boilerplate (première fois)

Copie le script de sync dans le projet, puis lance-le :

```bash
mkdir -p scripts \
  && curl -fsSL https://raw.githubusercontent.com/bobywan/boby-boilerplate/main/scripts/sync-boilerplate.sh \
     -o scripts/sync-boilerplate.sh \
  && chmod +x scripts/sync-boilerplate.sh \
  && ./scripts/sync-boilerplate.sh
```

---

Le script télécharge uniquement les fichiers "infrastructure" depuis la branche `main` du boilerplate. Le code applicatif (`app/`, `next.config.ts`, `package.json`, `.env.example`, `README.md`) n'est jamais écrasé.

Pour pointer vers une autre branche :

```bash
BRANCH=feat/xxx npm run sync
```

> Après une sync, inspecte les changements avec `git diff` avant de commiter.

## Scripts disponibles

| Commande             | Description                              |
| -------------------- | ---------------------------------------- |
| `npm run dev`        | Lance le serveur de dev avec message de démarrage |
| `npm run build`      | Build de production                      |
| `npm run start`      | Démarre le serveur de production         |
| `npm run init-project` | Renomme le workspace et met à jour package.json |
| `npm run typecheck`  | Vérifie les types TypeScript             |
| `npm run sync`       | Synchronise les configs depuis le boilerplate |
| `npm run lint`       | Analyse le code avec Biome               |
| `npm run format`     | Formate le code avec Biome               |
| `npm run check`      | Lint + format + imports en une commande  |
| `npm run ci`         | Vérification CI (lecture seule)          |

## Structure du projet

```
.
├── .github/workflows/ci.yml   # GitHub Actions CI
├── .vscode/                   # Config VSCode / Cursor
├── app/                       # App Router Next.js
│   ├── error.tsx
│   ├── layout.tsx
│   ├── loading.tsx
│   ├── not-found.tsx
│   └── page.tsx
├── public/                    # Assets statiques
├── scripts/
│   ├── dev-start.mjs          # Message de démarrage
│   ├── init-project.sh        # Initialisation d'un nouveau projet
│   └── sync-boilerplate.sh    # Synchronisation depuis le boilerplate
├── .env.example               # Variables d'env (template)
├── .nvmrc                     # Node 24 LTS
├── biome.json                 # Config Biome (lint + format)
├── next.config.ts
├── tsconfig.json
└── boby-boilerplate.code-workspace
```

## Variables d'environnement

Copie `.env.example` vers `.env.local` et renseigne les valeurs :

```bash
cp .env.example .env.local
```

> Les fichiers `.env*` sont ignorés par git (sauf `.env.example`).

## AI Development Environment

Ce boilerplate embarque un environnement de développement IA complet, optimisé pour Cursor + Claude Sonnet.

### Outils configurés

| Outil | Rôle | Installation |
|-------|------|-------------|
| [Context Mode](https://github.com/mksglu/context-mode) | Serveur MCP — protection de la fenêtre de contexte, session persistante SQLite/FTS5 | `npm install -g context-mode` |
| [Headroom](https://github.com/chopratejas/headroom) | Serveur MCP — compression de contexte (60–95% de tokens économisés) | `pip install "headroom-ai[mcp]"` |
| [Serena](https://github.com/oraios/serena) | Serveur MCP — navigation symbolique IDE (find refs, rename, refactoring LSP) | `uv tool install -p 3.13 serena-agent` |
| [Ponytail](https://github.com/DietrichGebert/ponytail) | Règle Cursor — YAGNI ladder, code minimal et efficace | Intégré (aucune installation) |

### Prérequis machine (une seule fois)

```bash
# Context Mode — serveur MCP de gestion de contexte
npm install -g context-mode

# Headroom — compression de contexte (Python 3.10+ requis)
pip install "headroom-ai[mcp]"

# Serena — navigation symbolique IDE (uv requis : https://docs.astral.sh/uv/getting-started/installation/)
uv tool install -p 3.13 serena-agent
```

### Vérification

```bash
# Vérifier Context Mode
context-mode doctor

# Vérifier Headroom
headroom mcp status

# Vérifier Serena
serena --version
```

Dans Cursor, ouvre **Settings → MCP** et confirme que `context-mode`, `headroom` et `serena` sont connectés.

### Règles Cursor actives

Le dossier `.cursor/rules/` contient un ensemble de règles adaptées au développement avec Claude Sonnet :

| Fichier | Scope | Description |
|---------|-------|-------------|
| `00-general.mdc` | Toujours actif | Analyse avant d'agir, intervention minimale, respect des conventions |
| `01-code-quality.mdc` | `*.ts`, `*.tsx` | TypeScript strict, BiomeJS, pas de commentaires triviaux |
| `02-architecture.mdc` | Toujours actif | Server Components, App Router, structure des dossiers |
| `03-git-workflow.mdc` | `.git*` | Commits atomiques, messages clairs, branches |
| `04-security.mdc` | `*.ts`, `*.tsx` | Secrets, validation des entrées, headers HTTP |
| `05-documentation.mdc` | `*.ts`, `*.md` | Quoi et comment documenter |
| `06-docker.mdc` | `Dockerfile*`, `compose*` | Multi-stage builds, sécurité, Compose |
| `context-mode.mdc` | Toujours actif | Routing MCP — protège la fenêtre de contexte |
| `ponytail.mdc` | Toujours actif | YAGNI ladder — génère le minimum de code qui fonctionne |
| `project-stack.mdc` | Toujours actif | Stack technique et règles absolues du projet |
| `nextjs-app-router.mdc` | `app/**` | Conventions App Router, data fetching, metadata |
| `tailwind.mdc` | `*.tsx`, `*.css` | Tailwind v4 sans fichier de config |
| `typescript-react.mdc` | `*.ts`, `*.tsx` | Fonctions nommées, gestion d'erreurs, conventions de nommage |

### Mémoire projet IA

Le dossier `.ai/` contient la mémoire persistante du projet pour les agents :

```
.ai/
├── README.md            # Guide d'utilisation
├── project-context.md   # Objectif, stack, architecture, contraintes
└── decisions.md         # Journal des décisions d'architecture
```

Mets à jour ces fichiers au fil du projet pour que les agents comprennent le contexte sans longues explications en début de session.

### Comment utiliser avec Cursor

1. Cloner le boilerplate et installer les dépendances (`npm install`)
2. Installer les prérequis machine (`context-mode`, `headroom`, `serena`)
3. Ouvrir le projet dans Cursor — les règles et MCP sont activés automatiquement
4. Remplir `.ai/project-context.md` avec le contexte de ton projet
5. L'agent lit automatiquement les règles `.cursor/rules/` et la mémoire `.ai/` à chaque session

## Licence

MIT
