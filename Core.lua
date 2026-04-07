-- BazDungeonFinder Core
-- Addon lifecycle via BazCore framework

local ADDON_NAME = "BazDungeonFinder"

local addon
addon = BazCore:RegisterAddon(ADDON_NAME, {
    title = "BazDungeonFinder",
    savedVariable = "BazDungeonFinderSV",
    profiles = true,
    defaults = {
        barWidth      = 340,
        barOpacity    = 0.85,
        barScale      = 100,
        autoShow      = true,
        showEstWait   = true,
        showRoleIcons = true,
        showEyeTooltip = true,
        hideBagsBar   = false,
        fadeMenuBar   = false,
        position      = nil,
    },

    slash = { "/bdf", "/bazdungeonfinder" },
    commands = {
        reset = {
            desc = "Reset bar position",
            handler = function()
                addon:ResetPosition()
                addon:Print("Position reset.")
            end,
        },
        show = {
            desc = "Show the bar",
            handler = function()
                if addon.Bar then addon.Bar:Show() end
            end,
        },
        hide = {
            desc = "Hide the bar",
            handler = function()
                if addon.Bar then addon.Bar:Hide() end
            end,
        },
        test = {
            desc = "Show the bar for testing",
            handler = function()
                if addon.Bar then
                    addon.Bar:Show()
                    addon.Bar:SetAlpha(addon:GetSetting("barOpacity") or 0.85)
                end
            end,
        },
    },

    minimap = {
        label = "BazDungeonFinder",
        icon = 134030,
    },

    onReady = function(self)
        self:SetupBar()
    end,
})

-- addon.db is auto-wired by BazCore:CreateDBProxy() in RegisterAddon

function addon:ResetPosition()
    self:SetSetting("position", nil)
    if self.Bar then
        self.Bar:ClearAllPoints()
        self.Bar:SetPoint("TOP", UIParent, "TOP", 0, -100)
    end
end

-- Reload prompt for settings that require it
StaticPopupDialogs["BAZDUNGEONFINDER_RELOAD"] = {
    text = "This change requires a UI reload. Reload now?",
    button1 = "Reload",
    button2 = "Later",
    OnAccept = function() ReloadUI() end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

-- Shared color constants (used by UI_Bar and UI_Details)
addon.COLORS = {
    bg         = { 0.05, 0.05, 0.08, 0.88 },
    edge       = { 0.3, 0.3, 0.35, 0.8 },
    accent     = { 0.3, 0.7, 1.0 },
    dim        = { 0.5, 0.5, 0.55 },
    filled     = { 0.3, 0.85, 0.3 },
    empty      = { 0.25, 0.25, 0.28 },
    proposal   = { 0.2, 1.0, 0.2 },
    tank       = { 0.3, 0.5, 1.0 },
    healer     = { 0.3, 0.9, 0.3 },
    dps        = { 0.9, 0.3, 0.3 },
}
addon.ROLE_ATLASES = { tank = "roleicon-tank", healer = "roleicon-healer", dps = "roleicon-dps" }
