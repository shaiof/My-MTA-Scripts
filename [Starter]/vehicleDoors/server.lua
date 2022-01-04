function carDoor(player,cmd,door,ratio)
	local vehicle = getPedOccupiedVehicle(player)
	setVehicleDoorOpenRatio(vehicle,door,ratio,1000)
end
addCommandHandler("cardoor",carDoor)

function carJunk(player,cmd,id)
local vehicle = getPedOccupiedVehicle(player)
	if getPedOccupiedVehicle(player) and getPedOccupiedVehicleSeat(player) == 0 then
		if id == "all" then
			setVehicleDoorState(vehicle,0,4)
			setVehicleDoorState(vehicle,1,4)
			setVehicleDoorState(vehicle,2,4)
			setVehicleDoorState(vehicle,3,4)
			setVehicleDoorState(vehicle,4,4)
			setVehicleDoorState(vehicle,5,4)
			setVehiclePanelState(vehicle,5,3)
			setVehiclePanelState(vehicle,6,3)
		else
			setVehicleDoorState(vehicle,id,4)
		end
	else
		outputChatBox("You are not the driver!",player,0,255,255)
	end
end
addCommandHandler("junk",carJunk)

function carB(player,cmd)
local vehicle = getPedOccupiedVehicle(player)
	if getPedOccupiedVehicle(player) and getPedOccupiedVehicleSeat(player) == 0 then
		setVehiclePanelState(vehicle,5,3)
		setVehiclePanelState(vehicle,6,3)
	else
		outputChatBox("You are not the driver!",player,0,255,255)
	end
end
addCommandHandler("junkb", carB)


function alpha(player,cmd,alpha)
	if getPedOccupiedVehicle(player) and getPedOccupiedVehicleSeat(player) == 0 then
		local vehicle = getPedOccupiedVehicle(player)
		setElementAlpha(vehicle,alpha)
	else
		outputChatBox("You are not the driver!",player,0,255,255)
	end
end
addCommandHandler("cap",alpha)
addCommandHandler("calpha",alpha)