--
-- Main
--
-- Initialize SellVehicleEventExtended
--
-- Copyright (c) Peppie84, 2023
-- https://github.com/Peppie84/FS22_ExtendedLeasing
--
---@type string directory of the mod.
local modDirectory = g_currentModDirectory or ''
---@type string name of the mod.
local modName = g_currentModName or 'unknown'

source(modDirectory .. 'src/events/SellVehicleEventExtended.lua')

---Mission00 is loading
---@param mission table (Mission00)
local function preLoad(mission)
    SellVehicleEvent.run = Utils.overwrittenFunction(SellVehicleEvent.run, SellVehicleEventExtended.run)
end

--- Initialize the mod
local function init()
    Mission00.load = Utils.prependedFunction(Mission00.load, preLoad)

    if MoneyType ~= nil then
        MoneyType.BASECOSTS = MoneyType.register('other', 'base_costs', modName)
        MoneyType.WASHINGCOSTS = MoneyType.register('other', 'washing_costs', modName)
        MoneyType.LAST_ID = MoneyType.LAST_ID + 2
    end
end

init()
