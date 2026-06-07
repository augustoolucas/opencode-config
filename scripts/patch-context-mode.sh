#!/bin/bash
# Patch context-mode to prefix its native tools for opencode
# Avoids name collision with magic-context's ctx_search
# Context: magic-context registers ctx_search (memories+history+commits),
#          context-mode registers ctx_search (FTS5 indexed content).
#          opencode's tool registry silently overwrites duplicates (last wins).
# This patch prefixes context-mode's tools so both coexist.

PLUGIN_FILE=$(find ~/.cache/opencode -path "*/context-mode/build/adapters/opencode/plugin.js" 2>/dev/null | head -1)

if [ -z "$PLUGIN_FILE" ]; then
  echo "❌ context-mode plugin.js not found"
  exit 1
fi

if grep -q 'context-mode_' "$PLUGIN_FILE"; then
  TARGETS=$(grep -c 'context-mode_' "$PLUGIN_FILE")
  echo "✅ Already patched ($TARGETS tools prefixed)"
  exit 0
fi

sed -i 's/tools\[registered\.name\]/tools[`context-mode_${registered.name}`]/' "$PLUGIN_FILE"

if grep -q 'context-mode_' "$PLUGIN_FILE"; then
  TARGETS=$(grep -c 'context-mode_' "$PLUGIN_FILE")
  echo "✅ Patched successfully — $TARGETS tools prefixed with context-mode_"
else
  echo "❌ Patch failed — pattern not found after sed"
  exit 1
fi
