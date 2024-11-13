--
-- SellVehicleEventExtended
--
-- Extend the SellVehicleEvent to add the base cost return and repair costs
--
-- Copyright (c) Peppie84, 2023
-- https://github.com/Peppie84/FS22_ExtendedLeasing
--
SellVehicleEventExtended = {}

---Overwrites the base SellVehicleEvent:run and adds a repair and basecost return
---@param overwrittenFunc function
---@param connection table (Connection)
function SellVehicleEventExtended:run(overwrittenFunc, connection)
    overwrittenFunc(self, connection)

    if not connection:getIsServer() then
        if g_currentMission:getHasPlayerPermission(Farm.PERMISSION.SELL_VEHICLE, connection, self.vehicle:getOwnerFarmId()) then
            local farmId = self.vehicle:getOwnerFarmId()
            local farm = g_farmManager:getFarmById(farmId)

            if self.vehicle.propertyState ~= Vehicle.PROPERTY_STATE_OWNED then
                if farmId ~= nil and farmId ~= FarmManager.SPECTATOR_FARM_ID and farm ~= nil then
                    local vehiclePrice = self.vehicle:getPrice()
                    local depositReturn = MathUtil.round(vehiclePrice * EconomyManager.DEFAULT_LEASING_DEPOSIT_FACTOR, 0)
                    local maxWashingCosts = depositReturn * 0.3
                    local washingCosts = 0

                    if self.vehicle.getDirtAmount then
                        washingCosts = maxWashingCosts * math.min(self.vehicle:getDirtAmount(), 1)
                    end

                    if MoneyType.BASECOSTS ~= nil then
                        farm:changeBalance(depositReturn, MoneyType.BASECOSTS)
                        g_currentMission:addMoneyChange(depositReturn, farmId, MoneyType.BASECOSTS, true)
                    end

                    self.vehicle:repairVehicle(nil)

                    if washingCosts > 0 and MoneyType.WASHINGCOSTS ~= nil then
                        farm:changeBalance(-washingCosts, MoneyType.WASHINGCOSTS)
                        g_currentMission:addMoneyChange(-washingCosts, farmId, MoneyType.WASHINGCOSTS, true)
                    end
                end
            end
        end
    end
end
