--[[--------------------------------------------------------------------
    Ovale Spell Priority
    Copyright (C) 2013, 2014 Johnny C. Lam

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License in the LICENSE
    file accompanying this program.
--]]--------------------------------------------------------------------

local _, Ovale = ...

do
	local OvaleCondition = Ovale.OvaleCondition
	local OvaleState = Ovale.OvaleState

	local Compare = OvaleCondition.Compare
	local ParseCondition = OvaleCondition.ParseCondition
	local TestValue = OvaleCondition.TestValue
	local state = OvaleState.state

	--- Get the total count of the given aura across all targets.
	-- @name BuffCountOnAny
	-- @paramsig number or boolean
	-- @param id The spell ID of the aura or the name of a spell list.
	-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
	-- @param number Optional. The number to compare against.
	-- @param stacks Optional. The minimum number of stacks of the aura required.
	--     Defaults to stacks=1.
	--     Valid values: any number greater than zero.
	-- @param any Optional. Sets by whom the aura was applied. If the aura can be applied by anyone, then set any=1.
	--     Defaults to any=0.
	--     Valid values: 0, 1.
	-- @param excludeTarget Optional. Sets whether to ignore the current target when scanning targets.
	--     Defaults to excludeTarget=0.
	--     Valid values: 0, 1.
	-- @return The total aura count.
	-- @return A boolean value for the result of the comparison.
	-- @see DebuffCountOnAny

	local function BuffCountOnAny(condition)
		local auraId, comparator, limit = condition[1], condition[2], condition[3]
		local _, filter, mine = ParseCondition(condition)
		local excludeUnitId = (condition.excludeTarget == 1) and OvaleCondition.defaultTarget or nil

		local count, stacks, startChangeCount, endingChangeCount, startFirst, endingLast = state:AuraCount(auraId, filter, mine, condition.stacks, excludeUnitId)
		if count > 0 and startChangeCount < math.huge then
			local origin = startChangeCount
			local rate = -1 / (endingChangeCount - startChangeCount)
			local start, ending = startFirst, endingLast
			return TestValue(start, ending, count, origin, rate, comparator, limit)
		end
		return Compare(count, comparator, limit)
	end

	OvaleCondition:RegisterCondition("buffcountonany", false, BuffCountOnAny)
	OvaleCondition:RegisterCondition("debuffcountonany", false, BuffCountOnAny)

	-- Deprecated.
	OvaleCondition:RegisterCondition("buffcount", false, BuffCountOnAny)
	OvaleCondition:RegisterCondition("debuffcount", false, BuffCountOnAny)
end