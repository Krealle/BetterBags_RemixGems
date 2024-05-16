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

-- MARK: Item Category Sorting
-------------------------------------------------------
---@param data ItemData
categories:RegisterCategoryFunction("RemixItemsCategoryFilter", function(data)
    if (data.itemInfo.classID ~= Enum.ItemClass.Gem) then
        return nil
    end

    local lines = C_TooltipInfo_GetItemByID(data.itemInfo.itemID).lines
    if not lines then return nil end

    local gemType = lines[2] and lines[2].leftText
    if not gemType or type(gemType) ~= "string" then return nil end

    local subText = lines[3] and lines[3].leftText

    local gemRank = getPlusSigns(subText)
    if(gemRank) then
        return L:G(gemType .. " " .. gemRank)
    end

    return L:G(gemType)
end)

---@param subText string
---@return string
function getPlusSigns(subText)
    if not subText or type(subText) ~= "string" then return false end

    if subText:sub(1, 1) == "+" then
        local plus_signs = subText:match("^%++")
        return plus_signs or ""
    end
        
    return false
end
