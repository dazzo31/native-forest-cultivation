<!--
Sync impact: initial draft, 0.0.0 -> 1.0.0.
Added: all principles and sections below. Removed: none.
Planning and specification templates were reviewed; no changes to shared templates are required.
Deferred: ratification requires owner approval.
-->
# Native Flora Cultivation Fork Constitution

## Migration Mode

**Mode**: UPGRADE

**Justification**: Extend the existing Factorio mod in a fork, retaining its history and
attribution rather than replacing it with a different application.

## Core Principles

### I. User-Directed Behavior
The fork MUST implement the approved feature specification and preserve unrelated vanilla and
modded behavior. Material design choices and changes to existing saves require explicit approval.

### II. Native Gameplay and Compatibility
The mod MUST target Factorio 2.1 and Space Age, use agricultural towers for tree cultivation,
and validate compatibility with the user's enabled mod set. Planting rules MUST respect the
intended planet and suitable soil.

### III. Verifiable Environmental Benefits
Claims about pollution and spore reduction MUST be supported by measured in-game behavior.
Harvest emissions, tower emissions, growth time, and the lifetime of trees MUST be included when
assessing net effect.

### IV. Safe Saves and Data
Validation MUST use isolated mod directories and disposable copies of saves. Existing prototypes
and items MUST NOT be removed or remapped without a tested migration and explicit approval.

### V. Simplicity, Attribution, and Transparency
The implementation MUST prefer the simplest reliable design supported by the game. It MUST retain
the upstream MIT license and attribution, document limitations and incompatibilities, and report
failures rather than silently pretending the requested behavior works.

## Additional Constraints

- The mod is a fork of `FreezingSnail/native-flora-cultivation` version 1.0.3.
- Publishing a Factorio Mod Portal release or modifying the active installation requires separate
  user approval. GitHub fork creation is already authorized.
- No invented throughput, absorption balance, or species-selection behavior may be presented as
  verified without measurement.

## Development Workflow

- Derive implementation tasks from the specification and validate each relevant acceptance case.
- Verify startup, save/load, planting, harvesting, seed handling, and pollutant absorption using
  Factorio itself where available.
- Document any unavailable validation, failure, or behavior requiring a user decision.

## Governance

The project owner approves changes to these rules. Amendments MUST be documented and versioned:
major for incompatible changes, minor for added principles, and patch for clarifications.
Plans and reviews MUST check compliance before implementation and release.

**Version**: 1.0.0 | **Ratified**: TODO(RATIFICATION_DATE): awaiting owner approval | **Last Amended**: 2026-11-18
