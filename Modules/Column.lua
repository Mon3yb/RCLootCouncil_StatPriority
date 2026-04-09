local _, ns = ...

if not (ns and ns.RC and ns.module) then
    return
end

local module = ns.module
local RC = ns.RC
local Anchors = ns.Anchors
local Format = ns.Format

local function getVotingFrame()
    return RC:GetModule("RCVotingFrame", true)
end

local function refreshVotingFrameLayout(votingFrame)
    if not votingFrame then
        return
    end

    local frame = votingFrame.frame
    if not frame and votingFrame.GetFrame then
        frame = votingFrame:GetFrame()
    end

    if frame and frame.st then
        frame.st:SetDisplayCols(votingFrame.scrollCols)
        if frame.st.Refresh then
            frame.st:Refresh()
        end
        frame:SetWidth(frame.st.frame:GetWidth() + 20)
    end
end

function module:OnInitialize()
    self:TryInstallColumn()
end

function module:TryInstallColumn()
    local votingFrame = getVotingFrame()
    if not (votingFrame and votingFrame.scrollCols) then
        self:ScheduleTimer("TryInstallColumn", 0.5)
        return
    end

    -- RCLootCouncil's current voting-frame implementation explicitly keeps custom
    -- columns in `RCVotingFrame.scrollCols`, so we inject there instead of replacing
    -- any row builders or cell update internals.
    if not self:IsHooked(votingFrame, "OnEnable") then
        self:SecureHook(votingFrame, "OnEnable", "EnsureColumnPlacement")
    end

    self:EnsureColumnPlacement()
end

function module:CreateColumnDefinition()
    return {
        name = ns.COLUMN_HEADER,
        DoCellUpdate = module.SetCellStatPriority,
        colName = ns.COLUMN_ID,
        width = ns.COLUMN_WIDTH,
    }
end

function module:EnsureColumnPlacement()
    local votingFrame = getVotingFrame()
    if not (votingFrame and votingFrame.scrollCols) then
        self:ScheduleTimer("TryInstallColumn", 0.5)
        return
    end

    local scrollCols = votingFrame.scrollCols
    local sortTargets = Anchors.CaptureSortTargets(scrollCols)
    local currentIndex = Anchors.FindColumnIndex(scrollCols, ns.COLUMN_ID)
    local columnDefinition = currentIndex and table.remove(scrollCols, currentIndex) or self:CreateColumnDefinition()
    local targetIndex, anchorReason = Anchors.FindInsertionIndex(scrollCols)

    table.insert(scrollCols, targetIndex, columnDefinition)
    Anchors.RestoreSortTargets(votingFrame, sortTargets)

    self.columnInstalled = true
    self.anchorReason = anchorReason

    if currentIndex ~= targetIndex then
        refreshVotingFrameLayout(votingFrame)
    end
end

function module:GetCurrentSession(votingFrame)
    if votingFrame and votingFrame.GetCurrentSession then
        return votingFrame:GetCurrentSession()
    end

    return 1
end

function module:GetCandidateIdentity(candidateName)
    local votingFrame = getVotingFrame()
    local session = self:GetCurrentSession(votingFrame)
    return Format.GetCandidateIdentity(votingFrame, session, candidateName)
end

function module.SetCellStatPriority(rowFrame, frame, data, cols, row, realrow, column)
    local candidateName = data and data[realrow] and data[realrow].name or nil
    local candidate = module:GetCandidateIdentity(candidateName)
    local cellText = Format.BuildCellText(candidate.classToken, candidate.specName)
    local title, tooltipText = Format.BuildTooltip(candidateName, candidate.classToken, candidate.specName)

    if frame.text then
        frame.text:SetText(cellText)
        frame.text:SetJustifyH("LEFT")
    end

    if data and data[realrow] and data[realrow].cols and data[realrow].cols[column] then
        data[realrow].cols[column].value = cellText
    end

    -- Tooltip content is rebuilt from the currently selected spec so the row stays
    -- compact while still exposing every hardcoded class spec on hover.
    frame:SetScript("OnEnter", function()
        RC:CreateTooltip(title, tooltipText)
    end)
    frame:SetScript("OnLeave", function()
        RC:HideTooltip()
    end)
end
