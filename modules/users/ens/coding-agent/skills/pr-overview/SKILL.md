---
name: pr-overview
description: Review and triage PR feedback on the user's own pull request. Finds the PR (preferring Linear diffs over GitHub), inspects each review and inline code comment against the local codebase, and presents a structured overview with validity ratings and suggested fixes. Use when asked for a PR overview, review summary, or help triaging review comments.
---

# Pull Request Review Overview

Give the user a clear, actionable overview of reviews and code comments on their own pull request, verifying each comment against the actual code.

## 1. Locate the Pull Request (Prefer Linear, Fallback to GitHub)

First determine the target from user arguments (PR URL, PR number, Linear review URL/slug, Linear issue ID like `ENG-123`, or branch/bookmark name). If none is given, inspect the current repo (`jj bookmark list -r 'ancestors(@, 5)'` / `git branch --show-current` and remote `owner`/`repo` from `git remote get-url origin`).

1. **Try Linear first** (via `codemode` calling `mcp__linear__*` tools):
   - If given a Linear review URL, diff slug, PR URL, or full identifier: call `mcp__linear__get_diff({ urlOrId })`.
   - If given a Linear issue identifier (e.g. `ENG-123`): call `mcp__linear__get_issue({ id })` to get its linked PR attachment / `gitBranchName`, then `mcp__linear__get_diff` or `mcp__linear__list_diffs`.
   - Otherwise, search with `mcp__linear__list_diffs({ author: "me", owner, repo, query: <branch-or-keyword> })` (and broaden without `query` if needed; ask the user with `ask_user_question` only if multiple open PRs match ambiguously).
   - Once found, fetch details and all discussion threads with `mcp__linear__get_diff({ urlOrId })` and `mcp__linear__get_diff_threads({ urlOrId })` (also check `resolved: false` vs resolved threads so you know what is still open).
2. **Fallback to GitHub (`gh`)** if Linear has no matching diff, is unavailable, or lacks full GitHub review/comment data:
   - Locate with `gh pr view --json number,title,url,state,headRefName,baseRefName,reviews,comments` (or `gh pr list --author @me --state open` if no branch PR matches).
   - Fetch inline review threads (with resolution status and exact diff locations) via `gh api graphql` on `pullRequest.reviewThreads` and `pullRequest.reviews`, or `gh api repos/{owner}/{repo}/pulls/{number}/reviews` and `/comments`.

## 2. Verify Comments Against the Codebase

Do **not** take reviewer claims at face value. For every unresolved (and any still-relevant) review and inline comment:
- Read the referenced file and surrounding context in the local checkout (and inspect the PR diff if local HEAD differs from the PR head).
- Check whether the concern is factually accurate, still present in the latest revision, covered elsewhere, or a style/trade-off preference.
- Note any threads that appear already addressed in newer commits or resolved.

## 3. Present the Overview

Group by **review / reviewer** (separating unresolved items from resolved ones; collapse resolved threads into a brief note unless relevant).

### Header
- PR title, link (Linear and/or GitHub), branch -> base, overall review states (Approved / Changes Requested / Commented), and a 1-line summary of what still needs action.

### Per-Review Breakdown
For each reviewer / review:
- **Reviewer, state, and top-level summary**
- **Code comments / threads** (with `file:line`, open/resolved status, and concise summary of the comment):
  - **Validity rating** — assign one of:
    - `Valid (Must fix)` — genuine bug, regression, security/correctness issue, or clear requirement violation.
    - `Valid (Improvement)` — sound suggestion for readability, maintainability, performance, or edge-case hardening.
    - `Debatable / Nit` — subjective preference, trade-off, or minor style nit; briefly state both sides.
    - `Invalid / Outdated` — factually mistaken, already handled elsewhere, or already fixed in a later commit (cite the evidence).
  - **Assessment** — 1–3 sentences grounded in the actual code explaining *why* it has that rating.
  - **Suggested fix** — when applicable, provide a concrete fix (short code snippet or specific change) or a brief reply if pushing back / clarifying.

### Action Summary
End with a short prioritized checklist of recommended fixes (Must fix -> Improvements -> Optional/Reply-only) and ask whether the user wants to apply any of the fixes. Do **not** modify files until the user asks.
