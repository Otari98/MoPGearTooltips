local _G = _G or getfenv(0)
local strfind = string.find
local strsub = string.sub
local strgsub = string.gsub
local strlower = string.lower
local tinsert = table.insert
local tremove = table.remove
local getn = table.getn

local Cooltip = CreateFrame("Frame", "Cooltip", GameTooltip)

local statsDB = {
    { stats=COOLTIP_PRIM_STATS,        color=COOLTIP_PRIM_STATS_COLOR },
    { stats=COOLTIP_SEC_STATS.vanilla, color=COOLTIP_SEC_STATS_COLOR },
}

local function twipe(t)
    for i = getn(t), 1, -1 do
        tremove(t, i)
    end
end

local originalTooltip = {}
for i = 1, 30 do
    tinsert(originalTooltip, i, { text = "", color = { r = 1, g = 1, b = 1, a = 1 }, })
end

local fixedTooltips = {}
local unchangedTooltips = {}

local function save(tooltipTypeStr)
    for i = 1, 30 do
        originalTooltip[i].text = _G[tooltipTypeStr .. 'TextLeft' .. i]:GetText() or ""
        local r, g, b, a = _G[tooltipTypeStr .. 'TextLeft' .. i]:GetTextColor()
        originalTooltip[i].color.r = r
        originalTooltip[i].color.g = g
        originalTooltip[i].color.b = b
        originalTooltip[i].color.a = a
    end
end

local lastLink
local lastTooltip
function Cooltip.adjustTooltip(tooltip, tooltipTypeStr)
    if tooltip.itemLink == lastLink and lastTooltip == tooltip then
        for row = 1, 30 do
            if originalTooltip[row].text ~= "" and row <= tooltip:NumLines() then
                _G[tooltipTypeStr .. 'TextLeft' .. row]:SetText(originalTooltip[row].text)
                _G[tooltipTypeStr .. 'TextLeft' .. row]:SetTextColor(
                    originalTooltip[row].color.r,
                    originalTooltip[row].color.g,
                    originalTooltip[row].color.b,
                    originalTooltip[row].color.a)
                _G[tooltipTypeStr .. 'TextLeft' .. row]:Show()
            end
        end
        tooltip:Show()
        return
    end
    lastLink = tooltip.itemLink
    lastTooltip = tooltip
    -- Collect all rows into lua table for analization
    for i = 1, 30 do
        originalTooltip[i].text = ""
        originalTooltip[i].color.r = 1
        originalTooltip[i].color.g = 1
        originalTooltip[i].color.b = 1
        originalTooltip[i].color.a = 1
    end

    for row = 1, 30 do
        local tooltipRow = _G[tooltipTypeStr .. 'TextLeft' .. row]
        if tooltipRow then
            local rowtext = tooltipRow:GetText()
            if rowtext then
                originalTooltip[row].text = rowtext
                local r, g, b, a = tooltipRow:GetTextColor()
                originalTooltip[row].color.r = r
                originalTooltip[row].color.g = g
                originalTooltip[row].color.b = b
                originalTooltip[row].color.a = a
            end
        end
    end

    -- Find out if the tooltip we're looking at is a piece of gear
    -- and what row the stats we want to edit start at
    local statsStartRow = 0
    local statsEndRow = 0
    local setbonusesStartRow = nil
    local isGear = false

    for row = 1, 30 do
        -- Gear is guaranteed to be labeled with the slot it occupies.
        for _, slot in pairs(COOLTIP_GEARSLOTS) do
            if slot == originalTooltip[row].text then
                isGear = true
                statsStartRow = row + 1
            end
        end
        local isEnchant, _ = Cooltip.parseEnchant(originalTooltip[row])
        if isEnchant or
            strfind(originalTooltip[row].text, "Socket", 1, true) or -- TBC
            strfind(originalTooltip[row].text, "Durability", 1, true) or
            strfind(originalTooltip[row].text, "Classes:", 1, true) or
            strfind(originalTooltip[row].text, "Item Level", 1, true) or -- WotLK
            strfind(originalTooltip[row].text, "Requires Level", 1, true) or
            strfind(originalTooltip[row].text, "—", 1, true) or -- emdash used only in rep reqs, like Requires The League of Arathor — Exalted
            strfind(originalTooltip[row].text, "Equip:", 1, true) or
            -- I know this next part is a complicated mess but this should catch every edge case
            (
                strfind(originalTooltip[row].text, "+", 1, true) and -- Catch lines starting with positive stats
                not strfind(originalTooltip[row].text, "-", 1, true) -- but not when both + and - on one line means elemental wep e.g. + 16 - 30 Nature Damage
            )
            or
            (
                row > 2 and -- don't catch -'s in the item name nor turtle xmog
                strfind(originalTooltip[row].text, "-", 1, true) and -- Catch items starting with negative stats
                not strfind(originalTooltip[row].text, "Damage", 1, true) and -- But don't count Weapon Damage lines
                not strfind(originalTooltip[row].text, "Hand", 1, true) and -- or the equip slot text Two-Hand, One-Hand
                not strfind(originalTooltip[row].text, "Equipped", 1, true) -- or gear marked Unique-Equipped
            )
        then
            -- We have found the first case of a +X Stat line,
            -- Or we have found that there are no normal stats and are at the bottom of where stats would be
            -- Either way we are definitely past the gear slot check.
            statsStartRow = row
            break
        end
    end
    if not isGear then
        return
    end

    -- find out if this gear has set bonuses where we end the stats section early
    for row = statsStartRow, 30 do
        if strfind(originalTooltip[row].text, "Set: ", 1, true) then
            statsEndRow = row - 1
            setbonusesStartRow = row
            break
        end
        -- if the above test never succeeds, the stats row
        -- will just naturally be the last row of the tooltip
        statsEndRow = row
    end

    -- check if has Armor, Damage, Durability, Stats, Slots...
    -- Get all stats, enchants, and meta info like dura, lv

    -- Correct lines and then sort them, sort lines, put enchant, then dura/lv/etc at bottom
    twipe(fixedTooltips)
    twipe(unchangedTooltips)

    for i = 1, statsEndRow - statsStartRow + 1 do
        local row = i + statsStartRow - 1
        local rowSlotted = false
        local isEnchant, replaceStr = Cooltip.parseEnchant(originalTooltip[row])

        if isEnchant then
            tinsert(unchangedTooltips, {
                text=replaceStr,
                color=COOLTIP_ENCHANTS_COLOR
            })
            rowSlotted = true
        elseif strfind(originalTooltip[row].text, "Chance on Hit:", 1, true) or
            strfind(originalTooltip[row].text, "Use:", 1, true)
        then
            -- These effects need to be left as is
            -- continue
        else
            -- Check against our db\Stats.lua table to see if this is a stat we can fix
            for _, statSet in ipairs(statsDB) do
                -- stat = { searchStr, valuePrefixStr, valueSuffixStr, newSuffixStr }
                for _,stat in ipairs(statSet.stats) do
                    if strfind(originalTooltip[row].text, stat[1], 1, false) then
                        local sign = strfind(originalTooltip[row].text, "^%-", 1, false) and "-" or "+"
                        local suffixRemoved = strgsub(originalTooltip[row].text, stat[3], "")
                        local foundValue = strgsub(suffixRemoved, stat[2], "")
                        if foundValue then
                            foundValue = strgsub(foundValue, "Equip: ", "")
                            tinsert(fixedTooltips, {
                                text=sign .. foundValue .. " " .. stat[4],
                                color=statSet.color,
                            })
                            rowSlotted = true
                        end
                    end
                end
            end
        end
        -- this isn't an enchant nor a stat we've corrected.
        -- put it in unchangedTooltips
        if not rowSlotted then
            tinsert(unchangedTooltips, {
                text=originalTooltip[row].text,
                color=originalTooltip[row].color
            })
        end
    end

    -- Combine fixedTooltips with unchangedTooltips
    for i = 1, getn(unchangedTooltips) do
        tinsert(fixedTooltips, unchangedTooltips[i])
    end

    -- Insert data from start to end row
    local statsLength = getn(fixedTooltips)
    for i = 1, statsLength do
        local row = i + statsStartRow - 1
        _G[tooltipTypeStr .. 'TextLeft' .. row]:SetText(fixedTooltips[i].text)
        _G[tooltipTypeStr .. 'TextLeft' .. row]:SetTextColor(
            fixedTooltips[i].color.r,
            fixedTooltips[i].color.g,
            fixedTooltips[i].color.b,
            fixedTooltips[i].color.a)
        _G[tooltipTypeStr .. 'TextLeft' .. row]:Show()
    end
    tooltip:Show()

    if not setbonusesStartRow then
        save(tooltipTypeStr)
        return
    end

    -- Analize set bonuses rows for problems, fix them, and make the change
    -- all in one go since we don't need to rearrange any lines here, they are in proper order.
    -- A repeat of code above, but compacted and with checks only relevant for sets
    -- Could use refactor
    for row = setbonusesStartRow, 30 do
        for _, statSet in ipairs(statsDB) do
            -- stat = { searchStr, valuePrefixStr, valueSuffixStr, newSuffixStr }
            for _,stat in ipairs(statSet.stats) do
                if strfind(originalTooltip[row].text, stat[1], 1, false) then
                    local suffixRemoved = strgsub(originalTooltip[row].text, stat[3], "")
                    local foundValue = strgsub(suffixRemoved, stat[2], "")
                    if foundValue then
                        local setPrefix = ""
                        local statStart, foundValueStart = strfind(foundValue, "Set: ", 1, true)
                        setPrefix = strsub(foundValue, 1, foundValueStart)
                        foundValue = strgsub(foundValue, ".*Set: ", "")
                        foundValue = strgsub(foundValue, "%.", "") -- There are an awful amount of set bonuses with random ass periods wtf
                        _G[tooltipTypeStr .. 'TextLeft' .. row]:SetText(
                            setPrefix .. "+" .. foundValue .. " " .. stat[4])
                        _G[tooltipTypeStr .. 'TextLeft' .. row]:SetTextColor(
                            originalTooltip[row].color.r,
                            originalTooltip[row].color.g,
                            originalTooltip[row].color.b,
                            originalTooltip[row].color.a)
                        _G[tooltipTypeStr .. 'TextLeft' .. row]:Show()
                    end
                end
            end
        end
    end
    save(tooltipTypeStr)
end

local enchantsDB = {COOLTIP_ENCHANTS.vanilla,}

function Cooltip.parseEnchant(row)
    if row.color.r == 0 and  --
        row.color.b == 0 and -- Green
        row.color.g > 0.999  --
    then
        for _, enchantSet in ipairs(enchantsDB) do
            for _, item in ipairs(enchantSet) do
                if strlower(row.text) == strlower(item[1]) then
                    return true, item[2] or item[1]
                end
            end
        end
    end
    return false, nil
end

Cooltip:SetScript("OnHide", function()
    GameTooltip.itemLink = nil
end)

Cooltip:SetScript("OnShow", function()
    if aux_frame and aux_frame:IsVisible() then
        if GetMouseFocus():GetParent() then
            if GetMouseFocus():GetParent().row then
                if GetMouseFocus():GetParent().row.record.link then
                    GameTooltip.itemLink = GetMouseFocus():GetParent().row.record.link
                end
            end
        end
    end
    if GameTooltip.itemLink then
        local _, _, itemLink = strfind(GameTooltip.itemLink, "(item:%d+:%d+:%d+:%d+)");
        if not itemLink then
            return false
        end
        Cooltip.adjustTooltip(GameTooltip, "GameTooltip")
    end
end)

ShoppingTooltip1:SetScript("OnShow", function()
    Cooltip.adjustTooltip(ShoppingTooltip1, "ShoppingTooltip1")
end)

ShoppingTooltip2:SetScript("OnShow", function()
    Cooltip.adjustTooltip(ShoppingTooltip2, "ShoppingTooltip2")
end)

Cooltip.HookAddonOrVariable = function(addon, func)
    local lurker = CreateFrame("Frame", nil)
    lurker.func = func
    lurker:RegisterEvent("ADDON_LOADED")
    lurker:RegisterEvent("VARIABLES_LOADED")
    lurker:RegisterEvent("PLAYER_ENTERING_WORLD")
    lurker:SetScript("OnEvent",function()
        if IsAddOnLoaded(addon) or getglobal(addon) then
            this:func()
            this:UnregisterAllEvents()
        end
    end)
end

Cooltip.HookAddonOrVariable("AtlasLoot", function()
    local atlas = CreateFrame("Frame", nil, AtlasLootTooltip)
    local atlas2 = CreateFrame("Frame", nil, AtlasLootTooltip2)

    atlas:SetScript("OnShow", function()
        if GetMouseFocus().dressingroomID and GetMouseFocus().dressingroomID ~= 0 and
                strsub(GetMouseFocus().itemID or "", 1, 1) ~= "s" and strsub(GetMouseFocus().itemID or "", 1, 1) ~= "e" then
            local itemName, itemString, itemQuality = GetItemInfo(GetMouseFocus().dressingroomID)
            if itemName then
                local _, _, _, hex = GetItemQualityColor(tonumber(itemQuality))
                AtlasLootTooltip.itemLink = hex.. "|H"..itemString.."|h["..itemName.."]|h|r"
                Cooltip.adjustTooltip(AtlasLootTooltip, "AtlasLootTooltip")
            end
        end
    end)

    atlas2:SetScript("OnShow", function()
        if GetMouseFocus().dressingroomID and GetMouseFocus().dressingroomID ~= 0 and
                strsub(GetMouseFocus().itemID or "", 1, 1) ~= "s" and strsub(GetMouseFocus().itemID or "", 1, 1) ~= "e" then
            local itemName, hyperLink, itemQuality = GetItemInfo(GetMouseFocus().dressingroomID)
            if itemName then
                local _, _, _, hex = GetItemQualityColor(tonumber(itemQuality))
                AtlasLootTooltip2.itemLink = hex.. "|H"..hyperLink.."|h["..itemName.."]|h|r"
                Cooltip.adjustTooltip(AtlasLootTooltip2, "AtlasLootTooltip2")
            end
        end
    end)

    atlas:SetScript("OnHide", function()
        AtlasLootTooltip.itemLink = nil
    end)
    atlas2:SetScript("OnHide", function()
        AtlasLootTooltip2.itemLink = nil
    end)
end)

ItemRefTooltip:SetScript("OnHide", function()
    ItemRefTooltip.itemLink = nil
end)