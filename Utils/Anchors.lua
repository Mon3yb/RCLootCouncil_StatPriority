local _, ns = ...

ns.Anchors = ns.Anchors or {}

local Anchors = ns.Anchors

function Anchors.FindColumnIndex(scrollCols, columnName)
    if type(scrollCols) ~= "table" or not columnName then
        return nil
    end

    for index, column in ipairs(scrollCols) do
        if column and column.colName == columnName then
            return index
        end
    end

    return nil
end

function Anchors.CaptureSortTargets(scrollCols)
    local sortTargets = {}
    if type(scrollCols) ~= "table" then
        return sortTargets
    end

    for index, column in ipairs(scrollCols) do
        if column and column.colName and column.sortnext and scrollCols[column.sortnext] then
            sortTargets[column.colName] = scrollCols[column.sortnext].colName
        end
    end

    return sortTargets
end

function Anchors.RestoreSortTargets(votingFrame, sortTargets)
    if not (votingFrame and type(votingFrame.scrollCols) == "table") then
        return
    end

    for _, column in ipairs(votingFrame.scrollCols) do
        if column and column.colName then
            local targetName = sortTargets[column.colName]
            column.sortnext = targetName and Anchors.FindColumnIndex(votingFrame.scrollCols, targetName) or nil
        end
    end
end

-- Preferred placement uses the stable wowaudit identifiers. If the note column sits
-- directly after the wishlist column, we keep that pair together and insert after both.
function Anchors.FindInsertionIndex(scrollCols)
    local wishlistIndex = Anchors.FindColumnIndex(scrollCols, "wishlist")
    if wishlistIndex then
        local noteIndex = Anchors.FindColumnIndex(scrollCols, "wishlistNote")
        if noteIndex and noteIndex == wishlistIndex + 1 then
            return noteIndex + 1, "wishlistNote"
        end
        return wishlistIndex + 1, "wishlist"
    end

    local gear1Index = Anchors.FindColumnIndex(scrollCols, "gear1")
    if gear1Index then
        return gear1Index, "gear1"
    end

    local gear2Index = Anchors.FindColumnIndex(scrollCols, "gear2")
    if gear2Index then
        return gear2Index, "gear2"
    end

    local diffIndex = Anchors.FindColumnIndex(scrollCols, "diff")
    if diffIndex then
        return diffIndex + 1, "diff"
    end

    local responseIndex = Anchors.FindColumnIndex(scrollCols, "response")
    if responseIndex then
        return responseIndex + 1, "response"
    end

    return (type(scrollCols) == "table" and (#scrollCols + 1) or 1), "append"
end
