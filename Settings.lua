-- BazDungeonFinder Settings
-- BazCore OptionsPanel integration

local ADDON_NAME = "BazDungeonFinder"
local addon = BazCore:GetAddon("BazDungeonFinder")

---------------------------------------------------------------------------
-- Landing Page
---------------------------------------------------------------------------

local function GetLandingPage()
    return BazCore:CreateLandingPage("BazDungeonFinder", {
        subtitle = "Detached LFG queue status bar",
        description = "A detached, draggable queue status bar that appears automatically when you enter the LFG queue. " ..
            "Replaces the micro menu eyeball with a rich, always-visible queue display.",
        features = "Dungeon name, queue timer, estimated wait, and role fill indicators. " ..
            "In-dungeon mode with boss kill progress, instance duration, and teleport/leave buttons. " ..
            "Full Edit Mode integration with BazCore for positioning and scaling.",
        guide = {
            { "Queue", "Join a dungeon finder queue and the bar appears automatically" },
            { "Positioning", "Enter Edit Mode to drag and resize the bar" },
            { "In Dungeon", "Bar switches to dungeon mode showing boss progress and duration" },
        },
        commands = {
            { "/bdf", "Open settings" },
            { "/bdf reset", "Reset bar position" },
        },
    })
end

---------------------------------------------------------------------------
-- Settings Page
---------------------------------------------------------------------------

local function GetSettingsPage()
    return {
        name = "Settings",
        type = "group",
        args = {
            appearanceHeader = {
                order = 1,
                type = "header",
                name = "Appearance",
            },
            barWidth = {
                order = 2,
                type = "range",
                name = "Bar Width",
                min = 200, max = 500, step = 10,
                get = function() return addon:GetSetting("barWidth") or 340 end,
                set = function(_, val)
                    addon:SetSetting("barWidth", val)
                    if addon.Bar then addon.Bar:SetWidth(val) end
                end,
            },
            barOpacity = {
                order = 3,
                type = "range",
                name = "Bar Opacity",
                min = 0.3, max = 1.0, step = 0.05,
                get = function() return addon:GetSetting("barOpacity") or 0.85 end,
                set = function(_, val)
                    addon:SetSetting("barOpacity", val)
                    if addon.Bar then addon.Bar:SetAlpha(val) end
                end,
            },
            barScale = {
                order = 4,
                type = "range",
                name = "Bar Scale",
                min = 0.5, max = 2.0, step = 0.05,
                get = function() return (addon:GetSetting("barScale") or 100) / 100 end,
                set = function(_, val)
                    addon:SetSetting("barScale", math.floor(val * 100 + 0.5))
                    if addon.Bar then addon.Bar:SetScale(val) end
                end,
            },
            behaviorHeader = {
                order = 10,
                type = "header",
                name = "Behavior",
            },
            autoShow = {
                order = 11,
                type = "toggle",
                name = "Auto Show/Hide",
                desc = "Automatically show when queued, hide when not",
                get = function() return addon:GetSetting("autoShow") ~= false end,
                set = function(_, val) addon:SetSetting("autoShow", val) end,
            },
            displayHeader = {
                order = 20,
                type = "header",
                name = "Display",
            },
            showEyeTooltip = {
                order = 21,
                type = "toggle",
                name = "Eye Tooltip",
                desc = "Show queue info tooltip when hovering the eye icon",
                get = function() return addon:GetSetting("showEyeTooltip") ~= false end,
                set = function(_, val) addon:SetSetting("showEyeTooltip", val) end,
            },
            showEstWait = {
                order = 22,
                type = "toggle",
                name = "Show Estimated Wait",
                desc = "Display the estimated wait time on the bar",
                get = function() return addon:GetSetting("showEstWait") ~= false end,
                set = function(_, val) addon:SetSetting("showEstWait", val) end,
            },
            showRoleIcons = {
                order = 23,
                type = "toggle",
                name = "Show Role Icons",
                desc = "Display your queued role icons on the bar",
                get = function() return addon:GetSetting("showRoleIcons") ~= false end,
                set = function(_, val) addon:SetSetting("showRoleIcons", val) end,
            },
            uiHeader = {
                order = 30,
                type = "header",
                name = "UI Elements",
            },
            hideBagsBar = {
                order = 31,
                type = "toggle",
                name = "Hide Bags Bar",
                desc = "Hide the bag slot buttons (requires reload)",
                get = function() return addon:GetSetting("hideBagsBar") or false end,
                set = function(_, val)
                    addon:SetSetting("hideBagsBar", val)
                    StaticPopup_Show("BAZDUNGEONFINDER_RELOAD")
                end,
            },
            fadeMenuBar = {
                order = 32,
                type = "toggle",
                name = "Fade Micro Menu",
                desc = "Hide the micro menu until hovered (requires reload)",
                get = function() return addon:GetSetting("fadeMenuBar") or false end,
                set = function(_, val)
                    addon:SetSetting("fadeMenuBar", val)
                    StaticPopup_Show("BAZDUNGEONFINDER_RELOAD")
                end,
            },
            actionsHeader = {
                order = 90,
                type = "header",
                name = "",
            },
            resetPos = {
                order = 91,
                type = "execute",
                name = "Reset Position",
                func = function() addon:ResetPosition(); addon:Print("Position reset.") end,
            },
        },
    }
end

---------------------------------------------------------------------------
-- Registration
---------------------------------------------------------------------------

addon.config = addon.config or {}
addon.config.onLoad = function(self)
    -- Landing page (main)
    BazCore:RegisterOptionsTable(ADDON_NAME, GetLandingPage)
    BazCore:AddToSettings(ADDON_NAME, "BazDungeonFinder")

    -- Settings subcategory
    BazCore:RegisterOptionsTable(ADDON_NAME .. "-Settings", GetSettingsPage)
    BazCore:AddToSettings(ADDON_NAME .. "-Settings", "Settings", ADDON_NAME)

    -- Profiles subcategory
    BazCore:RegisterOptionsTable(ADDON_NAME .. "-Profiles", function()
        return BazCore:GetProfileOptionsTable(ADDON_NAME)
    end)
    BazCore:AddToSettings(ADDON_NAME .. "-Profiles", "Profiles", ADDON_NAME)
end
