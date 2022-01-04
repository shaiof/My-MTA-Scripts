blockedDims = {110}

function rotate(player,cmd,degrees)
	if isPedInVehicle(player) then
        localVehicle = getPedOccupiedVehicle(player)
        if getVehicleController(localVehicle) == player then
            local rotX,rotY,rotZ = getElementRotation(localVehicle)
            setElementRotation(localVehicle,rotX,rotY,rotZ+degrees)
         end
    end
end
addCommandHandler("rotate",rotate)

function up(player,cmd,degrees)
	if isPedInVehicle(player) then
        localVehicle = getPedOccupiedVehicle(player)
        if getVehicleController(localVehicle) == player then
            local rotX,rotY,rotZ = getElementPosition(localVehicle)
            setElementPosition(localVehicle,rotX,rotY,rotZ+degrees)
        end
	else
		local x,y,z = getElementPosition(player)
		setElementPosition(player,x,y,z+degrees)
    end
end
addCommandHandler("z",up)

function dimSet(player,cmd,dim)
	if dim then
		for i,d in pairs(blockedDims) do
			if tonumber(dim) == d then
				outputChatBox('This dimension is not available!',player,0,255,255)
				return
			else
				outputChatBox('You switched your dimension to: '..dim,player,0,255,255)
				if isPedInVehicle(player) then
					local theVehicle = getPedOccupiedVehicle(player)
					setElementDimension(player,tonumber(dim))
					setElementDimension(theVehicle,tonumber(dim))
				else
					setElementDimension(player,tonumber(dim))
				end
			end
		end
	end
end
addCommandHandler('dim',dimSet)