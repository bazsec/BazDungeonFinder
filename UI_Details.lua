local addon = BazDF
local PANEL_HEIGHT    = 180
local PADDING         = 10
local ROLE_SIZE       = 22
local WAIT_BAR_HEIGHT = 14
local PROPOSAL_DURATION = 40

local BG_COLOR     = { 0.05, 0.05, 0.08, 0.90 }
local EDGE_COLOR   = { 0.3, 0.3, 0.35, 0.8 }
local DIM          = { 0.5, 0.5, 0.55 }
local FILLED       = { 0.3, 0.85, 0.3 }
local EMPTY        = { 0.25, 0.25, 0.28 }
local TANK_CLR     = { 0.3, 0.5, 1.0 }
local HEALER_CLR   = { 0.3, 0.9, 0.3 }
local DPS_CLR      = { 0.9, 0.3, 0.3 }
local PROPOSAL_CLR = { 0.2, 1.0, 0.2 }

local ROLE_ATLASES = { tank = "roleicon-tank", healer = "roleicon-healer", dps = "roleicon-dps" }

local panel = CreateFrame("Frame", "BazDungeonFinderDetails", BazDungeonFinderBar, "BackdropTemplate")
panel:SetSize(300, PANEL_HEIGHT)
panel:SetPoint("TOP", BazDungeonFinderBar, "BOTTOM", 0, 2)
panel:SetFrameStrata("MEDIUM")
panel:SetFrameLevel(99)
panel:Hide()
panel:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
})
panel:SetBackdropColor(unpack(BG_COLOR))
panel:SetBackdropBorderColor(unpack(EDGE_COLOR))
addon.DetailsPanel = panel

-- Group composition header
local groupLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
groupLabel:SetPoint("TOPLEFT", PADDING, -PADDING)
groupLabel:SetText("GROUP")
groupLabel:SetTextColor(unpack(DIM))

-- Role slots (1 tank, 1 healer, 3 dps)
local roleSlots = {}
local slotX = PADDING
for _, def in ipairs({
    { role = "tank",   count = 1 },
    { role = "healer", count = 1 },
    { role = "dps",    count = 3 },
}) do
    for i = 1, def.count do
        local slot = CreateFrame("Frame", nil, panel)
        slot:SetSize(ROLE_SIZE, ROLE_SIZE)
        slot:SetPoint("TOPLEFT", slotX, -(PADDING + 16))

        slot.bg = slot:CreateTexture(nil, "BACKGROUND")
        slot.bg:SetAllPoints()
        slot.bg:SetColorTexture(unpack(EMPTY))

        slot.icon = slot:CreateTexture(nil, "ARTWORK")
        slot.icon:SetSize(ROLE_SIZE - 4, ROLE_SIZE - 4)
        slot.icon:SetPoint("CENTER")
        slot.icon:SetAtlas(ROLE_ATLASES[def.role])
        slot.icon:SetVertexColor(0.4, 0.4, 0.4)

        slot.role = def.role
        slot.index = i
        table.insert(roleSlots, slot)
        slotX = slotX + ROLE_SIZE + 4
    end
    slotX = slotX + 6
end

-- Dungeon info
local dungeonLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
dungeonLabel:SetPoint("TOPLEFT", PADDING, -(PADDING + 16 + ROLE_SIZE + 12))
dungeonLabel:SetText("DUNGEON")
dungeonLabel:SetTextColor(unpack(DIM))

local dungeonName = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
dungeonName:SetPoint("TOPLEFT", dungeonLabel, "BOTTOMLEFT", 0, -2)
dungeonName:SetWidth(280)
dungeonName:SetJustifyH("LEFT")

local dungeonType = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
dungeonType:SetPoint("LEFT", dungeonName, "RIGHT", 6, 0)
dungeonType:SetTextColor(unpack(DIM))

-- Wait time bars
local waitLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
waitLabel:SetPoint("TOPLEFT", dungeonName, "BOTTOMLEFT", 0, -12)
waitLabel:SetText("ESTIMATED WAIT")
waitLabel:SetTextColor(unpack(DIM))

local function CreateWaitBar(anchor, offsetY, label, color)
    local row = CreateFrame("Frame", nil, panel)
    row:SetSize(280, WAIT_BAR_HEIGHT)
    row:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, offsetY)

    row.label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.label:SetPoint("LEFT")
    row.label:SetText(label)
    row.label:SetTextColor(unpack(color))
    row.label:SetWidth(50)
    row.label:SetJustifyH("LEFT")

    row.bar = CreateFrame("StatusBar", nil, row)
    row.bar:SetPoint("LEFT", row.label, "RIGHT", 4, 0)
    row.bar:SetPoint("RIGHT", row, "RIGHT", -40, 0)
    row.bar:SetHeight(WAIT_BAR_HEIGHT - 2)
    row.bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    row.bar:SetStatusBarColor(color[1], color[2], color[3], 0.7)
    row.bar:SetMinMaxValues(0, 1)

    row.bar.bg = row.bar:CreateTexture(nil, "BACKGROUND")
    row.bar.bg:SetAllPoints()
    row.bar.bg:SetColorTexture(0.1, 0.1, 0.12, 0.8)

    row.time = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.time:SetPoint("LEFT", row.bar, "RIGHT", 4, 0)
    row.time:SetTextColor(unpack(DIM))

    return row
end

local tankBar   = CreateWaitBar(waitLabel, -2, "Tank",   TANK_CLR)
local healerBar = CreateWaitBar(tankBar,   -2, "Healer", HEALER_CLR)
local dpsBar    = CreateWaitBar(healerBar, -2, "DPS",    DPS_CLR)

-- Proposal countdown
local proposalFrame = CreateFrame("Frame", nil, panel)
proposalFrame:SetSize(280, 24)
proposalFrame:SetPoint("BOTTOMLEFT", PADDING, PADDING)
proposalFrame:Hide()

proposalFrame.text = proposalFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
proposalFrame.text:SetPoint("LEFT")
proposalFrame.text:SetText("Group Found!")
proposalFrame.text:SetTextColor(unpack(PROPOSAL_CLR))

proposalFrame.bar = CreateFrame("StatusBar", nil, proposalFrame)
proposalFrame.bar:SetPoint("LEFT", proposalFrame.text, "RIGHT", 8, 0)
proposalFrame.bar:SetPoint("RIGHT")
proposalFrame.bar:SetHeight(8)
proposalFrame.bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
proposalFrame.bar:SetStatusBarColor(unpack(PROPOSAL_CLR))
proposalFrame.bar:SetMinMaxValues(0, 1)
proposalFrame.bar:SetValue(1)
proposalFrame.bar.bg = proposalFrame.bar:CreateTexture(nil, "BACKGROUND")
proposalFrame.bar.bg:SetAllPoints()
proposalFrame.bar.bg:SetColorTexture(0.1, 0.1, 0.12, 0.8)

local proposalElapsed = 0
proposalFrame:SetScript("OnUpdate", function(_, dt)
    if not addon.Queue.proposalActive then
        proposalElapsed = 0
        return
    end
    proposalElapsed = proposalElapsed + dt
    local remaining = math.max(0, PROPOSAL_DURATION - proposalElapsed)
    proposalFrame.bar:SetValue(remaining / PROPOSAL_DURATION)
    if remaining <= 0 then proposalElapsed = 0 end
end)

-- Refresh (uses Blizzard's formula: found = total - needs)
function BazDF:RefreshDetails()
    if not panel:IsShown() then return end
    local Q = self.Queue

    local tankFound   = (Q.totalTanks or 0) - (Q.tankNeeds or 0)
    local healerFound = (Q.totalHealers or 0) - (Q.healerNeeds or 0)
    local dpsFound    = (Q.totalDPS or 0) - (Q.dpsNeeds or 0)

    for _, slot in ipairs(roleSlots) do
        local found = 0
        if slot.role == "tank" then found = tankFound
        elseif slot.role == "healer" then found = healerFound
        elseif slot.role == "dps" then found = dpsFound end

        if slot.index <= found then
            slot.bg:SetColorTexture(FILLED[1], FILLED[2], FILLED[3], 0.4)
            slot.icon:SetVertexColor(1, 1, 1)
        else
            slot.bg:SetColorTexture(EMPTY[1], EMPTY[2], EMPTY[3], 0.6)
            slot.icon:SetVertexColor(0.4, 0.4, 0.4)
        end
    end

    dungeonName:SetText(Q.dungeonName ~= "" and Q.dungeonName or "Unknown")
    dungeonType:SetText(Q.category == 1 and "Dungeon" or Q.category == 3 and "Raid Finder" or "")

    local maxWait = math.max(Q.tankWait, Q.healerWait, Q.damageWait, 1)
    tankBar.bar:SetValue(Q.tankWait / maxWait)
    tankBar.time:SetText(Q:FormatEstimate(Q.tankWait))
    healerBar.bar:SetValue(Q.healerWait / maxWait)
    healerBar.time:SetText(Q:FormatEstimate(Q.healerWait))
    dpsBar.bar:SetValue(Q.damageWait / maxWait)
    dpsBar.time:SetText(Q:FormatEstimate(Q.damageWait))

    proposalFrame:SetShown(Q.proposalActive)
end

panel:SetScript("OnShow", function(self)
    self:SetWidth(BazDungeonFinderBar:GetWidth())
    BazDF:RefreshDetails()
end)
