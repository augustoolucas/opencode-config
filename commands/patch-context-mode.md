---
description: Reapply context-mode tool-name prefix patch (workaround for ctx_search collision with magic-context)
agent: plan
subtask: true
---

## Purpose

Magic Context and Context Mode both register a tool named `ctx_search`. Opencode silently overwrites duplicates — the last registrant wins. This prefix ensures both coexist: `ctx_search` (magic-context) and `context-mode_ctx_search` (context-mode).

The patch is lost when context-mode updates.

## Steps

1. Run the patch script:
   ```bash
   bash ~/.config/opencode/scripts/patch-context-mode.sh
   ```

2. Report the result to the user: ✅ Already patched / ✅ Patched / ❌ Failed
3. If successfully patched, tell the user to restart opencode for the change to take effect.
