-- BazDungeonFinder Bar UI
-- Queue status bar with Edit Mode integration via BazCore

local addon = BazCore:GetAddon("BazDungeonFinder")
local BAR_HEIGHT   = 82
local ICON_SIZE    = 18
local PADDING      = 12
local FADE_TIME    = 0.3
-- CONTENT_LEFT is where the non-eye content begins. With the eye removed
-- (BazDrawer now owns that capture) the content starts at the bar's
-- normal left padding.
local CONTENT_LEFT = PADDING

-- Colors from addon.COLORS (defined in Core.lua)
local C = addon.COLORS
local BG_COLOR     = C.bg
local EDGE_COLOR   = C.edge
local ACCENT_COLOR = C.accent
local DIM_COLOR    = C.dim
local FILLED_CLR   = C.filled
local ROLE_ATLASES = addon.ROLE_ATLASES
local ROLE_COLORS  = { tank = C.tank, healer = C.healer, dps = C.dps }

-- Bar frame
local bar = CreateFrame("Frame", "BazDungeonFinderBar", UIParent, "BackdropTemplate")
bar:SetSize(340, BAR_HEIGHT)
bar:SetPoint("TOP", UIParent, "TOP", 0, -100)
bar:SetFrameStrata("MEDIUM")
bar:SetFrameLevel(100)
bar:SetClampedToScreen(true)
bar:Hide()
bar:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
})
bar:SetBackdropColor(unpack(BG_COLOR))
bar:SetBackdropBorderColor(unpack(EDGE_COLOR))
addon.Bar = bar

-- Green glow (behind bar)
local glowFrame = CreateFrame("Frame", nil, bar)
glowFrame:SetPoint("TOPLEFT", -8, 8)
glowFrame:SetPoint("BOTTOMRIGHT", 8, -8)
glowFrame:SetFrameLevel(bar:GetFrameLevel() - 1)
local glow = glowFrame:CreateTexture(nil, "OVERLAY")
glow:SetAllPoints()
glow:SetAtlas("loottoast-glow")
glow:SetVertexColor(0.1, 0.9, 0.3, 0.30)
glow:SetBlendMode("ADD")
local glowAG = glow:CreateAnimationGroup()
glowAG:SetLooping("BOUNCE")
local glowPulse = glowAG:CreateAnimation("Alpha")
glowPulse:SetFromAlpha(0.30)
glowPulse:SetToAlpha(0.10)
glowPulse:SetDuration(2.0)
glowPulse:SetSmoothing("IN_OUT")
glowAG:Play()

-- Eye section REMOVED — the QueueStatusButton / QueueStatusButtonIcon eye
-- graphic is now left alone in the micro menu so BazDrawer's MinimapButtons
-- widget can adopt it cleanly. BazDungeonFinder no longer reparents, hides,
-- or anchors any Blizzard queue eye frames.

-- Leave queue button
local leaveBtn = CreateFrame("Button", nil, bar)
leaveBtn:SetSize(16, 16)
leaveBtn:SetPoint("TOPRIGHT", -8, -8)
leaveBtn.tex = leaveBtn:CreateTexture(nil, "ARTWORK")
leaveBtn.tex:SetAllPoints()
leaveBtn.tex:SetAtlas("common-icon-redx")
leaveBtn.tex:SetVertexColor(0.7, 0.3, 0.3)
leaveBtn:SetScript("OnClick", function()
    if addon.Queue.category then LeaveLFG(addon.Queue.category) end
end)
leaveBtn:SetScript("OnEnter", function(self)
    self.tex:SetVertexColor(1, 0.4, 0.4)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:SetText("Leave Queue")
    GameTooltip:Show()
end)
leaveBtn:SetScript("OnLeave", function(self)
    self.tex:SetVertexColor(0.7, 0.3, 0.3)
    GameTooltip:Hide()
end)

-- Expand/collapse chevron
local expandBtn = CreateFrame("Button", nil, bar)
expandBtn:SetSize(16, 16)
expandBtn:SetPoint("RIGHT", leaveBtn, "LEFT", -6, 0)
expandBtn.tex = expandBtn:CreateTexture(nil, "ARTWORK")
expandBtn.tex:SetAllPoints()
expandBtn.tex:SetAtlas("campaign-QuestLog-LoreBook-pointed-arrow")
expandBtn.tex:SetVertexColor(0.7, 0.7, 0.7)
expandBtn.isExpanded = false
expandBtn:SetScript("OnClick", function(self)
    self.isExpanded = not self.isExpanded
    if self.isExpanded then
        self.tex:SetRotation(math.pi)
        if addon.DetailsPanel then addon.DetailsPanel:Show() end
    else
        self.tex:SetRotation(0)
        if addon.DetailsPanel then addon.DetailsPanel:Hide() end
    end
end)
expandBtn:SetScript("OnEnter", function(self) self.tex:SetVertexColor(1, 1, 1) end)
expandBtn:SetScript("OnLeave", function(self) self.tex:SetVertexColor(0.7, 0.7, 0.7) end)
bar.expandBtn = expandBtn

-- Row 1: Title
local titleText = bar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("TOP", bar, "TOP", (CONTENT_LEFT - PADDING) / 2, -6)
titleText:SetJustifyH("CENTER")
titleText:SetText("Dungeon Finder")
titleText:SetTextColor(0.9, 0.8, 0.5)
bar.titleText = titleText

-- Row 1b: Dungeon name
local dungeonText = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
dungeonText:SetPoint("TOP", titleText, "BOTTOM", 0, -2)
dungeonText:SetJustifyH("CENTER")
dungeonText:SetTextColor(DIM_COLOR[1], DIM_COLOR[2], DIM_COLOR[3])
dungeonText:SetWordWrap(false)

-- Row 2: Role slots + Avg Wait
local rolesGroup = CreateFrame("Frame", nil, bar)
rolesGroup:SetHeight(ICON_SIZE)

local roleSlots = {}
local prevAnchor
for _, def in ipairs({ { role = "tank" }, { role = "healer" }, { role = "dps" } }) do
    local slot = {}
    slot.icon = rolesGroup:CreateTexture(nil, "ARTWORK")
    slot.icon:SetSize(ICON_SIZE, ICON_SIZE)
    if prevAnchor then
        slot.icon:SetPoint("LEFT", prevAnchor, "RIGHT", 8, 0)
    else
        slot.icon:SetPoint("LEFT", rolesGroup, "LEFT", 0, 0)
    end
    slot.icon:SetAtlas(ROLE_ATLASES[def.role])
    slot.text = rolesGroup:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    slot.text:SetPoint("LEFT", slot.icon, "RIGHT", 3, 0)
    slot.text:SetText("0/0")
    slot.role = def.role
    roleSlots[def.role] = slot
    prevAnchor = slot.text
end
rolesGroup:SetWidth((ICON_SIZE + 3 + 18) * 3 + 8 * 2)

local sep1 = bar:CreateTexture(nil, "ARTWORK")
sep1:SetSize(1, 14)
sep1:SetColorTexture(0.3, 0.3, 0.35, 0.6)

local avgWaitLabel = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
avgWaitLabel:SetText("Avg Wait:")
avgWaitLabel:SetTextColor(DIM_COLOR[1], DIM_COLOR[2], DIM_COLOR[3])
local avgWaitValue = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
avgWaitValue:SetPoint("LEFT", avgWaitLabel, "RIGHT", 4, 0)
avgWaitValue:SetTextColor(1, 1, 1)

-- Row 3: In Queue timer
local queueTimeLabel = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
queueTimeLabel:SetText("In Queue:")
queueTimeLabel:SetTextColor(DIM_COLOR[1], DIM_COLOR[2], DIM_COLOR[3])
local queueTimeValue = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
queueTimeValue:SetPoint("LEFT", queueTimeLabel, "RIGHT", 4, 0)
queueTimeValue:SetTextColor(ACCENT_COLOR[1], ACCENT_COLOR[2], ACCENT_COLOR[3])

-- Dynamic layout for rows 2-3
local function LayoutRows()
    local w = bar:GetWidth() - CONTENT_LEFT - PADDING
    local halfW = w / 2
    local left = CONTENT_LEFT

    rolesGroup:ClearAllPoints()
    rolesGroup:SetPoint("CENTER", bar, "TOPLEFT", left + halfW / 2, -46)
    sep1:ClearAllPoints()
    sep1:SetPoint("CENTER", bar, "TOPLEFT", left + halfW, -46)
    avgWaitLabel:ClearAllPoints()
    avgWaitLabel:SetPoint("RIGHT", bar, "TOPLEFT", left + halfW + halfW / 2 - 2, -46)
    queueTimeLabel:ClearAllPoints()
    queueTimeLabel:SetPoint("RIGHT", bar, "TOPLEFT", left + w / 2 - 2, -64)
end

bar:HookScript("OnSizeChanged", LayoutRows)
bar:HookScript("OnShow", LayoutRows)

-- Refresh display
local function RefreshBar()
    local Q = addon.Queue
    if not Q.isQueued then return end

    dungeonText:SetText(Q.dungeonName ~= "" and Q.dungeonName or "")

    local function UpdateSlot(slot, total, needs)
        local max = total or 0
        local found = max - (needs or 0)
        slot.text:SetText(max > 0 and (found .. "/" .. max) or "0/0")
        if max > 0 and found >= max then
            slot.text:SetTextColor(FILLED_CLR[1], FILLED_CLR[2], FILLED_CLR[3])
            slot.icon:SetAlpha(1)
        else
            local clr = ROLE_COLORS[slot.role]
            slot.text:SetTextColor(clr[1], clr[2], clr[3])
            slot.icon:SetAlpha(0.5)
        end
    end
    UpdateSlot(roleSlots.tank,   Q.totalTanks,   Q.tankNeeds)
    UpdateSlot(roleSlots.healer, Q.totalHealers,  Q.healerNeeds)
    UpdateSlot(roleSlots.dps,    Q.totalDPS,      Q.dpsNeeds)

    local waitTime = Q.myWait > 0 and Q.myWait or Q.averageWait
    avgWaitValue:SetText(waitTime > 0 and Q:FormatEstimate(waitTime) or "N/A")
    queueTimeValue:SetText(Q:FormatTime(Q.queuedTime))

    if Q.proposalActive then
        titleText:SetTextColor(0.2, 1.0, 0.2)
        titleText:SetText("Group Found!")
    else
        titleText:SetTextColor(0.9, 0.8, 0.5)
        titleText:SetText("Dungeon Finder")
    end
end

-- Instance mode state
local inInstance = false
local instanceStartTime = 0

local function RefreshInstanceBar()
    local name, instanceType, difficultyID, difficultyName = GetInstanceInfo()

    titleText:SetTextColor(0.3, 0.85, 0.3)
    titleText:SetText(difficultyName or "Dungeon")
    dungeonText:SetText(name or "")


    -- Boss progress via C_ScenarioInfo
    local killed, total = 0, 0
    if C_ScenarioInfo and C_ScenarioInfo.GetScenarioStepInfo then
        local stepInfo = C_ScenarioInfo.GetScenarioStepInfo()
        if stepInfo and stepInfo.numCriteria and stepInfo.numCriteria > 0 then
            for i = 1, stepInfo.numCriteria do
                local c = C_ScenarioInfo.GetCriteriaInfo(i)
                if c and c.totalQuantity and c.totalQuantity > 0 then
                    total = total + 1
                    if c.quantity and c.quantity >= c.totalQuantity then
                        killed = killed + 1
                    end
                end
            end
        end
    end

    -- Center boss and duration as single strings
    local contentCenter = (CONTENT_LEFT - PADDING) / 2
    local bossStr = total > 0 and (killed .. "/" .. total) or "—"

    -- Use the label+value pair but center them together
    avgWaitLabel:SetText("Bosses: " .. bossStr)
    avgWaitLabel:SetFontObject(GameFontNormal)
    avgWaitLabel:ClearAllPoints()
    avgWaitLabel:SetPoint("CENTER", bar, "TOP", contentCenter, -44)
    avgWaitLabel:SetJustifyH("CENTER")
    if total > 0 and killed >= total then
        avgWaitLabel:SetTextColor(0.3, 0.85, 0.3)
    else
        avgWaitLabel:SetTextColor(1, 1, 1)
    end
    avgWaitValue:SetText("")

    queueTimeLabel:SetText("Duration: " .. addon.Queue:FormatTime(GetTime() - instanceStartTime))
    queueTimeLabel:ClearAllPoints()
    queueTimeLabel:SetPoint("CENTER", bar, "TOP", contentCenter, -64)
    queueTimeLabel:SetJustifyH("CENTER")
    queueTimeLabel:SetTextColor(0.5, 0.5, 0.55)
    queueTimeValue:SetText("")

    -- Hide role slots (not relevant in dungeon)
    rolesGroup:Hide()
    sep1:Hide()
end

-- Instance action buttons (teleport out / leave group)
local teleportBtn = CreateFrame("Button", nil, bar)
teleportBtn:SetSize(16, 16)
teleportBtn:SetPoint("BOTTOMRIGHT", -8, 8)
teleportBtn.tex = teleportBtn:CreateTexture(nil, "ARTWORK")
teleportBtn.tex:SetAllPoints()
teleportBtn.tex:SetAtlas("Taxi_Frame_Gray")
teleportBtn.tex:SetVertexColor(0.7, 0.7, 0.7)
teleportBtn:Hide()
teleportBtn:SetScript("OnClick", function()
    local _, instanceType = IsInInstance()
    local insideDungeon = (instanceType == "party" or instanceType == "raid")
    LFGTeleport(insideDungeon)
end)
teleportBtn:SetScript("OnEnter", function(self)
    self.tex:SetVertexColor(1, 1, 1)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    local _, instanceType = IsInInstance()
    local insideDungeon = (instanceType == "party" or instanceType == "raid")
    GameTooltip:SetText(insideDungeon and "Teleport Out" or "Teleport In")
    GameTooltip:Show()
end)
teleportBtn:SetScript("OnLeave", function(self)
    self.tex:SetVertexColor(0.7, 0.7, 0.7)
    GameTooltip:Hide()
end)

StaticPopupDialogs["BAZDUNGEONFINDER_LEAVE_GROUP"] = {
    text = "Are you sure you want to leave the instance group?",
    button1 = "Leave",
    button2 = "Cancel",
    OnAccept = function() C_PartyInfo.LeaveParty() end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

local function EnterInstanceMode()
    inInstance = true
    instanceStartTime = GetTime()
    rolesGroup:Hide()
    sep1:Hide()
    teleportBtn:Show()

    -- Repurpose leave queue button as leave group
    leaveBtn:SetScript("OnClick", function()
        StaticPopup_Show("BAZDUNGEONFINDER_LEAVE_GROUP")
    end)
    leaveBtn:SetScript("OnEnter", function(self)
        self.tex:SetVertexColor(1, 0.4, 0.4)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Leave Instance Group")
        GameTooltip:Show()
    end)
    bar:SetAlpha(addon:GetSetting("barOpacity") or 0.85)
    bar:Show()
    RefreshInstanceBar()
end

local function ExitInstanceMode()
    inInstance = false
    rolesGroup:Show()
    sep1:Show()
    teleportBtn:Hide()

    -- Restore leave queue button
    leaveBtn:SetScript("OnClick", function()
        if addon.Queue.category then LeaveLFG(addon.Queue.category) end
    end)
    leaveBtn:SetScript("OnEnter", function(self)
        self.tex:SetVertexColor(1, 0.4, 0.4)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Leave Queue")
        GameTooltip:Show()
    end)
    avgWaitLabel:SetFontObject(GameFontHighlightSmall)
    avgWaitLabel:SetText("Avg Wait:")
    avgWaitLabel:SetTextColor(DIM_COLOR[1], DIM_COLOR[2], DIM_COLOR[3])
    avgWaitValue:SetTextColor(1, 1, 1)
    queueTimeLabel:SetText("In Queue:")
    queueTimeLabel:SetTextColor(DIM_COLOR[1], DIM_COLOR[2], DIM_COLOR[3])
    queueTimeValue:SetText("")
    LayoutRows()

    addon.Queue:Update()
    if not addon.Queue.isQueued then
        bar:Hide()
        if addon.DetailsPanel then
            addon.DetailsPanel:Hide()
            expandBtn.isExpanded = false
            expandBtn.tex:SetRotation(0)
        end
    else
        RefreshBar()
    end
end

-- Timer tick (1s)
local elapsed = 0
bar:SetScript("OnUpdate", function(_, dt)
    elapsed = elapsed + dt
    if elapsed < 1 then return end
    elapsed = 0

    local inInstanceGroup = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)

    if inInstanceGroup and not inInstance then
        EnterInstanceMode()
    elseif not inInstanceGroup and inInstance then
        ExitInstanceMode()
    end

    if inInstance then
        RefreshInstanceBar()
    elseif addon.Queue.isQueued and addon.Queue.queueStartTime > 0 then
        addon.Queue.queuedTime = GetTime() - addon.Queue.queueStartTime
        addon.Queue:Update()
        RefreshBar()
    end
end)

-- Auto-show/hide on queue state change
function addon:OnQueueUpdate()
    local Q = self.Queue
    if Q.isQueued then
        if not bar:IsShown() and self:GetSetting("autoShow") then
            bar:SetAlpha(0)
            bar:Show()
            UIFrameFadeIn(bar, FADE_TIME, 0, self:GetSetting("barOpacity") or 0.85)
        end
        RefreshBar()
        if self.RefreshDetails then self:RefreshDetails() end
    elseif bar:IsShown() and self:GetSetting("autoShow") then
        UIFrameFadeOut(bar, FADE_TIME, bar:GetAlpha(), 0)
        C_Timer.After(FADE_TIME, function()
            if not Q.isQueued then
                bar:Hide()
                if addon.DetailsPanel then
                    addon.DetailsPanel:Hide()
                    expandBtn.isExpanded = false
                    expandBtn.tex:SetRotation(0)
                end
            end
        end)
    end
end

function addon:OnSettingChanged(key, value)
    if key == "barWidth" then bar:SetWidth(value)
    elseif key == "barOpacity" then bar:SetAlpha(value) end
    if addon.Queue.isQueued then RefreshBar() end
end


local function SetupMenuFade()
    if not MicroMenuContainer or not addon:GetSetting("fadeMenuBar") then return end
    MicroMenuContainer:SetAlpha(0)
    local isHovered = false
    local fadeTimer
    local detect = CreateFrame("Frame")
    detect:SetScript("OnUpdate", function()
        local over = MicroMenuContainer:IsMouseOver(10, -10, -10, 10)
        if over and not isHovered then
            isHovered = true
            if fadeTimer then fadeTimer:Cancel(); fadeTimer = nil end
            UIFrameFadeIn(MicroMenuContainer, 0.3, MicroMenuContainer:GetAlpha(), 1)
        elseif not over and isHovered then
            isHovered = false
            fadeTimer = C_Timer.NewTimer(0.3, function()
                if not MicroMenuContainer:IsMouseOver(10, -10, -10, 10) then
                    UIFrameFadeOut(MicroMenuContainer, 0.3, MicroMenuContainer:GetAlpha(), 0)
                else
                    isHovered = true
                end
                fadeTimer = nil
            end)
        end
    end)
end

local function SetupBagsHide()
    if not BagsBar or not addon:GetSetting("hideBagsBar") then return end
    BagsBar:Hide()
    BagsBar:SetParent(addon.hiddenFrame or CreateFrame("Frame"))
    hooksecurefunc(BagsBar, "Show", function(self) self:Hide() end)
end

-- Setup bar: restore position, register Edit Mode, init subsystems
function addon:SetupBar()
    bar:SetWidth(self:GetSetting("barWidth") or 340)
    bar:SetAlpha(self:GetSetting("barOpacity") or 0.85)
    bar:SetScale((self:GetSetting("barScale") or 100) / 100)

    local pos = self:GetSetting("position")
    if pos and pos.x and pos.y then
        local ux, uy = UIParent:GetCenter()
        local ues = UIParent:GetEffectiveScale()
        local es = bar:GetEffectiveScale()
        bar:ClearAllPoints()
        bar:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (pos.x + ux * ues) / es, (pos.y + uy * ues) / es)
    end

    -- Register with BazCore Edit Mode
    BazCore:RegisterEditModeFrame(bar, {
        label = "BazDungeonFinder",
        addonName = "BazDungeonFinder",
        positionKey = "position",
        defaultPosition = { x = 0, y = 0 },

        settings = {
            { type = "slider", key = "barWidth", label = "Bar Width", section = "Appearance",
              min = 200, max = 500, step = 10,
              get = function() return addon:GetSetting("barWidth") or 340 end,
              set = function(v)
                  addon:SetSetting("barWidth", v)
                  bar:SetWidth(v)
              end },
            { type = "slider", key = "barOpacity", label = "Bar Opacity", section = "Appearance",
              min = 30, max = 100, step = 5,
              format = function(v) return math.floor(v + 0.5) .. "%" end,
              get = function() return math.floor((addon:GetSetting("barOpacity") or 0.85) * 100 + 0.5) end,
              set = function(v)
                  addon:SetSetting("barOpacity", v / 100)
                  bar:SetAlpha(v / 100)
              end },
            { type = "slider", key = "barScale", label = "Bar Scale", section = "Appearance",
              min = 50, max = 200, step = 1,
              format = function(v) return math.floor(v + 0.5) .. "%" end,
              get = function() return addon:GetSetting("barScale") or 100 end,
              set = function(v)
                  local cx, cy = bar:GetCenter()
                  local oldScale = bar:GetScale()
                  if cx and cy then cx = cx * oldScale; cy = cy * oldScale end
                  addon:SetSetting("barScale", v)
                  bar:SetScale(v / 100)
                  if cx and cy then
                      bar:ClearAllPoints()
                      bar:SetPoint("CENTER", UIParent, "BOTTOMLEFT", cx / (v / 100), cy / (v / 100))
                  end
              end },
            { type = "nudge", section = "Appearance" },

            { type = "checkbox", key = "autoShow", label = "Auto Show/Hide", section = "Behavior",
              get = function() return addon:GetSetting("autoShow") ~= false end,
              set = function(v) addon:SetSetting("autoShow", v) end },
        },

        actions = {
            { label = "Reset Position", builtin = "resetPosition" },
        },

        onEnter = function(f)
            if not f:IsShown() then
                f:SetAlpha(addon:GetSetting("barOpacity") or 0.85)
                f:Show()
                f._bazEditShown = true
            end
        end,

        onExit = function(f)
            if f._bazEditShown and not addon.Queue.isQueued then
                f:Hide()
                f._bazEditShown = nil
            end
        end,
    })

    -- Resize handle (only visible in Edit Mode)
    local resizer = BazCore:MakeResizable(bar, {
        getScale = function() return addon:GetSetting("barScale") or 100 end,
        setScale = function(pct)
            addon:SetSetting("barScale", pct)
            bar:SetScale(pct / 100)
        end,
        minScale = 50,
        maxScale = 200,
    })
    resizer:Hide()

    BazCore:On("BazDungeonFinder", "BAZ_EDITMODE_ENTER", function()
        resizer:Show()
    end)
    BazCore:On("BazDungeonFinder", "BAZ_EDITMODE_EXIT", function()
        resizer:Hide()
    end)

    SetupMenuFade()
    SetupBagsHide()
    LayoutRows()

    self.Queue:Update()
    if self.Queue.isQueued then
        bar:Show()
        RefreshBar()
    end
end
