---@class BBGS
local addon = select(2, ...)
---@class BetterBags: AceAddon
local BetterBags = LibStub('AceAddon-3.0'):GetAddon("BetterBags")
---@class Categories: AceModule
local categories = BetterBags:GetModule('Categories')
---@class Localization: AceModule
local L = BetterBags:GetModule('Localization')

-- MARK: WoW API
-------------------------------------------------------
local C_TooltipInfo_GetItemByID = C_TooltipInfo and C_TooltipInfo.GetItemByID

-- MARK: Addon Constants
-------------------------------------------------------
local Qualities = {
    [Enum.ItemQuality.Uncommon] = { ["name"] = "Chipped", ["color"] = "ff1eff00" },
    [Enum.ItemQuality.Rare] = { ["name"] = "Flawed", ["color"] = "ff0070dd" },
    [Enum.ItemQuality.Epic] = { ["name"] = "Epic", ["color"] = "ffa335ee" },
    [Enum.ItemQuality.Legendary] = { ["name"] = "Perfect", ["color"] = "ffff8000" },
}

local CategorySuffix = "Remix - "

-- MARK: Item Category Sorting
-------------------------------------------------------
---@param data ItemData
categories:RegisterCategoryFunction("RemixItemsCategoryFilter", function(data)
    if (data.itemInfo.classID ~= Enum.ItemClass.Gem) then
        return nil
    end

    local category = getCategory(data)
    if not category then return nil end
    
    return L:G(category)
end)

---@param gem ItemData
---@return string | nil
function getGemType(gem)
    if not gem or not gem.itemInfo or not gem.itemInfo.itemID then return nil end

    local tooltipLines = C_TooltipInfo_GetItemByID(gem.itemInfo.itemID).lines
    if not tooltipLines then return nil end

    local gemType = tooltipLines[2] and tooltipLines[2].leftText
    if not gemType or type(gemType) ~= "string" then return nil end

    return gemType
end

---@param gem ItemData
---@return string | nil
function getCategory(gem)
    local gemType = getGemType(gem)
    if not gemType then return nil end

    if string.match(gemType, "Prismatic") then
        local quality = Qualities[gem.itemInfo.itemQuality]
        return WrapTextInColorCode((CategorySuffix .. quality.name .. " gem"), quality.color)
    end

    if string.match(gemType, "Tinker") then
        return WrapTextInColorCode((CategorySuffix .. "Tinker gem"), Qualities[Enum.ItemQuality.Uncommon].color)
    end

    if string.match(gemType, "Cogwheel") then
        return WrapTextInColorCode((CategorySuffix .. "Cogwheel gem"), Qualities[Enum.ItemQuality.Rare].color)
    end

    return WrapTextInColorCode((CategorySuffix .. "Meta gem"), Qualities[Enum.ItemQuality.Epic].color)
end
