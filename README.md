# opencode-config

Personal configuration for [opencode](https://opencode.ai).

## Structure

```
.
├── opencode.json          # Main config (providers, plugins, agents, permissions)
├── package.json           # Plugin dependencies
├── dcp.jsonc              # Dynamic Context Pruning config
├── tui.json               # TUI plugin overrides
└── commands/
    └── pr-review.md       # Custom /pr-review command
```

## Setup

```bash
git clone git@github.com:augustoolucas/opencode-config.git ~/.config/opencode
cd ~/.config/opencode
bun install
```

## Environment Variables

The CommandCode provider requires an API key:

```bash
export COMMANDCODE_API_KEY="your-key-here"
```

## Plugins

- **@cortexkit/opencode-magic-context** — long-term memory across sessions
- **context-mode** — advanced context management
- **commandcode-go-opencode-provider** — CommandCode model provider

## Custom Commands

### `/pr-review`

Comprehensive PR review with severity classification, structural analysis, and verdict. Works with local diffs, specific commits, or branch comparisons.

```
/pr-review              # Review uncommitted changes
/pr-review HEAD~3       # Review last 3 commits
/pr-review main         # Review branch vs main
```
