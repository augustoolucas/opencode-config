# opencode-config

Personal [opencode](https://opencode.ai) setup: config, agent workflow, plugins, and MCP servers.

## Quick start

```bash
git clone https://github.com/augustoolucas/opencode-config ~/.config/opencode
cd ~/.config/opencode && npm install
```

1. Optional: export `COMMANDCODE_API_KEY` to use the CommandCode provider.
2. Restart opencode.

## What's inside

| File | Purpose |
| --- | --- |
| `opencode.jsonc` | Main config: providers, plugins, agents, MCP servers, permissions |
| `cli.json` | V2 CLI/TUI preferences (diff wrap, session view, animations, prompt editor) |
| `tui.json` | TUI plugin list |
| `package.json` | Plugin dependencies — run `npm install` after cloning |
| `tsconfig.json` | TypeScript config for local plugin/script development |
| `AGENTS.md` | Global agent rules |
| `commands/pr-review.md` | `/pr-review` command: PR review with verdict, runs read-only on the `plan` agent |
| `skills/git-surgeon/SKILL.md` | `git-surgeon` skill: non-interactive hunk-level git operations |
| `.gitignore` | Excludes local state, generated files, and personal agent files |
| `README.md` | This file |

## Highlights

- **Plugins**:
    - `yacao` — the agent workflow
  - `@cortexkit/opencode-magic-context` — long-term memory across sessions
  - `fast-opencode-compaction` — wip compaction, configured off (`options.enabled: false`)
  - `@jevvy/permissions` — auto-approval for harmless shell permission requests, configured off
- **MCP servers**: `codegraph` (`codegraph serve --mcp`) for semantic code exploration and `crw` (`crw-mcp`) for web access; permissions are pre-allowed for `codegraph_*` and `crw_*`.
- **Compaction**: built-in auto-compaction and pruning are off, as we use magic-context's.
- **Agent defaults**: `orchestrator` as default agent, subagent depth 2.
- **Other**: LSP enabled, `share` set to manual, autoupdate on.
- Works with **opencode V1 and V2**: V2 reads both `plugin` and `plugins`, and `cli.json` is the V2 CLI config.

## Optional dependencies

- `codegraph` CLI — required by the `codegraph` MCP server.
- `crw-mcp` — required by the `crw` MCP server; `CRW_API_URL` points it at the fastCRW service.

## Links

- [YACAO agent workflow](https://github.com/augustoolucas/yacao)
- [opencode](https://opencode.ai) — [docs](https://opencode.ai/docs)
