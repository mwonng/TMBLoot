local _, Addon = ...; -- Namespace

--------------------------------------
-- Custom Slash Command
--------------------------------------
Addon.commands = {
    ["show"] = Addon.Config.Toggle, -- this is a function (no knowledge of Config object)

    ["help"] = function()
        print(" ");
        Addon:Print("List of slash commands:")
        Addon:Print("|cff00cc66/tl show|r - shows config menu");
        Addon:Print("|cff00cc66/tl help|r - shows help info");
        print(" ");
    end
};

local function HandleSlashCommands(str)
    if (#str == 0) then
        -- User just entered "/at" with no additional args.
        Addon.commands.help();
        -- Addon.commands.config();
        return;
    end

    local args = {};
    for _, arg in ipairs({string.split(' ', str)}) do
        if (#arg > 0) then table.insert(args, arg); end
    end

    local path = Addon.commands; -- required for updating found table.

    for id, arg in ipairs(args) do
        if (#arg > 0) then -- if string length is greater than 0.
            arg = arg:lower();
            if (path[arg]) then
                if (type(path[arg]) == "function") then
                    -- all remaining args passed to our function!
                    path[arg](select(id + 1, unpack(args)));
                    return;
                elseif (type(path[arg]) == "table") then
                    path = path[arg]; -- another sub-table found!
                end
            else
                -- does not exist!
                Addon.commands.help();
                return;
            end
        end
    end
end

function Addon:Print(...)
    local hex = select(4, self.Config:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "TMB Loot:");
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end

-- WARNING: self automatically becomes events frame!
function Addon:init(event, name)
    if (name ~= "ThatsmybisLoot") then return end

    SLASH_TMBLoot1 = "/tl";
    SLASH_TMBLoot2 = "/tmbloot";
    SlashCmdList.TMBLoot = HandleSlashCommands;

    Addon:Print("Thanks for supporting TMBList", UnitName("player") .. "!");
end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", Addon.init);
