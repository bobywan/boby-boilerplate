# Journal des décisions d'architecture

> Documente ici toute décision structurelle non triviale.
> Format : date ISO, titre court, contexte, décision, alternatives écartées, conséquences.
> Consulté automatiquement par les agents IA pour éviter de remettre en question les choix passés.

---

## [2026-06-27] Choix de BiomeJS v2 comme unique outil de lint/format

**Contexte :** Le projet a besoin d'un outil de lint et de format. ESLint + Prettier est la stack traditionnelle mais implique deux outils, deux configs, et des conflits fréquents entre les deux.

**Décision :** BiomeJS v2 remplace à la fois ESLint et Prettier — un seul outil, une seule config (`biome.json`), une seule commande (`npm run check`).

**Alternatives écartées :**
- ESLint + Prettier : deux outils à maintenir, conflits de règles, plus lent
- oxlint : performant mais moins mature, pas de formatter intégré

**Conséquences :** Configuration plus simple, CI plus rapide. Quelques règles ESLint avancées non disponibles dans Biome (acceptable pour ce cas d'usage).

---

## [2026-06-27] Tailwind CSS v4 sans fichier de configuration

**Contexte :** Tailwind v4 introduit une approche radicalement différente — la configuration se fait via CSS (directives `@theme` dans `globals.css`) et non via `tailwind.config.js`.

**Décision :** Pas de `tailwind.config.js` ni `tailwind.config.ts`. Thème et customisations directement dans `app/globals.css`.

**Alternatives écartées :**
- Garder Tailwind v3 avec config file : moins moderne, pas aligné avec l'écosystème actuel

**Conséquences :** Moins de fichiers de config. Nécessite de connaître la syntaxe `@theme` de Tailwind v4.

---

## [2026-06-27] Intégration Context Mode + Headroom (double MCP)

**Contexte :** Deux serveurs MCP de gestion de contexte sont configurés : `headroom` (compression) et `context-mode` (sandbox, session persistante, FTS5).

**Décision :** Les deux coexistent — ils couvrent des besoins complémentaires. Headroom compresse les payloads entrants, Context Mode gère la persistance de session et les outils sandbox.

**Alternatives écartées :**
- Context Mode seul : perd la compression Headroom déjà en place
- Headroom seul : pas de session persistante, pas de sandbox tools

**Conséquences :** Deux prérequis machine à installer (`pip install headroom-ai[mcp]` et `npm install -g context-mode`). Documenter clairement dans le README.

---

## [2026-06-27] Ponytail comme règle Cursor (pas de plugin)

**Contexte :** Ponytail propose un plugin pour Claude Code, Codex, etc., mais pour Cursor il fonctionne uniquement via une règle `.mdc` copiée dans `.cursor/rules/`.

**Décision :** Copie directe de `.cursor/rules/ponytail.mdc` depuis le repo officiel. Aucune dépendance, aucun hook.

**Alternatives écartées :**
- Attendre un plugin Cursor natif : pas de date prévue
- Ne pas intégrer Ponytail : perdre le bénéfice du YAGNI ladder

**Conséquences :** Mise à jour manuelle de `ponytail.mdc` si le repo upstream change (vérifier périodiquement).

---

## [2026-06-27] Intégration Serena (navigation symbolique via LSP)

**Contexte :** Les outils Cursor natifs (Read, Grep, Shell) opèrent à niveau texte — trouver des références, renommer un symbole cross-file ou déplacer une fonction nécessite plusieurs étapes manuelles fragiles. Serena expose ces opérations comme outils MCP en s'appuyant sur le Language Server Protocol.

**Décision :** Ajout de Serena comme serveur MCP avec `--context=ide --project-from-cwd`. Le contexte `ide` est recommandé pour Cursor/Windsurf — il désactive les outils Serena qui doublonnent les capacités natives (Shell, Read, search) pour éviter la surcharge de contexte.

**Alternatives écartées :**
- Ne pas ajouter Serena : perd le rename cross-file symbolique, les find-references et le refactoring sûr
- Contexte `claude-code` : trop de doublons avec les outils Cursor natifs

**Conséquences :** Prérequis supplémentaire (`uv` + `serena-agent`). En contrepartie, l'agent peut renommer un symbole dans tout le projet en un appel MCP au lieu de plusieurs grep + replace successifs. Le projet TypeScript est supporté nativement via `typescript-language-server`.

<!-- Ajoute tes décisions ci-dessous en suivant le même format -->
