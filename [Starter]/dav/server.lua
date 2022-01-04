function dav(player,cmd)
	outputChatBox("All Unoccupied Vehicles Will Be Destroyed In 20 Seconds!",root,0,255,255)
	setTimer(function()
		vehicles = getElementsByType("vehicle")
		for i,v in ipairs(vehicles) do
			if not (getElementData(v,"saved") ==  true) then
				if isVehicleEmpty(v) then
					destroyElement(v)
				end
			end
		end
		outputChatBox("All Unoccupied Vehicles Were Destroyed!",root,0,255,255)
	end,20000,1)
end
addCommandHandler("dav",dav)
setTimer(dav,1800000,0)

function isVehicleEmpty( vehicle )
	if not isElement( vehicle ) or getElementType( vehicle ) ~= "vehicle" then
		return true
	end
	local passengers = getVehicleMaxPassengers( vehicle )
	if type( passengers ) == 'number' then
		for seat = 0, passengers do
			if getVehicleOccupant( vehicle, seat ) then
				return false
			end
		end
	end
	return true
end

function saveVehicle(player,cmd)
	if (isPedInVehicle(player) == true) then
		local vehicle = getPedOccupiedVehicle(player)
		if (getElementData(vehicle,"saved") == true) then
			setElementData(vehicle,"saved",false)
			outputChatBox("Vehicle Unsaved! This vehicle will now dissapear on dav activation!",player,0,255,255)
		else
			setElementData(vehicle,"saved",true)
			outputChatBox("Vehicle Saved! This vehicle will not despawn unless blown!",player,0,255,255)
		end
	end
end
addCommandHandler("save",saveVehicle)