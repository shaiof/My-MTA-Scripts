function freeze(player, cmd)
	if (isPedInVehicle(player) == true) then
		local vehicle = getPedOccupiedVehicle(player)
		if (getVehicleOccupant(vehicle, 0) == player) then
			if (isElementFrozen(vehicle) == false) then
				setElementFrozen(vehicle, true)
				setElementCollisionsEnabled(vehicle, false)
				toggleControl(player, "vehicle_fire", false)
				toggleControl(player, "vehicle_secondary_fire", false)
				local name = getVehicleName(vehicle)
				outputChatBox(name.." frozen!", player, 0, 255, 255)
			else
				setElementFrozen(vehicle, false)
				setElementCollisionsEnabled(vehicle, true)
				toggleControl(player, "vehicle_fire", true)
				toggleControl(player, "vehicle_secondary_fire", true)
				local name = getVehicleName(vehicle)
				outputChatBox(name.." unfrozen!", player, 0, 255, 255)
			end
		else
			outputChatBox("You need to be the driver!", player,0,255,255)
		end
	else
		if (isElementFrozen(player) == false) then
			setElementFrozen(player, true)
			setElementCollisionsEnabled(player, false)
			toggleControl(player, "aim_weapon", false)
			toggleControl(player, "fire", false)
			outputChatBox("Frozen!", player, 0, 255, 255)
		else
			setElementFrozen(player, false)
			setElementCollisionsEnabled(player, true)
			toggleControl(player, "aim_weapon", true)
			toggleControl(player, "fire", true)
			outputChatBox("Unfrozen!", player, 0, 255, 255)
		end
	end
end
addCommandHandler("fz", freeze)

function parkCar(player,cmd)
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle then
		if getVehicleOccupant(vehicle) == player then
			if isElementFrozen(vehicle) then
				setElementFrozen(vehicle,false)
				outputChatBox("Your "..getVehicleName(vehicle).." is now unparked.",player,0,255,255)
			else
				setElementFrozen(vehicle,true)
				outputChatBox("Your "..getVehicleName(vehicle).." is now parked.",player,0,255,255)
			end
		end
	end
end
addCommandHandler("parkcar",parkCar)