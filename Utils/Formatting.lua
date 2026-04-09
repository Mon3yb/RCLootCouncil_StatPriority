local _, ns = ...

ns.Format = ns.Format or {}

local Format = ns.Format
local Player = ns.RC and ns.RC.Require and ns.RC.Require "Data.Player" or nil

local classDisplayNames = {
    DEATHKNIGHT = "Death Knight",
    DEMONHUNTER = "Demon Hunter",
    DRUID = "Druid",
    EVOKER = "Evoker",
    HUNTER = "Hunter",
    MAGE = "Mage",
    MONK = "Monk",
    PALADIN = "Paladin",
    PRIEST = "Priest",
    ROGUE = "Rogue",
    SHAMAN = "Shaman",
    WARLOCK = "Warlock",
    WARRIOR = "Warrior",
}

local statInitials = {
    ["CRIT"] = "C",
    ["CRITICAL"] = "C",
    ["CRITICAL STRIKE"] = "C",
    ["HASTE"] = "H",
    ["MASTERY"] = "M",
    ["VERSATILITY"] = "V",
}

local function trim(value)
    if type(value) ~= "string" then
        return value
    end

    return value:match("^%s*(.-)%s*$")
end

function Format.ToStatInitial(statName)
    if type(statName) ~= "string" then
        return statName
    end

    return statInitials[trim(statName):upper()] or statName
end

function Format.ShortenPriority(priorityText)
    if type(priorityText) ~= "string" then
        return nil
    end

    local shortened = priorityText
    shortened = shortened:gsub("Critical Strike", Format.ToStatInitial("Critical Strike"))
    shortened = shortened:gsub("Critical", Format.ToStatInitial("Critical"))
    shortened = shortened:gsub("Crit", Format.ToStatInitial("Crit"))
    shortened = shortened:gsub("Haste", Format.ToStatInitial("Haste"))
    shortened = shortened:gsub("Mastery", Format.ToStatInitial("Mastery"))
    shortened = shortened:gsub("Versatility", Format.ToStatInitial("Versatility"))
    shortened = shortened:gsub("%s+", " ")

    return trim(shortened)
end

function Format.NormalizeClassToken(classToken)
    if type(classToken) ~= "string" or classToken == "" then
        return nil
    end

    local normalized = classToken:gsub("[%s_%-]", ""):upper()
    return normalized ~= "" and normalized or nil
end

function Format.NormalizeSpecName(specName)
    if type(specName) ~= "string" or specName == "" then
        return nil
    end

    return trim(specName)
end

function Format.GetClassData(classToken)
    classToken = Format.NormalizeClassToken(classToken)
    return classToken and ns.STAT_PRIORITIES and ns.STAT_PRIORITIES[classToken] or nil
end

function Format.GetClassDisplayName(classToken)
    classToken = Format.NormalizeClassToken(classToken)
    return classDisplayNames[classToken] or classToken or "Unknown"
end

local function getSpecNameFromID(specID)
    if type(specID) ~= "number" then
        return nil
    end

    local _, specName = GetSpecializationInfoByID(specID)
    return Format.NormalizeSpecName(specName)
end

-- Candidate class/spec should come from the voting-frame candidate snapshot first.
-- We only fall back to the cached Player object when the session snapshot is incomplete.
function Format.GetCandidateIdentity(votingFrame, session, candidateName)
    local lootTable = votingFrame and votingFrame.GetLootTable and votingFrame:GetLootTable() or nil
    local candidateData = lootTable and lootTable[session] and lootTable[session].candidates
        and lootTable[session].candidates[candidateName]
        or nil

    local classToken = candidateData and Format.NormalizeClassToken(candidateData.class) or nil
    local specName = candidateData and getSpecNameFromID(candidateData.specID) or nil

    if Player and candidateName then
        local player = Player:Get(candidateName)
        if not classToken then
            classToken = Format.NormalizeClassToken(player and player.class)
        end
        if not specName then
            specName = getSpecNameFromID(player and player.specID)
        end
    end

    return {
        candidateName = candidateName,
        candidateData = candidateData,
        classToken = classToken,
        specName = specName,
    }
end

function Format.SelectDisplayedSpec(classToken, specName)
    local classData = Format.GetClassData(classToken)
    if not classData then
        return nil, nil
    end

    local specs = classData.specs or {}
    local normalizedSpec = Format.NormalizeSpecName(specName)

    if normalizedSpec and specs[normalizedSpec] then
        return normalizedSpec, Format.ShortenPriority(specs[normalizedSpec])
    end

    if type(classData.fallback_order) == "table" then
        for _, fallbackSpec in ipairs(classData.fallback_order) do
            if specs[fallbackSpec] then
                return fallbackSpec, Format.ShortenPriority(specs[fallbackSpec])
            end
        end
    end

    local firstSpec = next(specs)
    if firstSpec then
        return firstSpec, Format.ShortenPriority(specs[firstSpec])
    end

    return nil, nil
end

local function appendSpecEntry(entries, seen, classData, specName)
    if not specName or seen[specName] then
        return
    end

    local priority = classData and classData.specs and classData.specs[specName]
    if not priority then
        return
    end

    entries[#entries + 1] = {
        spec = specName,
        priority = Format.ShortenPriority(priority),
    }
    seen[specName] = true
end

function Format.BuildOrderedSpecEntries(classToken, displayedSpec)
    local classData = Format.GetClassData(classToken)
    if not classData then
        return nil
    end

    local entries = {}
    local seen = {}

    appendSpecEntry(entries, seen, classData, displayedSpec)

    if type(classData.fallback_order) == "table" then
        for _, fallbackSpec in ipairs(classData.fallback_order) do
            appendSpecEntry(entries, seen, classData, fallbackSpec)
        end
    end

    local extras = {}
    for specName in pairs(classData.specs or {}) do
        if not seen[specName] then
            extras[#extras + 1] = specName
        end
    end
    table.sort(extras)

    for _, specName in ipairs(extras) do
        appendSpecEntry(entries, seen, classData, specName)
    end

    return entries
end

function Format.BuildCellText(classToken, specName)
    local displayedSpec, priority = Format.SelectDisplayedSpec(classToken, specName)
    if not (displayedSpec and priority) then
        return "N/A"
    end

    return string.format("%s: %s", displayedSpec, priority)
end

function Format.BuildTooltip(candidateName, classToken, specName)
    local title = candidateName or "Unknown"
    local displayedSpec = Format.SelectDisplayedSpec(classToken, specName)
    local entries = Format.BuildOrderedSpecEntries(classToken, displayedSpec)

    if not classToken then
        return title, "Class: Unknown\nShown: N/A\n\nN/A"
    end

    local lines = {
        string.format("Class: %s", Format.GetClassDisplayName(classToken)),
        string.format("Shown: %s", displayedSpec or "N/A"),
        "",
    }

    if entries and #entries > 0 then
        for _, entry in ipairs(entries) do
            lines[#lines + 1] = string.format("%s: %s", entry.spec, entry.priority)
        end
    else
        lines[#lines + 1] = "N/A"
    end

    return title, table.concat(lines, "\n")
end
