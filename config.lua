local Name, AddOn = ...;

local Title = select(2, GetAddOnInfo(Name)):gsub("%s*v?[%d%.]+$", "");
local Version = GetAddOnMetadata(Name, "Version");
local Author = GetAddOnMetadata(Name, "Author");

local Options = {};
AddOn.Options = Options;

local function SyncOptions(new, old, merge)
    --	This is practicly a table copy function to copy values from old to new
    --	new will always be the table modified and is the same table returned
    --	old shall always remain untouched
    --	merge controls if shared keys are overwritten

    --	Exception handling
    if old == nil then
        return new;
    end --		If old is missing, return new
    if type(old) ~= "table" then
        return old;
    end --	If old is non-table, return old
    if type(new) ~= "table" then
        new = {};
    end --	If new is non-table, overwrite; proceed with copying of old

    for i, j in pairs(old) do
        local val = rawget(new, i);
        if merge or val == nil then
            rawset(new, i, SyncOptions(val, j, merge));
        end
    end
    return new;
end

local Defaults = {
    Links = {
        --		Case-sensitive, needs to be the same string that appears as "|H<LinkType>:"
        achievement = true,
        item = true,
        player = true,
        spell = true
    },
    Icons = {
        Race = true,
        Class = true
    },

    PawnIntegration = true
};

--------------------------
--[[	Options Panel	]] --------------------------
local Changes = SyncOptions({}, Options);
local Panel = CreateFrame("Frame");

do
    Panel:Hide();

    Panel.name = Title;
    InterfaceOptions_AddCategory(Panel); --	Panel Registration
    AddOn.OptionsPanel = Panel;

    do
        local title = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
        title:SetPoint("TOP", 0, -12);
        title:SetText(Title);

        local author = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
        author:SetPoint("TOP", title, "BOTTOM", 0, 0);
        author:SetTextColor(1, 0.5, 0.25);
        author:SetText("by " .. Author);

        local ver = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
        ver:SetPoint("TOPLEFT", title, "TOPRIGHT", 4, 0);
        ver:SetTextColor(0.5, 0.5, 0.5);
        ver:SetText("v" .. Version);

    end
end

Panel:RegisterEvent("ADDON_LOADED");
Panel:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and (...) == Name then
        ChatLinkIcons_Options = SyncOptions(Options, ChatLinkIcons_Options, true);
        SyncOptions(Changes, Options, true);
        self:UnregisterEvent(event);
    end
end);

----------------------------------
--[[	Options Controls	]] ----------------------------------
local Buttons = {};
local BuildButton;
do --	function BuildButton(tbl,var,txt,x,y)
    local function OnClick(self)
        self.Table[self.Var] = self:GetChecked();
    end
    local function Refresh(self)
        self:SetChecked(self:IsEnabled() and self.Table[self.Var]);
    end
    function BuildButton(tbl, var, txt, x, y)
        local btn = CreateFrame("CheckButton", nil, Panel, "UICheckButtonTemplate");
        btn:SetPoint("TOPLEFT", x, y);
        btn.text:SetText(txt or var:gsub("^(.)", string.upper));
        btn:SetScript("OnClick", OnClick);

        btn.Table = tbl;
        btn.Var = var;
        btn.Refresh = Refresh;

        Buttons[#Buttons + 1] = btn;
        return btn;
    end
end

do --	LinkButtons
    local list = {};
    for i, j in pairs(Defaults.Links) do
        list[#list + 1] = i;
    end
    table.sort(list);
    for i, j in ipairs(list) do
        BuildButton(Changes.Links, j, nil, 24, -i * 24 - 24);
    end
end

BuildButton(Changes.Icons, "Race", "Race/Gender", 128, -96);
BuildButton(Changes.Icons, "Class", nil, 256, -96);

local PawnIsLoaded = IsAddOnLoaded("Pawn");
local PawnButton = BuildButton(Changes, "PawnIntegration", "Pawn Integration |cff" ..
    (PawnIsLoaded and "00ff00" or "ff0000") .. "(Requires Pawn)|r", 24, -200);
if not PawnIsLoaded then
    PawnButton:Disable();
    PawnButton.text:SetTextColor(0.5, 0.5, 0.5);
end
