local door = createObject(5043,-1638.1708984375,-2250.9597167969,31.236736297607,0,0,2)
open = false
disable = false

function toggleDoor(player,cmd)
	if open == false then
		if disable == false then
			moveObject(door,2000,-1638.1708984375,-2250.9597167969,32.636734008789,0,90,0)
			disable = true
			open = true
			setElementCollisionsEnabled(door,false)
			setTimer(function() disable = false setElementPosition(door,-1638.1708984375,-2250.9597167969,32.636734008789) setElementRotation(door,0,90,2) end,2000,1)
		end
	elseif open == true then
		if disable == false then
			moveObject(door,2000,-1638.1708984375,-2250.9597167969,31.236736297607,0,-90,0)
			disable = true
			open = false
			setElementCollisionsEnabled(door,true)
			setTimer(function() disable = false setElementPosition(door,-1638.1708984375,-2250.9597167969,31.236736297607) setElementRotation(door,0,0,2) end,2000,1)
		end
	end
end
addCommandHandler('shaygarage',toggleDoor)