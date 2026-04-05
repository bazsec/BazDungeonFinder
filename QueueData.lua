local Queue = {}
BazDF.Queue = Queue

local LFG_CAT_LFD = 1
local LFG_CAT_RF  = 3

Queue.isQueued       = false
Queue.category       = nil
Queue.queuedTime     = 0
Queue.queueStartTime = 0
Queue.myWait         = 0
Queue.averageWait    = 0
Queue.tankWait       = 0
Queue.healerWait     = 0
Queue.damageWait     = 0
Queue.tankNeeds      = 0
Queue.healerNeeds    = 0
Queue.dpsNeeds       = 0
Queue.totalTanks     = 0
Queue.totalHealers   = 0
Queue.totalDPS       = 0
Queue.dungeonName    = ""
Queue.dungeonType    = ""
Queue.proposalActive = false

local function FindActiveCategory()
    for _, cat in ipairs({ LFG_CAT_LFD, LFG_CAT_RF }) do
        local mode = GetLFGMode(cat)
        if mode and mode ~= "none" then
            return cat
        end
    end
end

local function GetActiveQueueID(cat)
    local id = GetPartyLFGID and GetPartyLFGID()
    if id and id > 0 then return id end
    if GetLFGQueuedList then
        local list = GetLFGQueuedList(cat)
        if list and #list > 0 then return list[1] end
    end
end

function Queue:Update()
    local cat = FindActiveCategory()
    if not cat then
        self.isQueued = false
        self.category = nil
        self.queuedTime = 0
        self.queueStartTime = 0
        return
    end

    local wasQueued = self.isQueued
    self.category = cat
    self.isQueued = true

    if not wasQueued then
        self.queueStartTime = GetTime()
        self.queuedTime     = 0
        self.myWait         = 0
        self.averageWait    = 0
        self.tankWait       = 0
        self.healerWait     = 0
        self.damageWait     = 0
        self.tankNeeds      = 0
        self.healerNeeds    = 0
        self.dpsNeeds       = 0
        self.totalTanks     = 0
        self.totalHealers   = 0
        self.totalDPS       = 0
        self.dungeonName    = ""
        self.dungeonType    = ""
    end

    self.queuedTime = GetTime() - self.queueStartTime

    local hasData, leaderNeeds, tankNeeds, healerNeeds, dpsNeeds,
          totalTanks, totalHealers, totalDPS, instanceType, instanceSubType,
          instanceName, averageWait, tankWait, healerWait, damageWait,
          myWait, queuedTime = GetLFGQueueStats(cat, GetActiveQueueID(cat))

    if hasData then
        self.myWait       = myWait or 0
        self.averageWait  = averageWait or 0
        self.tankWait     = tankWait or 0
        self.healerWait   = healerWait or 0
        self.damageWait   = damageWait or 0
        self.tankNeeds    = tankNeeds or 0
        self.healerNeeds  = healerNeeds or 0
        self.dpsNeeds     = dpsNeeds or 0
        self.totalTanks   = totalTanks or 0
        self.totalHealers = totalHealers or 0
        self.totalDPS     = totalDPS or 0
        self.dungeonName  = instanceName or ""
        self.dungeonType  = instanceType or ""
    end
end

function Queue:GetMyRoles()
    local tank, healer, dps = GetLFGRoles()
    return { tank = tank or false, healer = healer or false, dps = dps or false }
end

function Queue:FormatTime(seconds)
    if not seconds or seconds <= 0 then return "0:00" end
    seconds = math.floor(seconds)
    if seconds >= 3600 then
        return string.format("%d:%02d:%02d", math.floor(seconds / 3600),
            math.floor((seconds % 3600) / 60), seconds % 60)
    end
    return string.format("%d:%02d", math.floor(seconds / 60), seconds % 60)
end

function Queue:FormatEstimate(seconds)
    if not seconds or seconds <= 0 then return "N/A" end
    local m = math.floor(seconds / 60)
    if m < 1 then return "< 1 Min" end
    if m >= 60 then
        return string.format("%d Hr %d Min", math.floor(m / 60), m % 60)
    end
    return string.format("%d Min", m)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("LFG_UPDATE")
eventFrame:RegisterEvent("LFG_QUEUE_STATUS_UPDATE")
eventFrame:RegisterEvent("LFG_PROPOSAL_SHOW")
eventFrame:RegisterEvent("LFG_PROPOSAL_DONE")
eventFrame:RegisterEvent("LFG_PROPOSAL_FAILED")
eventFrame:RegisterEvent("LFG_PROPOSAL_SUCCEEDED")
eventFrame:RegisterEvent("LFG_COMPLETION_REWARD")
eventFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(_, event)
    if event == "LFG_PROPOSAL_SHOW" then
        Queue.proposalActive = true
    elseif event == "LFG_PROPOSAL_FAILED" or event == "LFG_PROPOSAL_DONE"
        or event == "LFG_PROPOSAL_SUCCEEDED" then
        Queue.proposalActive = false
    elseif event == "LFG_COMPLETION_REWARD" or event == "PLAYER_ENTERING_WORLD" then
        -- Entering dungeon or completing it — clear queue state
        Queue.proposalActive = false
    end
    Queue:Update()
    if BazDF.OnQueueUpdate then
        BazDF:OnQueueUpdate(event)
    end
end)
