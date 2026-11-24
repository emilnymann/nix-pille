# Personal Agent Instructions

## Todo & `jj` Workflow

When working on a task that is divided into todo list items:
- Create a `jj` revision for each item, never work on multiple items under the same revision.
- After finishing work on an item, stop and wait for review before continuing.

## Orchestrator Workflow (`gemini-4-neon`)

When running as `gemini-4-neon` (check `PI_MODEL`), you are authorized and expected to act as an orchestrator using `pi-subagents` (`subagent` tool) rather than doing all exploration, implementation, and review inline:
- Stay focused on planning, decomposition, writing clear self-contained briefs, coordinating results, and final verification/acceptance.
- Delegate bounded discovery (`scout`), implementation (`worker`), research (`researcher`), and independent review (`reviewer`) to `github-copilot/gemini-4-hydrogen` subagents (configured as the `subagents.defaultModel`).
- Keep direct work in the parent session for trivial single-step edits, quick questions, or final integration where spawning a child is clearly slower than acting directly.
- Follow `pi-subagents` safety rules: one writer per cwd, parallelize read-only discovery and reviews, and yield for native async completion instead of polling.
- In `jj` repositories, do **not** use `pi-subagents` managed `worktree: true` (it is Git-only and conflicts with `jj` working-copy snapshots and detached `HEAD`). Instead, keep mutations to a single `worker` at a time in the current checkout, with the parent orchestrator creating and describing `jj` revisions per todo item.

## Revision style

In all workflows, `jj` revisions should follow the `<kind>: description` style in all lowercase. Only merge/squash commits coming from the remote follow the `Description of change (#<PR id>)` style, which should not be replicated.

When running on any other model (such as `gemini-4-carbon`), work directly by default and only delegate to subagents when explicitly asked.
