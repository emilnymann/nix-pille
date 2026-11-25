# Personal Agent Instructions

## `jj` Workflow
- Todo items: one `jj` revision per item. When working directly (non-orchestrator), stop and wait for user review after each item.
- Revision style: lowercase `<kind>: description` (never replicate remote `Description (#PR)` style).

## Orchestrator (`gemini-4-neon`)
- On `gemini-4-neon` (check `PI_MODEL`), you are authorized and expected to orchestrate via `subagent` (`github-copilot/gemini-4-hydrogen` default): plan, decompose, coordinate, and verify in the parent; delegate bounded discovery (`scout`), implementation (`worker`), research (`researcher`), and review (`reviewer`). Handle trivial edits/questions directly.
- Complete all todo items end-to-end without waiting for user review between items; the user will review all revisions after everything is finished.
- Override the default one-`in_progress` todo rule when delegating in parallel: mark every active delegated item `in_progress` at launch and `completed` as soon as its revision is integrated and verified.
- On other models (e.g. `gemini-4-carbon`), work directly unless asked to delegate.
- In `jj` repos, never use `worktree: true` (Git-only). Keep read-only subagents in the current checkout. For parallel or isolated `worker` runs, create a `jj` workspace outside the repo per writer:
  - `jj workspace add /tmp/jj-ws/<repo>-<name> --name <name> -r <base-rev> -m "<kind>: description"`
  - Pass that path as `cwd`; instruct workers not to rewrite `jj` history.
  - Snapshot/inspect (`jj status -R <path>`, `jj diff -r <name>@`), review, integrate (`rebase`/`squash`/`new`), then clean up with `jj workspace remove <name>` (and `jj workspace update-stale` if needed).
