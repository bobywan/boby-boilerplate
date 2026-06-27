# Contexte projet

> Mets à jour ce fichier à chaque fois que le contexte du projet évolue significativement.
> Il est lu automatiquement par les agents IA au début des sessions de travail.

---

## Objectif du projet

<!-- Décris en 2-3 phrases ce que ce projet fait et pourquoi il existe. -->

boby-boilerplate est un template Next.js (App Router) fullstack, prêt à l'emploi.
Il sert de base réutilisable pour démarrer rapidement de nouveaux projets web modernes
avec une configuration IA avancée intégrée.

---

## Stack technique

| Outil | Version | Rôle |
|-------|---------|------|
| Next.js | 16 (App Router) | Framework fullstack |
| React | 19 | UI |
| TypeScript | 5 (strict) | Typage |
| Tailwind CSS | v4 | Styles (via CSS, sans config file) |
| BiomeJS | v2 | Lint + format (remplace ESLint + Prettier) |
| Node.js | 24 LTS | Runtime |

---

## Architecture

```
app/                    # App Router — pages, layouts, routes
public/                 # Assets statiques
scripts/                # Scripts utilitaires (init, sync, dev)
.cursor/                # Configuration Cursor + règles IA
.ai/                    # Mémoire projet IA (ce dossier)
.github/workflows/      # CI GitHub Actions
```

**Principes :**
- Server Components par défaut — `"use client"` uniquement si nécessaire
- Imports internes via l'alias `@/`
- Pas de `var`, pas d'`any` explicite

---

## Contraintes métier

<!-- Liste les contraintes non techniques qui influencent le code. -->

- Le boilerplate doit rester utilisable pour plusieurs types de projets : web apps, APIs, scripts, Docker
- Aucune dépendance inutile — préférer les solutions natives
- Configuration portable : pas de secrets hardcodés, tout via `.env.local`

---

## Outils IA configurés

| Outil | Rôle |
|-------|------|
| Context Mode | Serveur MCP — protection de la fenêtre de contexte, session persistante |
| Headroom | Serveur MCP — compression de contexte (60-95% de tokens économisés) |
| Serena | Serveur MCP — navigation symbolique IDE (find refs, rename cross-file, refactoring LSP) |
| Ponytail | Règle Cursor — mode "lazy senior dev" (YAGNI ladder) |
| Règles 00-06 | Règles Cursor — comportement de l'agent, qualité, sécurité, git, Docker |

---

## Points d'entrée importants

- `npm run dev` — lance le serveur de développement
- `npm run init-project` — initialise un nouveau projet depuis le boilerplate
- `npm run sync` — synchronise les configs depuis le boilerplate distant
- `npm run check` — lint + format + imports (BiomeJS)

---

## À compléter par le projet dérivé

Quand tu utilises ce boilerplate pour un nouveau projet, remplace ou complète les sections ci-dessus avec :
- L'objectif réel du projet
- Les dépendances supplémentaires installées
- Les contraintes métier spécifiques
- L'URL de production et les environnements
