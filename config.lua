local _, Addon = ...;

-- local Title = select(2, GetAddOnInfo(Name)):gsub("%s*v?[%d%.]+$", "");
-- local Version = GetAddOnMetadata(Name, "Version");
-- local Author = GetAddOnMetadata(Name, "Author");
Addon.Config = {}
local Config = Addon.Config;
local UIConfig;

local defaults = {
    theme = {
        r = 0,
        g = 0.8, -- 204/255
        b = 1,
        hex = "00ccff"
    }
}

function Config:Toggle()
    local menu = UIConfig or Config:CreateMenu();
    menu:SetShown(not menu:IsShown());
end

function Config:GetThemeColor()
    local c = defaults.theme;
    return c.r, c.g, c.b, c.hex;
end

function Config:CreateButton(point, relativeFrame, relativePoint, yOffset, text)
    local btn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
    btn:SetPoint(point, relativeFrame, relativePoint, 0, yOffset);
    btn:SetSize(140, 40);
    btn:SetText(text);
    btn:SetNormalFontObject("GameFontNormalLarge");
    btn:SetHighlightFontObject("GameFontHighlightLarge");
    return btn;
end

--------------------------
--[[	Options Panel	]] --------------------------
-- local Changes = SyncOptions({}, Options);

-- local Panel = CreateFrame("Frame")

-- do
--     Panel:Hide();

--     Panel.name = "TMBLoot";
--     InterfaceOptions_AddCategory(Panel); --	Panel Registration
--     Addon.OptionsPanel = Panel;

--     -- do
--     --     local title = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
--     --     title:SetPoint("TOP", 0, -12);
--     --     title:SetText(Title);

--     --     local author = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
--     --     author:SetPoint("TOP", title, "BOTTOM", 0, 0);
--     --     author:SetTextColor(1, 0.5, 0.25);
--     --     author:SetText("by " .. Author);

--     --     local ver = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
--     --     ver:SetPoint("TOPLEFT", title, "TOPRIGHT", 4, 0);
--     --     ver:SetTextColor(0.5, 0.5, 0.5);
--     --     ver:SetText("v" .. Version);
--     -- end

--     do
--         local b = CreateFrame("Button", nil, Panel, "GameMenuButtonTemplate")
--         b:SetWidth(200)
--         b:SetHeight(25)
--         b:SetPoint("TOPLEFT", 15, -80)
--         b:SetText("Open TMBLoot")
--         b:SetScript("OnClick", function()
--             Config:CreateMenu()
--         end)
--     end

-- end

-- Panel:RegisterEvent("ADDON_LOADED");
-- Panel:SetScript("OnEvent", function(self, event, ...)
--     if event == "ADDON_LOADED" and (...) == Name then
--         -- ChatLinkIcons_Options = SyncOptions(Options, ChatLinkIcons_Options, true);
--         -- SyncOptions(Changes, Options, true);

--         self:UnregisterEvent(event);
--     end
-- end);

-- SLASH_TmbLoot1 = '/tmbloot'
-- SlashCmdList.TmbLoot = Config:Toggle()

function Config:CreateMenu()
    local UIConfig = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    UIConfig:SetWidth(650)
    UIConfig:SetHeight(600)
    UIConfig:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {
            left = 8,
            right = 8,
            top = 10,
            bottom = 10
        }
    })

    UIConfig:SetBackdropColor(0, 0, 0)
    UIConfig:SetPoint("CENTER", 0, 0)
    UIConfig:SetToplevel(true)
    UIConfig:EnableMouse(true)
    UIConfig:SetMovable(true)
    UIConfig:RegisterForDrag("LeftButton")
    UIConfig:SetScript("OnDragStart", UIConfig.StartMoving)
    UIConfig:SetScript("OnDragStop", UIConfig.StopMovingOrSizing)
    UIConfig:Hide()

    do
        local t = UIConfig:CreateTexture(nil, "ARTWORK")
        t:SetTexture("Interface/DialogFrame/UI-DialogBox-Header")
        t:SetWidth(256)
        t:SetHeight(64)
        t:SetPoint("TOP", UIConfig, 0, 12)
        UIConfig.texture = t
    end

    do
        local t = UIConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        t:SetText("TMBList")
        t:SetPoint("TOP", UIConfig.texture, 0, -14)
    end

    -- tooltip style container
    local t = CreateFrame("Frame", nil, UIConfig, BackdropTemplateMixin and "BackdropTemplate" or nil)
    t:SetWidth(600)
    t:SetHeight(450)
    t:SetPoint("TOPLEFT", UIConfig, 25, -40)
    t:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileEdge = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {
            left = 2,
            right = 2,
            top = 2,
            bottom = 2
        }
    })
    t:SetBackdropColor(0, 0, 0, 1)

    -- scrollable frame
    local s = CreateFrame("ScrollFrame", nil, t, "UIPanelScrollFrameTemplate") -- or your actual parent instead
    s:SetSize(560, 430)
    s:SetPoint("TOPLEFT", 10, -10)

    -- editbox frame
    local e = CreateFrame("EditBox", nil, s)
    e:SetMultiLine(true)
    e:SetFontObject(ChatFontNormal)
    e:SetWidth(560)
    e:SetScript("OnEscapePressed", e.ClearFocus)
    e:SetScript("OnTextSet", e.HighlightText)
    e:SetScript("OnMouseUp", e.HighlightText)
    e:SetAutoFocus(false)
    s:SetScrollChild(e)
    if LootingTable.paste == nil then
        e:SetText("past your csv here")
    else
        e:SetText(LootingTable.paste)
    end

    -- -- TextField Button:
    -- UIConfig.textarea = CreateFrame("EditBox", "TMBLootEditBox", UIConfig)
    -- UIConfig.textarea:SetPoint("TOPLEFT", UIConfig.child, "TOP", 10, 0)
    -- UIConfig.textarea:SetSize(280, 300)
    -- UIConfig.textarea:SetText("Paste the list here.");
    -- UIConfig.textarea:SetMultiLine(true)
    -- UIConfig.textarea:SetAutoFocus(false);
    -- UIConfig.textarea:SetMaxLetters(999999)

    -- Panel Button:
    UIConfig.saveButton = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate")
    UIConfig.saveButton:SetPoint("BOTTOM", UIConfig, "BOTTOMRIGHT", -100, 30)
    UIConfig.saveButton:SetSize(120, 30)
    UIConfig.saveButton:SetText("Save")
    UIConfig.saveButton:SetScript("OnClick", function()
        LootingTable = {}
        LootingTable.paste = e:GetText()
        if LootingTable.paste ~= nil then
            LootingTable.prio = Addon.F.transformByItemName(LootingTable.paste, 'prio')
            LootingTable.wishlist = Addon.F.transformByItemName(LootingTable.paste, 'wishlist')
        end
        UIConfig:Hide()
    end)
    UIConfig.saveButton:SetNormalFontObject("GameFontNormalLarge")
    UIConfig.saveButton:SetHighlightFontObject("GameFontHighLightLarge")

    UIConfig:Hide()
    return UIConfig
end

function MyGlobalFuncationName()

end
