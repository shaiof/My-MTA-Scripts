function plate(player,cmd,text)
	local vehicle = getPedOccupiedVehicle(player)
	if getPedOccupiedVehicle(player) and getPedOccupiedVehicleSeat(player) == 0 then
		setVehiclePlateText(vehicle,text)
	else
		outputChatBox("You are not the driver!",player,0,255,255)
	end
end
addCommandHandler("plate",plate)

function position(player,cmd,otherPlayer)
	local x,y,z = getElementPosition(getPlayerFromName(otherPlayer))
	outputChatBox(x..","..y..","..z,player,0,255,255)
end
addCommandHandler("pos",position)