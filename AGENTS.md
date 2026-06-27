<!-- BEGIN:nextjs-agent-rules -->
# This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` before writing any code. Heed deprecation notices.
<!-- END:nextjs-agent-rules -->

<!-- BEGIN:ai-environment-rules -->
# AI Development Environment

## Project Memory

Before proposing structural changes, read:
- `.ai/project-context.md` — project objective, stack, constraints
- `.ai/decisions.md` — past architecture decisions (don't re-open without reason)

## MCP Servers

Three MCP servers are configured in `.cursor/mcp.json`:

- **context-mode** ([mksglu/context-mode](https://github.com/mksglu/context-mode)) — protects context window via sandbox tools. When available, use `ctx_*` tools instead of raw Read/Bash/WebFetch for data-heavy operations. See `.cursor/rules/context-mode.mdc` for routing rules.
- **headroom** — compresses context payloads (60–95% token savings).
- **serena** ([oraios/serena](https://github.com/oraios/serena)) — IDE-level symbolic tools. Use `find_symbol`, `find_referencing_symbols`, `rename_symbol`, `replace_symbol_body`, etc. for structural code operations instead of grep + manual replace.

## Active Cursor Rules

- `00-general.mdc` — analyze before acting, minimal intervention
- `01-code-quality.mdc` — TypeScript strict, BiomeJS, no unnecessary comments
- `02-architecture.mdc` — Server Components, App Router, folder structure
- `03-git-workflow.mdc` — atomic commits, branch naming
- `04-security.mdc` — secrets, input validation, HTTP headers
- `05-documentation.mdc` — what and how to document
- `06-docker.mdc` — Dockerfile and Compose conventions
- `context-mode.mdc` — context window protection rules
- `ponytail.mdc` — YAGNI ladder, minimal code generation
<!-- END:ai-environment-rules -->
