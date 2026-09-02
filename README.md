# ePWT — Electric Powertrain Learning Bench

An electric mini-quad used as a hands-on learning platform for power electronics,
electric machines, control and model-based development.

The hardware exists and runs (PMSM motor, VESC inverter, 13S5P Li-ion pack, BMS,
ESP32). This project is not about building the vehicle — it is about **modelling,
controlling, instrumenting and understanding it from first principles**.

Structure: a Simulink digital twin parameterised from measured hardware, validated
against real test data, driving control development that is later deployed to the
embedded target.

Work runs in two-week cycles, each closed by a review with engineering mentors.

## Repository

| Path | Contents |
|---|---|
| `01_plan/` | Two-week work cycles: goal, deliverable, outcome |
| `02_knowledge/` | Engineering notes |
| `04_model/` | Simulink model — digital twin |
| `05_firmware/` | Embedded code (ESP32 / Arduino) |
| `03_hardware/` | Vehicle specs, datasheets, measured parameters |
| `06_data/` | Test logs |
| `07_experiments/` | Hypothesis, measurement, conclusion |
| `08_decisions/` | Engineering decisions and discarded alternatives |
| `01_plan/` | Long-term direction and deferred scope |

## Toolchain

### MATLAB and Simulink from the coding agent (MCP)

Simulink is driven from an AI coding agent through the MathWorks
[Simulink Agentic Toolkit](https://github.com/matlab/simulink-agentic-toolkit),
which runs on top of the
[MATLAB MCP Server](https://github.com/matlab/matlab-mcp-server).

The agent reads model structure, queries parameters and runs simulations. It does
**not** place or wire blocks — see rule 4 in `04_model/CLAUDE.md` for why.

**Daily use.** Open MATLAB first, then the agent from this directory.
`~/Documents/MATLAB/startup.m` opens the bridge automatically. The server attaches
to an *existing* MATLAB session, so MATLAB must already be running: if the agent
starts first it will fail with `failed to attach to MATLAB session` and needs a
restart. To check the bridge from a session, run `feature('getpid')` — a reply
means it is up.

**Regenerating the configuration.** `.mcp.json` is committed, but it holds
absolute paths that are specific to one machine and one user account. Do not edit
it by hand on a new machine — regenerate it.

Prerequisites: MATLAB R2023a or later with Simulink, plus
`agenticToolkitInstaller.mltbx` from the toolkit's GitHub releases, installed as a
MATLAB add-on. Then, in MATLAB:

```matlab
setupAgenticToolkit("install", Toolkit=["matlab","simulink"], Prompt=false)
cd <this repository>
setupAgenticToolkit("configure", Toolkit=["matlab","simulink"], ...
    Agents="claude-code", Scope="project", DisableTelemetry=true, Prompt=false)
```

Two things that are easy to get stuck on:

- If the agent binary is not on `PATH`, autodetection fails silently. Pass it
  explicitly: `AgentCLI="claude-code=/full/path/to/claude"`.
- The project MCP server must be approved before it will start. Approval lives in
  `.claude/settings.local.json`, which is machine-local and not committed. Some
  clients never show the approval prompt; in that case write it by hand:
  `{"enabledMcpjsonServers": ["matlab"]}`.

Finally, add `satk_initialize` to `startup.m` so the bridge opens on every MATLAB
launch rather than by hand.
