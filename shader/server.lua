function changeColor(player,cmd,r,g,b,a)
	local veh = getPedOccupiedVehicle(player)
	if veh then
		if r then
			if r == "off" then
				setElementData(veh,'changeColor',false)
				outputChatBox('Attachment Color Successfully Disabled!',player,0,255,255)
			else
				if g and b then
					if a then
						setElementData(veh,'changeColor',true)
						setElementData(veh,'r',r)
						setElementData(veh,'g',g)
						setElementData(veh,'b',b)
						outputChatBox('Attachment Color Successfully Changed!',player,tonumber(r),tonumber(g),tonumber(b))
					else
						setElementData(veh,'changeColor',true)
						setElementData(veh,'r',r)
						setElementData(veh,'g',g)
						setElementData(veh,'b',b)
						outputChatBox('Attachment Color Successfully Changed!',player,tonumber(r),tonumber(g),tonumber(b))
					end
				else
					outputChatBox('Incorrect Syntax! /acolor r g b (a) | or /acolor off',player,255,0,0)
				end
			end
		else
			outputChatBox('Incorrect Syntax! /acolor r g b (a) | or /acolor off',player,255,0,0)
		end
	else
		outputChatBox('You need to have a vehicle!',player,255,0,0)
	end
end
addCommandHandler('acolor',changeColor)