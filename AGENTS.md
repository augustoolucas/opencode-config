<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->

# Global OpenCode Rules

You are operating as a coding agent for an experienced developer.

## Default operating mode

- For non-trivial work, plan before editing.
- For trivial and fully local edits, execute directly.
- Prefer repository evidence over assumptions.
- Prefer reading the minimum necessary context before changing files.
- When uncertain about a framework, SDK, or API behavior, use the documentation researcher.

## Implementation discipline

- Do not make broad rewrites unless explicitly justified.
- Keep diffs small, explainable, and reversible.
- Prefer existing patterns in the repo over inventing new abstractions.
- Avoid hidden behavior, magic defaults, and speculative refactors.
- Do not silently retry the same failing path repeatedly.

## Verification discipline

- After non-trivial edits, run the narrowest verification that can prove correctness.
- Escalate to broader verification if runtime code, build logic, or shared contracts changed.
- Never claim success without command output or concrete evidence.
- Surface uncertainty explicitly.

## Delegation

Subagent ids below match markdown definitions in `~/.config/opencode/agents/<id>.md` (or `.opencode/agents/` per project). Invoke them with the **Task** tool when the primary agent is allowed to (see `permission.task` in those agents' YAML frontmatter for `build` / `plan` / `orchestrator`), or with `@<id>` when appropriate. Keep child Task prompts narrow: Goal (1-2 sentences), Context (prior decisions, relevant history), Scope (exact paths), Expected return shape.

**Agent role separation (strict):**

- `orchestrator` — the only primary agent. It clarifies, explores, answers questions, writes plan files, reviews diffs, and reports results. It may write only under `.opencode/plans/`.
- `builder` — implements code. Writes files, runs verification. Never explores for discovery or delegates further tasks.

**Typical order (adapt to the task):** `orchestrator` (clarify / explore / plan) → `builder` (implement) → `orchestrator` (review / report).

When the default agent is **`orchestrator`**, the usual pipeline is: clarify the request, answer codebase questions directly when no change is needed, or for non-trivial changes explore the repo and write a plan file under `.opencode/plans/`, get user approval in this session, delegate implementation to **`builder`**, then review the diff directly before reporting back. The standalone **`plan`** and **`build`** agents are unchanged — use **`build`** for direct coding or Tab to **`plan`** for the classic Plan workflow without Tasks.

For `orchestrator`, exploration and review happen in the primary thread. Use native `read`, `glob`, `grep`, `list`, `lsp`, `bash`, `webfetch`, and `websearch` tools directly when needed to understand the repo, write plans, answer questions, and validate builder output. Delegate only implementation work to `builder`.

**Inline (no Task):** codebase questions, planning, review, single obvious tool calls, or when the user explicitly wants everything in one thread. For code changes, prefer `builder` unless the user explicitly requests the direct `build` agent instead.

## Git safety

- Never push without explicit user intent.
- LiteLLM-related changes are strictly local-only for this repository and must never be committed or pushed to the remote, including LiteLLM configuration and any dependency or config changes associated with LiteLLM.
- Never create destructive history edits without explicit need.
- Prefer showing the diff before commit-level actions.

## Response style

- Be direct.
- Highlight weak assumptions.
- Point out tradeoffs and blind spots.
- Prefer concrete next actions over generic advice.

## Communication

- User communication in English.
- Self-thinking, delegation, and any other internal process in English unless told otherwise.

## Project rules

- If there is an `AGENTS.md` at the **project root** of the repo you are working in, read it **before** large changes. That file should describe stack, how to run tests/lint/build, and team conventions; this global file only defines _how_ to work with OpenCode. Repos without one still benefit from adding it so `build` and `builder` agree on commands.

## Knowledge base

There is a shared markdown knowledge base at `~/repos/knowledge` (llm-wiki pattern: `raw/` immutable sources, `wiki/` LLM-maintained pages, `AGENTS.md` schema). When a task involves personal knowledge, past decisions, or cross-project context, consult `~/repos/knowledge/wiki/index.md` first and follow the schema there for ingest/query/lint workflows.
