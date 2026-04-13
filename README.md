# RCLootCouncil_StatPriority
![RCLootCouncil Preview](https://media.forgecdn.net/attachments/1623/346/bildschirmfoto_20260409_175032-png.png)

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

## Dependencies

This addon requires RCLootCouncil. It does nothing on its own.

## Where To Edit Stat Priorities
Edit the hardcoded table in:

- `Data/StatPriorities.lua`

The data structure for each class in StatPriorities.lua looks like this:
```lua
DEATHKNIGHT = {
        fallback_order = {"Blood", "Frost", "Unholy"},
        specs = {
            Blood = "H >= C >= M = V",
            Frost = "C >= M >> H > V",
            Unholy = "M >= C >> H >> V",
        },
    },
```
- Each entry starts with the class name. Beast Mastery needs to be in the format `["Beast Mastery"]` for lua to detect it as a single entry. It will fail otherwise.
- fallback_order is used in case that the addon cannot detect the current spec of a player. It is more or less the order of specs on wowhead

## Known Limitations

- Stat priorities are static hardcoded values for now
- No sorting for the custom column.
- No configuration UI.
- Spec names assume English spec keys in the hardcoded data.
