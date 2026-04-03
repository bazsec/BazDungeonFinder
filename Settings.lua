local PAD    = 16
local CBSIZE = 20

local function ReloadPrompt()
    StaticPopup_Show("BAZDUNGEONFINDER_RELOAD")
end

local function InitSettings()
    local panel = CreateFrame("Frame", nil, UIParent)
    panel:Hide()

    local content = CreateFrame("Frame", nil, panel)
    content:SetAllPoints()

    local yPos = -PAD

    local title = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", PAD, yPos)
    title:SetText("BazDungeonFinder")
    yPos = yPos - 20

    local sub = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", PAD, yPos)
    sub:SetText("Detached LFG queue status bar")
    sub:SetTextColor(0.6, 0.6, 0.6)
    yPos = yPos - 26

    local function Header(text)
        yPos = yPos - 8
        local h = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        h:SetPoint("TOPLEFT", PAD, yPos)
        h:SetText(text)
        yPos = yPos - 22
    end

    local function Checkbox(key, labelText, descText, onClick)
        local cb = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
        cb:SetPoint("TOPLEFT", PAD, yPos)
        cb:SetSize(CBSIZE, CBSIZE)
        cb:SetChecked(BazDF:GetSetting(key))

        local label = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        label:SetPoint("LEFT", cb, "RIGHT", 4, 0)
        label:SetText(labelText)

        cb:SetScript("OnClick", function(self)
            BazDF:SetSetting(key, self:GetChecked())
            if onClick then onClick(self:GetChecked()) end
        end)
        yPos = yPos - CBSIZE - 2

        if descText then
            local desc = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            desc:SetPoint("TOPLEFT", PAD + CBSIZE + 4, yPos)
            desc:SetText(descText)
            desc:SetTextColor(0.5, 0.5, 0.5)
            desc:SetWidth(400)
            desc:SetJustifyH("LEFT")
            yPos = yPos - 16
        end
        yPos = yPos - 4
    end

    local function Slider(key, labelText, minVal, maxVal, step)
        local label = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        label:SetPoint("TOPLEFT", PAD, yPos)
        label:SetText(labelText)
        yPos = yPos - 18

        local slider = CreateFrame("Slider", nil, content, "OptionsSliderTemplate")
        slider:SetPoint("TOPLEFT", PAD, yPos)
        slider:SetWidth(250)
        slider:SetMinMaxValues(minVal, maxVal)
        slider:SetValueStep(step)
        slider:SetObeyStepOnDrag(true)
        slider:SetValue(BazDF:GetSetting(key))
        slider.Low:SetText(tostring(minVal))
        slider.High:SetText(tostring(maxVal))

        local valText = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        valText:SetPoint("LEFT", slider, "RIGHT", 10, 0)
        valText:SetText(tostring(BazDF:GetSetting(key)))

        slider:SetScript("OnValueChanged", function(_, value)
            value = math.floor(value / step + 0.5) * step
            BazDF:SetSetting(key, value)
            valText:SetText(tostring(value))
        end)
        yPos = yPos - 30
    end

    Header("Appearance")
    Slider("barWidth", "Bar Width", 200, 500, 10)
    Slider("barOpacity", "Bar Opacity", 30, 100, 5)

    yPos = yPos - 10
    Header("Behavior")
    Checkbox("locked", "Lock Position", "Prevent the bar from being dragged")
    Checkbox("autoShow", "Auto Show/Hide", "Automatically show when queued, hide when not")

    yPos = yPos - 10
    Header("Display")
    Checkbox("showEstWait", "Show Estimated Wait", "Display the estimated wait time on the bar")
    Checkbox("showRoleIcons", "Show Role Icons", "Display your queued role icons on the bar")

    yPos = yPos - 10
    Header("UI Elements")
    Checkbox("hideBagsBar", "Hide Bags Bar", "Hide the bag slot buttons", ReloadPrompt)
    Checkbox("fadeMenuBar", "Fade Micro Menu", "Hide the micro menu until hovered", ReloadPrompt)

    local category = Settings.RegisterCanvasLayoutCategory(panel, "BazDungeonFinder")
    Settings.RegisterAddOnCategory(category)
    BazDF.SettingsCategory = category
end

-- Opacity slider stores 30-100, convert to 0.3-1.0 for rendering
local origGetSetting = BazDF.GetSetting
function BazDF:GetSetting(key)
    local val = origGetSetting(self, key)
    if key == "barOpacity" and type(val) == "number" and val > 1 then
        return val / 100
    end
    return val
end

EventUtil.ContinueOnAddOnLoaded("BazDungeonFinder", InitSettings)
