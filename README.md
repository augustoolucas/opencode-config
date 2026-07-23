# opencode-config

Personal configuration for [opencode](https://opencode.ai). For agent workflow documentation, see [YACAO](https://github.com/augustoolucas/yacao).

## Install

Give this repo URL to your opencode agent:

```
git clone https://github.com/augustoolucas/opencode-config ~/.config/opencode
cd ~/.config/opencode && npm install
```

Then install the agent orchestration layer:

> See [YACAO](https://github.com/augustoolucas/yacao) — your agent will follow the install instructions there to set up the orchestrator and subagents.

After installing YACAO, the agent symlinks will connect automatically. Restart opencode.

## Structure

```
.
├── opencode.jsonc         # Main config (providers, plugins, agents, model routing)
├── package.json           # Plugin dependencies
├── tsconfig.json          # TypeScript config
├── tui.json               # TUI plugin overrides (tui-preferences.jsonc also exists, gitignored)
├── AGENTS.md              # Global agent rules and delegation guidelines
├── agents/                # Agent definitions (orchestrator + 4 subagents, via symlink to YACAO)
│   ├── orchestrator.md
│   ├── planner.md
│   ├── builder.md
│   ├── reviewer.md
│   └── question.md
├── skills/                # Reusable workflow skills
│   ├── worktrees/         # Git worktree lanes for isolated parallel work
│   ├── reflect/           # Session archaeology and workflow analysis
│   ├── pythonic-quality/  # Python code quality patterns
│   ├── skill-creator/     # Skill creation guide
│   └── task-management/   # Feature subtask tracking CLI
├── scripts/
└── commands/              # Custom slash commands
    ├── pr-review.md
    └── patch-context-mode.md
```

## Environment Variables

The CommandCode provider requires an API key:

```bash
export COMMANDCODE_API_KEY="your-key-here"
```

## Plugins

- **@cortexkit/opencode-magic-context** — long-term memory across sessions
- **commandcode-go-opencode-provider** — CommandCode model provider

## Other features

- **LSP server** enabled for in-editor diagnostics
- **MCP CodeGraph** — semantic code exploration via `codegraph_explore`
- **compaction** — auto disabled, prune disabled (manual context management via Magic Context)
