local AddonName, Addon = ...

-- this data is manually update now
wishlistTable = Addon.wishlistTable
prioTable = Addon.prioTable

lootSlotIsItem = Addon.F.lootSlotIsItem
getCadidatesForItem = Addon.F.getCadidatesForItem

function announce(self, event, ...)
    local loots = GetLootInfo()
    for index = 1, GetNumLootItems() do
        if (lootSlotIsItem(loots[index])) then
            local itemName = loots[index]["item"]
            local itemLink = GetLootSlotLink(index);

            -- announce prio-list for the item
            local prioCandidates = getCadidatesForItem(prioTable, itemName, 'prio-list')
            if prioCandidates ~= nil then
                SendChatMessage(itemLink .. prioCandidates, "PARTY", nil, nil)
            end

            -- announce wishlist for the item
            local wishlistCandidates = getCadidatesForItem(wishlistTable, itemName, 'wishlist')
            if wishlistCandidates ~= nil then
                SendChatMessage(itemLink .. wishlistCandidates, "PARTY", nil, nil)
            end

        end
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
