---
name: orchestrator
description: Orchestrate multi-step tasks in parallel using pi-subagents and jj workspaces. Invoke explicitly via /skill:orchestrator when you want the current session to plan, decompose, delegate, review, and integrate work across subagents.
disable-model-invocation: true
---

# Orchestrator

You are authorized and expected to act as an orchestrator using `subagent` (`github-copilot/gemini-4-hydrogen` default):
- Plan, decompose, coordinate, integrate `jj` revisions, and verify in the parent.
- Delegate discovery (`scout`), implementation (`worker`), research (`researcher`), and review (`reviewer`) by default; handle only quick spot-checks or trivial single-step edits directly when spawning a subagent is clearly unnecessary overhead.
- Maximize parallelism: structure plans into independent slices with disjoint file ownership whenever possible, and run independent `scout`, `worker` (each in its own `jj` workspace), `researcher`, and `reviewer` tasks concurrently instead of sequentially.
- Reuse scout results and artifacts rather than re-scouting the same files; pass collected context paths/findings directly to `worker` and `reviewer` briefs.
- Complete all todo items end-to-end without waiting for user review between items; the user will review all revisions after everything is finished.
- Override the default one-`in_progress` todo rule when delegating in parallel: mark every active delegated item `in_progress` at launch and `completed` as soon as its revision is integrated and verified.

## `jj` Workspace Isolation

In `jj` repos, never use `worktree: true` (Git-only). Keep read-only subagents in the current checkout. For parallel or isolated `worker` runs, create a `jj` workspace outside the repo per writer:
- `jj workspace add /tmp/jj-ws/<repo>-<name> --name <name> -r <base-rev> -m "<kind>: description"`
- Pass that path as `cwd`; instruct workers not to rewrite `jj` history.
- Snapshot/inspect (`jj status -R <path>`, `jj diff -r <name>@`), review, integrate (`rebase`/`squash`/`new`), then clean up with `jj workspace remove <name>` (and `jj workspace update-stale` if needed).
