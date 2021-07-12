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
