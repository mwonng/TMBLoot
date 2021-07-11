local AddonName, Addon = ...
Addon.F = {}

-- 0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact
local function lootSlotIsItem(itemInfo)
    return itemInfo.quality > 0
end
Addon.F.lootSlotIsItem = lootSlotIsItem

-- test
local function dump(o)
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

local function getCadidatesForItem(table, itemName, type)
    if (table[itemName] ~= nil) then
        local candidatesString = ""
        for i = 1, #table[itemName] do
            candidatesString = candidatesString .. table[itemName][i]
            if (i ~= #table[itemName]) then
                candidatesString = candidatesString .. ", "
            end
        end
        return " " .. type .. " by " .. candidatesString
    end
    return nil
end
Addon.F.getCadidatesForItem = getCadidatesForItem
