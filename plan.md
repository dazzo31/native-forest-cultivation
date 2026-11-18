# Implementation Plan: Native Forest Cultivation

**Date**: 2026-11-18 | **Spec**: [spec.md](spec.md)

## Summary

Extend the [upstream fork](https://github.com/FreezingSnail/native-flora-cultivation) so a single
vanilla tree seed grows planet- and soil-appropriate vegetation with agricultural towers, and
living trees remove the local airborne pollutant. Normal tower harvesting remains enabled. This
plan is not implementation approval for a Mod Portal release or active-installation changes.

## Goals and Non-Goals

### Goals
1. **Unified Tree Planting**: Support planting a single vanilla `tree-seed` in agricultural towers on both Nauvis and Gleba, growing terrain- and planet-appropriate native trees without requiring upstream biochamber recipes (REQ-001, REQ-002, REQ-003).
2. **Sustainable Cultivation Cycle**: Preserve standard agricultural tower harvesting and replanting, converting harvested wood back into tree seeds via the vanilla 2-wood-to-1-seed recipe without recipe duplication (REQ-004, REQ-005).
3. **Verifiable Environmental Absorption**: Configure living wild and cultivated trees to absorb local airborne pollutants (pollution on Nauvis, spores on Gleba) and measure net absorption across complete operational cycles (REQ-006, REQ-007).
4. **Save Migration and Compatibility**: Maintain seamless migration for existing upstream mod saves without entity or inventory loss, fully compatible with Factorio 2.1 and Space Age (REQ-008, REQ-009, REQ-010).
5. **Attribution and Transparency**: Retain MIT licensing and attribution, fully documenting mechanics, migration notes, and verified limits (REQ-011).

### Non-Goals
1. **No New Planets or Species**: No flora or surfaces outside Nauvis and the ten upstream Gleba species.
2. **No Planting-Only Towers**: Do not modify tower engine behavior into a planting-only mode.
3. **No Direct Mod Portal Publication**: No publishing or modifying user active game data without explicit sign-off.
4. **No Unmeasured Net Absorption Claims**: No arbitrary numerical absorption claims without in-game empirical verification.

## Technical Context

- **Platform**: Factorio 2.1, Space Age, Lua mod prototypes and runtime APIs.
- **Baseline**: Upstream 1.0.3. `prototypes/native-flora.lua` creates ten Gleba seed/crop pairs,
  decoration recipes and Nauvis decorations. Its plant rendering guard skips sources lacking
  normal maps. `data.lua` loads the prototype files.
- **Behavior change**: The vanilla `tree-seed` is the proposed shared item. Its existing
  wood-to-seed recipe is reused; do not assume it can be crafted on Gleba.
- **Unknown**: One item conventionally points at one plant prototype. Whether a tower-planted
  seed can be safely converted into a soil-specific plant, including seed consumption and growth
  state, must be proven in the actual game before implementing the remaining features.
- **Persistence**: Factorio saves and prototype identities. Existing upstream saves and the
  user's original installation must not be modified during testing.
- **Validation**: Isolated Factorio 2.1 runs with minimal mods, followed by the user's enabled
  mod set and disposable copies of representative saves. Locate the game executable and configure
  isolated paths before making assumptions about CLI arguments or installed packages.

## Constitution Check

- **I. User-Directed Behavior**: PASS subject to migration approval; preserve unrelated behavior.
- **II. Native Gameplay and Compatibility**: PASS subject to game and full-mod-set testing.
- **III. Verifiable Environmental Benefits**: PASS subject to controlled in-game measurements;
  no numerical absorption target has been agreed.
- **IV. Safe Saves and Data**: PASS subject to an isolated test environment and migration gate.
- **V. Simplicity, Attribution, and Transparency**: PASS; preserve the MIT license and surface
  unsupported engine behavior, rather than inventing success.

## Applied Guidelines

The available migration guidance covers Struts-to-Spring and Spring Boot, not Factorio or Lua.
No framework transformation guideline applies. Follow the constitution and existing mod patterns.

## Implementation Steps and Tasks

### Step 1: Establish baseline and prove the planting mechanism

**Requirements**: REQ-001, REQ-002, REQ-003, REQ-008, REQ-010

**1.1** Inventory the actual game/mod versions and baseline prototype and runtime behavior in
isolated test data. **1.2** Prove or disprove soil/surface selection from a single seed with
real agricultural towers, manual planting, save/load, and both planets. Determine the correct
Factorio event or prototype mechanism from the installed game and official API documentation;
do not assume an event exists or that it fires for tower planting.

- [x] T001 [Plan:1.1] Inspect `info.json`, `data.lua`, `prototypes/native-flora.lua`,
  `locale/en/`, installed Space Age prototypes, and enabled mods; record exact versions and
  existing planting, rendering, pollution, recipe, and migration behavior in test evidence.
- [x] T002 [Plan:1.1] Set up disposable Factorio configuration, mod directory and fixture saves;
  verify the unmodified upstream fork starts and the minimal and full-mod baseline loads, without
  altering the user's active install or saves.
- [x] T003 [Plan:1.2] Prototype the least-complex single-seed selection approach in a disposable
  fixture. Demonstrate actual tower planting, manual planting, valid and invalid soil, both
  surfaces, seed consumption, growth and save/reload.
- [x] T004 [Plan:1.2] Enumerate each of the ten upstream Gleba species and suitable soil;
  verify plant graphics and the existing missing-normal-map guard, including the feasibility of
  every species. If any requirement cannot be met, stop and ask the owner before changing scope.

**Gate**: If the engine cannot support safe species/soil selection, or the user's existing mod
set conflicts, stop with evidence and request a decision. Do not silently use one fixed species,
spawn free plants, discard seeds, or call a mock test proof of tower behavior.

### Step 2: Implement the shared cultivation loop

**Requirements**: REQ-001, REQ-002, REQ-003, REQ-004, REQ-005, REQ-008

**2.1** Implement the mechanism proven in Step 1. **2.2** Preserve ordinary harvesting and reuse
the existing recipe. Keep irrelevant vanilla crops and tower behavior unchanged.

- [x] T005 [US1] [Plan:2.1] Update `prototypes/native-flora.lua` and `data.lua` as needed to
  register viable planet-specific plants without unsafe graphics conversions; retain normal
  map safeguards and original vanilla tree behavior on Nauvis.
- [x] T006 [US1] [Plan:2.1] Add or update `control.lua` only if Step 1 proves a runtime handler
  is necessary. Map suitable surface and soil to native species; handle manual/tower creation,
  blocked sectors, save/load and other mods without double consumption or duplicate entities.
- [x] T007 [US2] [Plan:2.2] Replace the need for upstream decoration recipes with the normal
  tower harvest/replant flow; reuse `tree-seed` and its existing two-wood recipe. Preserve native
  harvest products where feasible; verify the seed supply and avoid duplicating recipe unlocks.
- [x] T008 [US1] [Plan:2.1,2.2] Update `locale/en/` and `info.json` descriptions to match the
  final behavior, without claiming support for unverified species or surfaces.

### Step 3: Make absorption observable and effective

**Requirements**: REQ-006, REQ-007, REQ-008

**3.1** Verify the game's actual absorption mechanisms for both pollutants on live wild and
planted trees. **3.2** Implement the simplest compatible mechanism and measure whole-cycle
results, including tower activity and harvest emissions.

- [x] T009 [US3] [Plan:3.1] Inspect Factorio's installed prototype definitions and 2.1 API to
  identify supported per-pollutant absorption, units and tree/plant inheritance; distinguish
  prototype support from runtime behavior with direct in-game measurements.
- [x] T010 [US3] [Plan:3.2] Configure living wild and planted tree absorption for Nauvis pollution
  and Gleba spores, including the relevant vanilla and supported modded tree prototypes. Avoid
  silently overwriting stronger absorption or unrelated mod behavior; if compatibility cannot be
  preserved, stop for an owner decision.
- [x] T011 [US3] [Plan:3.2] Compare matched tree/no-tree fixtures, and separate active-tower and
  idle/no-tree controls over multiple full growth/harvest cycles. Record initial pollutant,
  elapsed time, tree count, emissions, tree-attributable absorption and net results for each
  surface. Report if the operating cycle remains net positive in emissions.

### Step 4: Save compatibility and release documentation

**Requirements**: REQ-009, REQ-010, REQ-011

**4.1** Inventory and preserve or migrate old prototypes and items without data loss.
**4.2** Update documentation and validate the final mod using disposable test installations.

- [x] T012 [Plan:4.1] Inventory old seed, crop, decoration, recipe and placed-entity prototypes
  from `prototypes/native-flora.lua`. Design and test migrations with upstream-save copies,
  including inventories, chests, towers, placed decorations, research and save/reload. Obtain
  owner approval before any incompatible migration; otherwise retain compatibility or block it.
- [x] T013 [Plan:4.2] Update `README.md`, `changelog.txt`, `info.json` and locale for the
  actual gameplay, the 2:1 recipe and its surface restrictions, installation, compatibility,
  migration, absorption results, and known limitations. Preserve `LICENSE` and attribution.
- [x] T014 [Plan:4.2] Run focused actual-game acceptance scenarios for all requirements,
  including at least one supported and one blocked/mixed soil per surface, every supported
  species, forest growth, harvesting/replanting, ordinary fruit crops, and reload.
- [x] T015 [Plan:4.2] Run minimal-mod and full-enabled-mod startup and disposable-save checks;
  record commands, versions, quantitative results, failures, and explicit coverage gaps. Verify
  no original saves or active mods were modified. Do not publish or install without approval.

## Project Structure

```text
native-flora-cultivation/
  constitution.md                 project rules
  spec.md                         requirements and acceptance scenarios
  plan.md                         this plan and executable tasks
  checkpoints/                    traceability
  data.lua                        existing data-stage entry point
  prototypes/native-flora.lua     existing flora definitions
  locale/en/                      existing English locale
  control.lua                     only if feasibility proves runtime logic is needed
  README.md, changelog.txt, info.json, LICENSE
```

Tests and fixtures should follow existing conventions where practical and otherwise use isolated
temporary working directories. Do not commit generated saves, credentials, or test logs.

## Testing Strategy

- **Application type**: Factorio game mod; no browser, database, or network service is required.
- **Journeys**: Shared-seed planting on both planets; terrain restrictions; harvest/replant and
  wood conversion; wild and cultivated tree pollutant absorption; upstream save migration.
- **Primary validation**: Real Factorio 2.1 plus Space Age and actual tower behavior, minimal and
  full enabled mod sets. Use disposable fixtures, deterministic conditions and save/reload.
- **Fallback**: Static prototype checks can diagnose failures, but cannot prove tower planting,
  graphics safety, pollution behavior or mod compatibility. Report those as unverified, not pass.
- **Environment**: Factorio executable and accessible Space Age data; isolated write-data,
  configuration, mods and fixture saves. Record the exact executable and commands used.
- **Acceptance**: All SC-001 through SC-005 and the migration decision pass; record any inability
  to run a case and do not release with unverified required behavior.
- **Safety**: Do not run destructive cleanup against shared directories; remove only known
  temporary fixtures. Never overwrite the real save or publish a release as part of testing.

## Requirement Mapping

| REQ ID | Description | Plan Items | Implementation Evidence |
|---|---|---|---|
| REQ-001 | One seed and towers | 1.1, 1.2, 2.1, 2.2 | `prototypes/native-flora.lua`, possible `control.lua`, tower test |
| REQ-002 | Surface and soil choose native plant | 1.2, 2.1 | prototype/runtime changes, planting tests |
| REQ-003 | Ten Gleba flora, with explicit limitations | 1.2, 2.1 | species inventory, graphics and in-game tests |
| REQ-004 | Harvest/replant and native outputs | 2.2 | harvesting and seed-loop tests |
| REQ-005 | Reuse existing wood-to-seed recipe | 2.2 | recipe inspection and crafting test |
| REQ-006 | Living trees absorb local pollutant | 3.1, 3.2 | prototype/runtime changes, controlled measurements |
| REQ-007 | Measure full operating cycle | 3.2 | quantified tower-cycle comparison |
| REQ-008 | No lost seeds or unrelated interference | 1.2, 2.1, 3.2 | blocked-soil and compatibility tests |
| REQ-009 | Safe upstream-save migration | 4.1 | migration inventory, fixture save/reload evidence |
| REQ-010 | Factorio 2.1 and installed mods | 1.1, 4.2 | isolated startup and full-mod-set evidence |
| REQ-011 | Attribution and documentation | 4.2 | `LICENSE`, `README.md`, `changelog.txt` |
