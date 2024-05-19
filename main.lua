---@class BBRG
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

local META_GEMS = addon.META_GEMS
local TINKER_GEMS = addon.TINKER_GEMS
local COGWHEEL_GEMS = addon.COGWHEEL_GEMS

---@enum Enum.GemType
local GemType = {
    Meta = "Meta",
    Cogwheel = "Cogwheel",
    Tinker = "Tinker",
    Prismatic = "Prismatic"
}

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
---@return Enum.GemType | nil
function getGemType(gem)
    if not gem or not gem.itemInfo or not gem.itemInfo.itemID then return nil end
    local gemID = gem.itemInfo.itemID

    if META_GEMS[gemID] then return GemType.Meta end
    if TINKER_GEMS[gemID] then return GemType.Tinker end
    if COGWHEEL_GEMS[gemID] then return GemType.Cogwheel end

    return GemType.Prismatic
end

---@param gem ItemData
---@return string | nil
function getCategory(gem)
    local gemType = getGemType(gem)
    if not gemType then return nil end

    if gemType == GemType.Meta then
        return WrapTextInColorCode((CategorySuffix .. "Meta gem"), Qualities[Enum.ItemQuality.Epic].color)
    end

    if gemType == GemType.Tinker then
        return WrapTextInColorCode((CategorySuffix .. "Tinker gem"), Qualities[Enum.ItemQuality.Uncommon].color)
    end

    if gemType == GemType.Cogwheel then
        return WrapTextInColorCode((CategorySuffix .. "Cogwheel gem"), Qualities[Enum.ItemQuality.Rare].color)
    end

    local quality = Qualities[gem.itemInfo.itemQuality]
    return WrapTextInColorCode((CategorySuffix .. "Prismatic ".. quality.name .. " gem"), quality.color)
end
