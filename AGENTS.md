# Agent Files

- **AGENTS.md** — this file. Describes the agent workflow.
- **PLAN.md** — the main project plan. Must exist before any implementation begins.
- **STATUS.md** — log of what was done and what remains from the plan. **Must be updated at the end of every session** before reporting completion to the user. Do not skip this step.

## Workflow

1. Read PLAN.md and STATUS.md at session start to understand current state.
2. If PLAN.md does not exist yet, create it from the user's plan before writing any code.
3. Do the work described in the plan.
4. Update STATUS.md with what was done, what remains, and any decisions made.
5. Only then report completion to the user.

## Code Conventions

### Module pragmas

- MUST include at the top:
  ```nim
  {.experimental: "strictFuncs".}
  {.push raises: [].}
  ```
  This enforces exception safety and pure `func` correctness at compile time.
  Any symbol that intentionally raises MUST override it with an explicit
  `{.raises: [ValueError].}` (or `{.raises: [CatchableError].}` for
  `std/random`) — otherwise `nim check` rejects it.

### Logging

- Not currently used (this is a library with no logging output). If logging is added
  in the future, use `chronicles` structured logging with stdout sink.
