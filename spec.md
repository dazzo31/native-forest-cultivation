# Feature Specification: Native Forest Cultivation

> Governed by: [constitution.md](constitution.md)

**Feature Branch**: To be chosen at implementation  
**Created**: 2026-11-18  
**Status**: Draft  
**Input**: Fork Native Flora Cultivation to use agricultural towers and one soil-dependent tree
seed to grow native trees that reduce the local airborne pollutant.

## Scope Baseline

- **Discovery method**: User requirements and upstream mod version 1.0.3 documentation and code.
- **Items discovered**: Two target planets and ten named Gleba flora species in the upstream list.
- **Items in scope**: Both planets and all ten species, subject to engine compatibility checks;
  Nauvis tree variants are selected according to their suitable soil.
- **Out of scope**: New planets, a planting-only tower mode, Mod Portal publication, and changes
  unrelated to tree cultivation or pollutant absorption.

## User Scenarios & Testing

### User Story 1 - Plant a native forest (Priority: P1)

A player supplies one kind of tree seed to an agricultural tower. Suitable soil and the planet
determine which native tree grows.

**Independent Test**: Plant with the same seed on representative Nauvis and Gleba soils and
observe the mature species and soil restrictions.

**Acceptance Scenarios**:
1. **Given** suitable Nauvis soil, **when** a tower plants the shared seed, **then** a
   Nauvis-appropriate tree grows.
2. **Given** suitable Gleba soil, **when** a tower plants the same seed, **then** a native Gleba
   plant grows and no Nauvis tree grows there.
3. **Given** unsuitable soil, **when** a tower tries to plant, **then** it does not place an
   unsupported tree or consume a seed without producing a plant.

### User Story 2 - Sustain cultivation (Priority: P1)

A player uses agricultural towers to harvest and replant, with seeds produced from wood.

**Independent Test**: Produce the existing wood-to-seed recipe, plant and grow a tree, and verify
that a tower can harvest and replant without biochamber-created decoration items.

**Acceptance Scenarios**:
1. **Given** the existing tree-seed recipe is unlocked, **when** two wood are processed,
   **then** one standard tree seed is produced, without a duplicate recipe.
2. **Given** a mature planted tree and tower output space, **when** the tower operates,
   **then** it harvests the tree and can plant another seed.

### User Story 3 - Reduce airborne pollution (Priority: P1)

A player grows or retains living trees that reduce the surface's native airborne pollutant.

**Independent Test**: Compare pollution in controlled tree and no-tree fixtures on Nauvis and
Gleba and measure the complete operating cycle.

**Acceptance Scenarios**:
1. **Given** comparable polluted chunks, **when** living trees are present, **then** their
   contribution to pollution removal on Nauvis is measurable.
2. **Given** comparable spore-bearing chunks, **when** living trees are present, **then** their
   contribution to spore removal on Gleba is measurable.
3. **Given** a working tower, **when** emissions and harvesting are included, **then** the
   measured net result and assumptions are documented rather than inferred.

### Edge Cases

- Full tower output, lack of seeds, blocked and mixed-soil sectors, no power, and existing plants.
- Save/load, concurrent towers, other mods and surfaces, and existing upstream items or entities.
- Tree graphics missing normal maps and species that cannot safely become plant prototypes.
- Save migration from the upstream mod; existing assets must not silently disappear.
- Vanilla tree-seed recipe is normally surface-restricted; preserve it unless a change is approved.

## Requirements

### Functional Requirements

- **REQ-001**: Support agricultural tower planting of a single shared tree-seed item on Nauvis
  and Gleba, without requiring the upstream biochamber decoration recipe.
- **REQ-002**: Select an appropriate native tree using the actual planet and suitable soil;
  Nauvis trees MUST NOT grow on Gleba.
- **REQ-003**: Support the ten upstream Gleba flora species where their terrain and engine
  representation permit, with explicit reporting of any unsupported species.
- **REQ-004**: Retain normal tower harvesting and replanting; do not introduce a planting-only
  mode. Preserve native harvest products where feasible without creating an unsustainable loop.
- **REQ-005**: Reuse the existing two-wood-to-one-tree-seed recipe and avoid duplicate recipes.
- **REQ-006**: Make living trees absorb normal pollution on Nauvis and spores on Gleba, for both
  planted and wild trees in the feature scope.
- **REQ-007**: Measure tree absorption and the whole tower cycle, including spores from tower work
  and harvests; document actual net results rather than promise an unverified balance.
- **REQ-008**: Avoid seed loss, invalid planting, and interference with ordinary fruit crops and
  unrelated mods when planting conditions are not met.
- **REQ-009**: Preserve existing save data and upstream items/entities through tested migration,
  or block replacement and provide an explicit, approved migration path.
- **REQ-010**: Work with Factorio 2.1 and Space Age and validate with the user's installed mod set
  without modifying original saves or the active installation.
- **REQ-011**: Retain upstream MIT license and attribution; document installation, behavior,
  compatibility, testing results and known limitations.

### Key Entities

- **Tree seed**: The shared seed used for planting on both target planets.
- **Native tree**: A living tree or flora plant whose species is selected for its surface and soil.
- **Agricultural tower**: The existing machine that plants and harvests.
- **Airborne pollutant**: Pollution on Nauvis and spores on Gleba.

## Success Criteria

### Measurable Outcomes

- **SC-001**: The same seed plants an appropriate native plant on each of the two target planets.
- **SC-002**: At least one representative supported soil and one unsupported or mixed soil case
  per planet pass the planting checks; no Nauvis tree is planted on Gleba.
- **SC-003**: The existing 2:1 wood-to-seed conversion and a full plant/harvest/replant cycle
  are demonstrated without requiring a decoration recipe.
- **SC-004**: Controlled in-game comparisons establish positive tree-attributable removal on
  both surfaces; tower-cycle emissions and net results are separately reported.
- **SC-005**: Fresh startup and save/reload succeed in an isolated minimal configuration and
  the user's full enabled mod configuration, or any unavailable run is explicitly reported.

## Assumptions

- One shared seed means the existing vanilla `tree-seed`, not one separate seed per species.
- Soil selection and native harvest behavior are subject to engine feasibility; no unsupported
  workaround is approved merely by this specification.
- No numerical absorption rate or guaranteed net reduction during operation has been approved.
- Vanilla's existing wood-to-seed recipe may be Nauvis-only; using it on Gleba is not assumed.
