local _, Addon = ...

lootSlotIsItem = Addon.F.lootSlotIsItem
getCadidatesForItem = Addon.F.getCadidatesForItem

local function announce(self, event, ...)
    local initConfig = LootingTable

    if IsInGroup() then channel = 'PARTY' end
    if IsInRaid() then channel = 'RAID' end

    if LootingTable == nil then LootingTable = {} end

    local wishlistTable = LootingTable.wishlist
    local prioTable = LootingTable.prio
    local channel = nil

    if (channel ~= nil) then
        local loots = GetLootInfo()
        for index = 1, GetNumLootItems() do
            if (lootSlotIsItem(loots[index])) then
                local itemName = loots[index]["item"]
                local itemLink = GetLootSlotLink(index);

                -- announce prio-list for the item
                local prioCandidates = getCadidatesForItem(prioTable, itemName,
                                                           'prio-list')
                if prioCandidates ~= nil then
                    SendChatMessage("----- " .. itemLink .. " Prio List -----",
                                    channel, nil, nil)
                    SendChatMessage(prioCandidates, channel, nil, nil)
                end

                -- announce wishlist for the item
                local wishlistCandidates =
                    getCadidatesForItem(wishlistTable, itemName, 'wishlist')
                if wishlistCandidates ~= nil then
                    SendChatMessage("----- " .. itemLink .. " Wishlist -----",
                                    channel, nil, nil)
                    SendChatMessage(wishlistCandidates, channel, nil, nil)
                    SendChatMessage("--------------------", channel, nil, nil)
                end

            end
        end
    end
end

-- register event to loot
local f = CreateFrame("Frame", "LootingFrame", nil);
f:RegisterEvent("LOOT_OPENED");
f:SetScript("OnEvent", announce);
