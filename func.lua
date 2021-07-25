local AddonName, Addon = ...
Addon.F = {}

-- 0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact
local function lootSlotIsItem(itemInfo) return itemInfo.quality > 0 end
Addon.F.lootSlotIsItem = lootSlotIsItem

-- test
local function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end
Addon.F.dump = dump

local function getCadidatesForItem(table, itemName, type)
    if (table[itemName] ~= nil) then
        local candidatesString = ""
        for i = 1, #table[itemName] do
            candidatesString = candidatesString .. table[itemName][i]
            if (i ~= #table[itemName]) then
                candidatesString = candidatesString .. ", "
            end
        end
        return candidatesString
    end
    return nil
end
Addon.F.getCadidatesForItem = getCadidatesForItem

-- transform data, reform by itemName
-- filtered by type
local function transformByItemName(csv, recordType)
    local tableByItemName = {}
    local csvLines = {}

    local first = true
    for row in csv:gmatch("[^\n]+") do
        if first then -- this is to handle the first line and capture our headers.
            first = false -- set first to false to switch off the header block
        else
            table.insert(csvLines, row)
        end
    end

    for k, line in pairs(csvLines) do -- load file name
        local type, character_name, character_class, character_is_alt,
              character_inactive_at, character_note, sort_order, item_id,
              is_offspec, received_at, item_prio_note, item_tier_label =
            line:match(
                "%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-)")
        if (type == recordType and character_class ~= nil) then
            itemIdWithoutDoubleQuote = string.gsub(item_id, '"', "")
            if (tableByItemName[itemIdWithoutDoubleQuote] == nil) then
                tableByItemName[itemIdWithoutDoubleQuote] = {character_name}
            else
                table.insert(tableByItemName[itemIdWithoutDoubleQuote],
                             character_name)
            end
        end
    end
    return tableByItemName;
end
Addon.F.transformByItemName = transformByItemName
