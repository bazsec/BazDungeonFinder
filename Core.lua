local ADDON_NAME = "BazDungeonFinder"

BazDF = BazDF or {}
BazDF.Settings = {}
BazDF.hiddenFrame = CreateFrame("Frame")
BazDF.hiddenFrame:Hide()

local DEFAULTS = {
    barWidth      = 340,
    barOpacity    = 0.85,
    locked        = false,
    autoShow      = true,
    showEstWait   = true,
    showRoleIcons = true,
    hideBagsBar   = false,
    fadeMenuBar   = false,
    posX          = nil,
    posY          = nil,
}

function BazDF:GetSetting(key)
    local db = BazDungeonFinderSV and BazDungeonFinderSV.settings
    if db and db[key] ~= nil then return db[key] end
    return DEFAULTS[key]
end

function BazDF:SetSetting(key, value)
    BazDungeonFinderSV = BazDungeonFinderSV or {}
    BazDungeonFinderSV.settings = BazDungeonFinderSV.settings or {}
    BazDungeonFinderSV.settings[key] = value
    BazDF.Settings[key] = value
    if BazDF.OnSettingChanged then
        BazDF:OnSettingChanged(key, value)
    end
end

StaticPopupDialogs["BAZDUNGEONFINDER_RELOAD"] = {
    text = "This change requires a UI reload. Reload now?",
    button1 = "Reload",
    button2 = "Later",
    OnAccept = function() ReloadUI() end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, _, arg1)
    if arg1 ~= ADDON_NAME then return end
    BazDungeonFinderSV = BazDungeonFinderSV or {}
    BazDungeonFinderSV.settings = BazDungeonFinderSV.settings or {}
    BazDF.DB = BazDungeonFinderSV
    for k in pairs(DEFAULTS) do
        BazDF.Settings[k] = BazDF:GetSetting(k)
    end
    print("|cff3399ffBazDungeonFinder|r loaded. Type |cff00ff00/bdf|r for commands.")
    self:UnregisterEvent("ADDON_LOADED")
end)

SLASH_BAZDUNGEONFINDER1 = "/bdf"
SLASH_BAZDUNGEONFINDER2 = "/bazdungeonfinder"
SlashCmdList["BAZDUNGEONFINDER"] = function(msg)
    local cmd = strlower(strtrim(msg))
    if cmd == "lock" then
        BazDF:SetSetting("locked", true)
        print("|cff3399ffBazDungeonFinder|r: Bar locked.")
    elseif cmd == "unlock" then
        BazDF:SetSetting("locked", false)
        print("|cff3399ffBazDungeonFinder|r: Bar unlocked. Drag to reposition.")
    elseif cmd == "reset" then
        BazDF:SetSetting("posX", nil)
        BazDF:SetSetting("posY", nil)
        if BazDF.Bar then
            BazDF.Bar:ClearAllPoints()
            BazDF.Bar:SetPoint("TOP", UIParent, "TOP", 0, -100)
        end
        print("|cff3399ffBazDungeonFinder|r: Position reset.")
    elseif cmd == "settings" then
        if BazDF.SettingsCategory then
            Settings.OpenToCategory(BazDF.SettingsCategory:GetID())
        end
    elseif cmd == "show" then
        if BazDF.Bar then BazDF.Bar:Show() end
    elseif cmd == "hide" then
        if BazDF.Bar then BazDF.Bar:Hide() end
    else
        print("|cff3399ffBazDungeonFinder|r commands:")
        print("  |cff00ff00/bdf lock|r - Lock bar position")
        print("  |cff00ff00/bdf unlock|r - Unlock bar position")
        print("  |cff00ff00/bdf reset|r - Reset bar position")
        print("  |cff00ff00/bdf settings|r - Open settings")
        print("  |cff00ff00/bdf show|r / |cff00ff00hide|r - Toggle bar")
    end
end
