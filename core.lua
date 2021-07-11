local AddonName, Addon = ...

DEFAULT_CHAT_FRAME:AddMessage("HelloWorld is Loaded!", 0.0, 1.0, 0.0)

lootingTable = Addon.lootingTable

function announce(self, event, ...)
    local loots = GetLootInfo()
    local linkstext
    for index = 1, GetNumLootItems() do
        local item
        if (lootSlotIsItem(loots[index])) then
            local itemName = loots[index]["item"]
            local itemLink = GetLootSlotLink(index);
            local candidates = getCadidatesForItem(itemName)
            SendChatMessage(itemLink .. candidates, "SAY", nil, nil)
        end
    end
end

-- 0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact
function lootSlotIsItem(itemInfo)
    return itemInfo.quality > 0
end

function getCadidatesForItem(itemName)
    if (lootingTable[itemName] ~= nil) then
        local candidatesString = ""
        for i = 1, #lootingTable[itemName] do
            candidatesString = candidatesString .. lootingTable[itemName][i]
            if (i ~= #lootingTable[itemName]) then
                candidatesString = candidatesString .. ", "
            end
        end
        return " listed by " .. candidatesString
    end
    return " no one listed."
end

-- test
function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

-- register event to loot
local f = CreateFrame("Frame", "MyAddOnFrame", nil);
f:RegisterEvent("LOOT_OPENED");
f:RegisterEvent("OPEN_MASTER_LOOT_LIST");
f:RegisterEvent("ADDON_LOADED");
f:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out
f:SetScript("OnEvent", announce);

MyAddon = {};
MyAddon.panel = CreateFrame("Frame", "MyAddonPanel", UIParent);
-- Register in the Interface Addon Options GUI
-- Set the name for the Category for the Options Panel
MyAddon.panel.name = "MyAddon";
-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(MyAddon.panel);

-- Make a child panel
MyAddon.childpanel = CreateFrame("Frame", "MyAddonChild", MyAddon.panel);
MyAddon.childpanel.name = "MyChild";
-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
MyAddon.childpanel.parent = MyAddon.panel.name;
-- Add the child to the Interface Options
InterfaceOptions_AddCategory(MyAddon.childpanel);

function SC_ChaChingPanel_OnLoad(panel)
    -- Set the name for the Category for the Panel
    panel.name = "SC_ChaChing " .. GetAddOnMetadata("SC_ChaChing", "Version");

    -- When the player clicks okay, run this function.
    panel.okay = function(self)
        SC_ChaChingPanel_Close();
    end;

    -- When the player clicks cancel, run this function.
    panel.cancel = function(self)
        SC_ChaChingPanel_CancelOrLoad();
    end;
    -- Add the panel to the Interface Options
    --
    InterfaceOptions_AddCategory(panel);
end
