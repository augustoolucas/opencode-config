# opencode-config

Personal configuration for [opencode](https://opencode.ai). Uses the [small-opencode-orchestrator](https://github.com/tempont/small-opencode-orchestrator) multi-agent pattern with specialized subagents for planning, exploration, execution, and review.

## Structure

```
.
├── opencode.jsonc         # Main config (providers, plugins, agents, model routing)
├── package.json           # Plugin dependencies
├── tsconfig.json          # TypeScript config for plugin-src
├── tui.json               # TUI plugin overrides
├── AGENTS.md              # Global agent rules and delegation guidelines
├── dcp.jsonc              # Dynamic Context Pruning config
├── agents/                # Agent definitions (orchestrator + 3 subagents)
│   ├── orchestrator.md
│   ├── planner.md
│   ├── builder.md
│   └── reviewer.md
├── plugin-src/            # Custom plugins
│   └── plan-post-approval.ts
├── skills/                # Reusable workflow skills
│   ├── worktrees/         # Git worktree lanes for isolated parallel work
│   ├── reflect/           # Session archaeology and workflow analysis
│   ├── agent-delegation/  # Delegation routing decisions
│   ├── pythonic-quality/  # Python code quality patterns
│   ├── skill-creator/     # Skill creation guide
│   └── task-management/   # Feature subtask tracking CLI
└── commands/              # Custom slash commands
    ├── pr-review.md
    └── patch-context-mode.md
```

## Setup

```bash
git clone git@github.com:augustoolucas/opencode-config.git ~/.config/opencode
cd ~/.config/opencode
npm install
```

## Environment Variables

The CommandCode provider requires an API key:

```bash
export COMMANDCODE_API_KEY="your-key-here"
```

## Plugins

- **@cortexkit/opencode-magic-context** — long-term memory across sessions
- **commandcode-go-opencode-provider** — CommandCode model provider
- **plan-post-approval** — automated handoff after plan approval in orchestrator mode

## Agents

The **orchestrator** coordinates work through 3 subagents:

| Agent | Model | Role |
|---|---|---|
| orchestrator | deepseek-v4-pro | Coordinator — plans, delegates, reviews. No repo access. |
| planner | deepseek-v4-pro | Explores code + writes implementation plans |
| builder | deepseek-v4-pro | Implements scoped coding tasks |
| reviewer | deepseek-v4-pro | Validates diff against plan; checks bugs and regressions |

**Workflow:** orchestrator → planner (explore + plan) → builder (implement) → reviewer (validate).

## Skills

- **worktrees** — Git worktree lanes for isolated, parallel, or risky work
- **reflect** — Session archaeology: find repeated patterns and suggest reusable assets
- **agent-delegation** — Routing decisions for the 3-subagent workflow
- **pythonic-quality** — Python code quality and design patterns
- **skill-creator** — Guide for creating effective skills
- **task-management** — Feature subtask tracking CLI

## Other features

- **LSP server** enabled for in-editor diagnostics
- **MCP CodeGraph** — semantic code exploration via `codegraph_explore`
- **compaction** — auto disabled, prune disabled (manual context management via Magic Context)
