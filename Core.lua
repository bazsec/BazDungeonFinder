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

-- db proxy for backward compatibility
local dbProxy = {}
local profileProxy = setmetatable({}, {
    __index = function(_, key)
        local sv = _G["BazDungeonFinderSV"]
        if not sv then return nil end
        local profileName = BazCore:GetActiveProfile(ADDON_NAME)
        local profile = sv.profiles and sv.profiles[profileName]
        if profile then return profile[key] end
        return nil
    end,
    __newindex = function(_, key, value)
        local sv = _G["BazDungeonFinderSV"]
        if not sv then return end
        local profileName = BazCore:GetActiveProfile(ADDON_NAME)
        if not sv.profiles then sv.profiles = {} end
        if not sv.profiles[profileName] then sv.profiles[profileName] = {} end
        sv.profiles[profileName][key] = value
    end,
})
dbProxy.profile = profileProxy
addon.db = dbProxy

function addon:GetSetting(key)
    return self.db.profile[key]
end

function addon:SetSetting(key, value)
    self.db.profile[key] = value
end

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

-- Make addon accessible for other files
BazDF = addon
