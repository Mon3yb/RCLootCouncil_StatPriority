local addonName, ns = ...

ns = ns or {}
ns.ADDON_NAME = addonName
ns.COLUMN_ID = "statPriority"
ns.COLUMN_HEADER = "Stat Priority"
ns.COLUMN_WIDTH = 180

local RC = LibStub("AceAddon-3.0"):GetAddon("RCLootCouncil", true)
if not RC then
    return
end

ns.RC = RC

-- We register as a separate module under RCLootCouncil so the addon can extend the
-- voting table without touching base-addon files or replacing internal functions.
ns.module = RC:NewModule("RCStatPriority", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
