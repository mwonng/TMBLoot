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

-- local file = io.open('all-loot-export.csv');
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
        local type, raid_group_name, member_name, character_name, character_class, character_is_alt,
            character_inactive_at, character_note, sort_order, item_name, item_id, is_offspec, note, received_at,
            import_id, item_note, item_prio_note, item_tier, item_tier_label, created_at, updated_at = line:match(
            "%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-)")

        if (type == recordType and character_class ~= nil) then
            itemNameWithoutDoubleQuote = string.gsub(item_name, '"', "")
            if (tableByItemName[itemNameWithoutDoubleQuote] == nil) then
                tableByItemName[itemNameWithoutDoubleQuote] = {character_name}
            else
                table.insert(tableByItemName[itemNameWithoutDoubleQuote], character_name)
            end
            -- print(character_name .. " " .. character_class .. " - " .. item_name)
        end
    end
    return tableByItemName;
end
Addon.F.transformByItemName = transformByItemName
