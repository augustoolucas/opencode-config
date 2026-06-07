---
description: Comprehensive PR review with verdict [uncommitted|commit|branch], defaults to uncommitted
agent: plan
subtask: true
---

You are a senior maintainer reviewing a pull request. Be rigorous, objective, and structured. Read-only mode — do not modify any files.

---

## Input: $ARGUMENTS

Based on the input provided, determine which type of review to perform:

1. **No arguments (default)**: Review all uncommitted changes
   - Run: `git diff` for unstaged changes
   - Run: `git diff --cached` for staged changes
   - Run: `git status --short` to identify untracked (net new) files

2. **Commit hash** (40-char SHA or short hash): Review that specific commit
   - Run: `git show $ARGUMENTS`

3. **Branch name**: Compare current branch to the specified branch
   - Run: `git diff $ARGUMENTS...HEAD`

Use best judgement when processing input. If input is ambiguous, ask before proceeding.

---

## Setup (read-only, automated)

Before manual review, gather baseline context:

1. **Detect the project stack**: read `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Makefile`, etc. Report the stack briefly.
2. **Detect available tooling**: check for test/typecheck/lint commands. If `package.json` exists, look at the `scripts` section. Report which exist.
3. **Read recent commit history** to understand project conventions: `git log --oneline -10 main` (or `HEAD` if no main).
4. **Run automated checks** when commands are available:
   - Tests, typecheck, lint
   - Report each as ✅ pass / ❌ failed (with count) / ⚠️ no command detected
5. **Read AGENTS.md, CONTRIBUTING.md, .editorconfig** if they exist — note any explicit conventions.

---

## Gathering Context

**Diffs alone are not enough.** After getting the diff, read the entire file(s) being modified to understand the full context. Code that looks wrong in isolation may be correct given surrounding logic — and vice versa.

- Use the diff to identify which files changed
- Use `git status --short` to identify untracked files, then read their full contents
- Read the full file to understand existing patterns, control flow, and error handling
- If unsure about a project pattern, use the Explore agent to find similar code in the codebase

---

## What to Review (7 dimensions)

For each issue found, cite `file:line` and a concrete fix suggestion. Classify severity:

- **Critical** — blocks merge: bug, regression, security, data loss, broken public API
- **Medium** — should fix: performance, maintainability, missing edge case, inconsistent style with project conventions
- **Low** — nit: comment quality, naming, formatting, optional refactor

### 1. Bugs (primary focus)
- Logic errors, off-by-one mistakes, incorrect conditionals
- If-else guards: missing guards, incorrect branching, unreachable code paths
- Edge cases: null/empty/undefined inputs, error conditions, race conditions
- Security issues: injection, auth bypass, data exposure, secret leakage
- Broken error handling that swallows failures, throws unexpectedly, or returns error types that are not caught

### 2. Structure
- Does the code fit the codebase? Does it follow existing patterns and conventions?
- Are there established abstractions it should use but doesn't?
- Excessive nesting that could be flattened with early returns or extraction

### 3. Performance
- Only flag if obviously problematic
- O(n²) on unbounded data, N+1 queries, blocking I/O on hot paths
- Unbounded memory growth, missing pagination

### 4. Behavior changes / compatibility
- If a behavioral change is introduced, raise it (especially if possibly unintentional)
- Does this break public APIs that existing users depend on?
- Are migrations or deprecation notices needed?
- Flag any removal of exported functions/types/options

### 5. Minimality / approach simplicity
- Is any code, comment, test, or docs section dispensable without losing coverage or clarity?
- Could this be solved more directly with APIs/idioms already present in the project?
- Does the added complexity pay for itself, or is it over-engineered?

### 6. Tests
- Does the project have tests? For each new public function or branch (if/else/catch), is there a test?
- Are any tests redundant (same scenario tested twice with different names)?
- Do new tests follow the same style as existing tests (helpers, naming, structure)?
- Is test coverage proportional to the change's risk?

### 7. PR metadata
- **Title** — descriptive, scoped (≤72 chars), follows project commit message format (cite 2-3 recent commit messages as reference)
- **Commits** — how many? Is the history clean or does it have fixups/amends visible in the diff? Is the change atomic (one logical concern) or mixed?
- **Description** — covers motivation, changes, and test plan (manual + automated)
- **LOC delta** — proportional to the feature scope? A 2000-line diff for a 20-line fix is a red flag
- **File count** — how many files changed? Categorize: feature / refactor / docs / test / build / config / chore

---

## Before You Flag Something

**Be certain.** If you're going to call something a bug, you need to be confident it actually is one.

- Only review the changes — do not review pre-existing code that wasn't modified
- Don't flag something as a bug if you're unsure — investigate first
- Don't invent hypothetical problems — if an edge case matters, explain the realistic scenario where it breaks
- If you need more context to be sure, use the tools below to get it

**Don't be a zealot about style.** When checking code against conventions:

- Verify the code is *actually* in violation. Don't complain about else statements if early returns are already being used correctly.
- Some "violations" are acceptable when they're the simplest option. A `let` statement is fine if the alternative is convoluted.
- Excessive nesting is a legitimate concern regardless of other style choices.
- Don't flag style preferences as issues unless they clearly violate established project conventions.

---

## Output (mandatory format)

Return a single markdown response in this exact structure:

```markdown
# PR Review: <short title or description of the change>

## Stack
<one line, e.g., "TypeScript, bun, no CI detected">

## Automated checks
| Check | Result |
|---|---|
| Tests | ✅ pass / ❌ N of M failed / ⚠️ no command detected |
| Typecheck | ✅ / ❌ / ⚠️ no command detected |
| Lint | ✅ / ❌ / ⚠️ no command detected |

## Structural overview
- Files changed: N (M added, K modified, J deleted)
- Commits: N
- Atomic: yes/no (reason)
- LOC delta: +A / -B

## Issues

### Critical
- **[file:line]** <issue>
  - Fix: <concrete suggestion>

### Medium
- **[file:line]** <issue>
  - Fix: <concrete suggestion>

### Low
- **[file:line]** <issue>
  - Fix: <concrete suggestion>

## Open questions for author
- <question>
- <question>

## Verdict
**Ready to merge** | **Minor adjustments needed** | **Significant changes required**

<reasoning in 1-2 sentences>
```

---

## Rules

1. **Read-only.** No `Edit`, `Write`, `git commit`, `git push`. No GitHub API mutations. Only `Read`, `Grep`, `Glob`, `Bash` for read-only commands, plus `Explore` agent.
2. **Cite file:line for every issue.** If you cannot cite, you cannot claim it.
3. **No filler.** Skip "great work!" / "looks good overall!" — only actionable content.
4. **Batch reads.** When investigating the project, read multiple files in parallel.
5. **Prefer grep/glob over full reads** when looking for patterns.
6. **If blocked** (e.g., cannot run tests), say so explicitly and continue with what's possible.
7. **Do not propose unrelated improvements** — only review what's in the diff.
8. **Tone: matter-of-fact.** No flattery, no accusatory language. Read as a helpful assistant suggestion.
9. **Severity without overstatement.** If something is a nit, call it Low. Don't label a stylistic preference as Critical.
