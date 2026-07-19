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
├── agents/                # Agent definitions (11 subagents + orchestrator)
│   ├── orchestrator.md
│   ├── plan-runner.md
│   ├── code-explorer.md
│   ├── code-executor.md
│   ├── code-reviewer.md
│   ├── docs-reviewer.md
│   ├── security-reviewer.md
│   ├── spec-critic.md
│   ├── test-verifier.md
│   ├── api-docs-researcher.md
│   └── host-security-investigator.md
├── plugin-src/            # Custom plugins
│   └── plan-post-approval.ts
├── skills/                # Reusable workflow skills
│   ├── worktrees/         # Git worktree lanes for isolated parallel work
│   ├── reflect/           # Session archaeology and workflow analysis
│   ├── agent-delegation/  # Delegation routing decisions
│   ├── pythonic-quality/  # Python code quality patterns
│   └── security-investigation/
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

The **orchestrator** is the default entry point for non-trivial work. It cannot edit files directly — it coordinates through specialized subagents:

| Agent | Model | Role |
|---|---|---|
| orchestrator | deepseek-v4-pro | Coordinator — plans, delegates, reviews. No repo access. |
| build (native) | deepseek-v4-pro | OpenCode default for simple tasks |
| plan (native) | deepseek-v4-pro | OpenCode default for planning |
| plan-runner | deepseek-v4-flash | Writes implementation plans |
| code-explorer | deepseek-v4-flash | Read-only codebase exploration |
| code-executor | deepseek-v4-flash | Implements scoped coding tasks |
| code-reviewer | deepseek-v4-flash | Reviews diffs for correctness |
| docs-reviewer | deepseek-v4-flash | Checks documentation impact |
| security-reviewer | deepseek-v4-flash | Identifies security risks |
| spec-critic | deepseek-v4-flash | Challenges plans before coding |
| test-verifier | deepseek-v4-flash | Runs tests, lint, type checking |
| api-docs-researcher | deepseek-v4-flash | Researches external API docs |
| host-security-investigator | deepseek-v4-flash | Audits infrastructure security |

**Workflow:** For non-trivial tasks, the orchestrator routes through plan → approve → execute → review phases. For simple tasks, switch to the native `build` agent.

## Skills

- **worktrees** — Git worktree lanes for isolated, parallel, or risky work
- **reflect** — Session archaeology: find repeated patterns and suggest reusable assets
- **agent-delegation** — Decision table for routing work to subagents
- **pythonic-quality** — Python code quality and design patterns

## Other features

- **LSP server** enabled for in-editor diagnostics
- **MCP CodeGraph** — semantic code exploration via `codegraph_explore`
- **compaction** — auto disabled, prune disabled (manual context management via Magic Context)
