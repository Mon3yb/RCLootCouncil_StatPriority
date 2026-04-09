# RCLootCouncil_StatPriority

This is a standalone companion addon for `RCLootCouncil` that adds a new column in the voting frame to display stat priorities of each player.

## What It Does

- Adds a `Stat Priority` column to the RCLootCouncil voting table.
- Shows a single compact row value such as `Arms: C > H > M >= V`.
- Uses the candidate's current spec first if available.
- Falls back to a default order when the spec is unknown.
- Shows the full class spec list in a tooltip, with the displayed spec first.

## AI Disclaimer

- This addons was developed using OpenAI's Codex
- I do check the source code and make manual changes but if you hate AI, you better skip this addon

## Dependency

`RCLootCouncil`

## Where To Edit Stat Priorities
Edit the hardcoded table in:

- `Data/StatPriorities.lua`

Each class entry contains:

- `fallback_order`
- `specs`

## Known Limitations

- Stat priorities are static hardcoded values for now
- No sorting for the custom column.
- No configuration UI.
- Spec names assume English spec keys in the hardcoded data.