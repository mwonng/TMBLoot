local AddonName, Addon = ...

DEFAULT_CHAT_FRAME:AddMessage("HelloWorld is Loaded!", 0.0, 1.0, 0.0)

local lootingTable = Addon.lootingTable

function announce(self, event, ...)
    local loots = GetLootInfo()
    local linkstext
    for index = 1, GetNumLootItems() do
        local item
        if (lootSlotIsItem(loots[index])) then
            local itemName = loots[index]["item"]
            local itemLink = GetLootSlotLink(index);
            local candidates = getCadidatesForItem(itemName)
            SendChatMessage(itemLink .. candidates, "PARTY", nil, nil)
        end
    end
end

-- 0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact
function lootSlotIsItem(itemInfo)
    return itemInfo.quantity > 2
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

-- register event to loot
local f = CreateFrame("Frame", "MyAddOnFrame", nil);
f:RegisterEvent("LOOT_OPENED");
f:RegisterEvent("OPEN_MASTER_LOOT_LIST");
f:SetScript("OnEvent", announce);

