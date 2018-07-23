local root = getRootElement()
------------------------------------------------ Configuration ------------------------------------------------
-- A stands for Arm, which is the bars holding the lift.                                                     -- 
-- B stands for Base, this is the lift that pushes the vehicle up and lets it down.                          --
-- Just for reference if you get confused on this config..                                                   --
-- Ax,Ay,Az,Arx,Ary,Arz = Arm location and rotation.                                                         --
-- Bx,By,Bz,Brx,Bry,Brz = Base location and rotation.                                                        --
-- I just used offedit by Offroader23 and got the element position that way, but do what you want :D         --
---------------------------------------------------------------------------------------------------------------
lifts = {
	{Ax = -2052.5275878906,Ay = 170.32743835449,Az = 27.834247589111,Bx = -2052.5104980469,By = 170.35441589355,Bz = 24.202234268188,Brx = 0,Bry = 0,Brz = 90,Arx = 0,Ary = 0,Arz = 90},
	{Ax = -2052.6342773438,Ay = 178.69462585449,Az = 27.853750228882,Bx = -2052.6838378906,By = 178.74092102051,Bz = 24.183757781982,Brx = 0,Bry = 0,Brz = 90,Arx = 0,Ary = 0,Arz = 90}
}

distance = 6 -- This is the distance you want it to read from the player to the lift.
-- So if the player is 6 (whatever) away from any lift, it will trigger the lift on command..
----------------------------------------------------------------------------------------------------------------
data = {}

for i,l in pairs(lifts) do
	table.insert(data,{Arm = createObject(2597,l.Ax,l.Ay,l.Az,l.Arx,l.Ary,l.Arz),Base = createObject(2231,l.Bx,l.By,l.Bz,l.Brx,l.Bry,l.Brz)})
end

for i,s in pairs(data) do
	local x,y,z = getElementPosition(s.Base)
	setElementData(s.Base,"state","down")
	setElementData(s.Base,"reset",z)
	setElementData(s.Base,"reset2",z+2.371852874756)
end

addCommandHandler("lift",function(player,cmd,percent)
	for i,d in pairs(data) do
		local x,y,z = getElementPosition(player)
		local vx,vy,vz = getElementPosition(d.Base)
		local sx = getElementData(d.Base,"reset")
		local sy = getElementData(d.Base,"reset2")
		local de = getDistanceBetweenPoints3D(x,y,z,vx,vy,vz)
		if de < distance then
			if (getElementData(d.Base,"state") == "up") then
				if percent then
					if tonumber(percent) > -1 and tonumber(percent) < 101 then
						local state = vz-((tonumber(percent)/100)*2.371852874756)
						if state < sy-2.371852874756 then
							outputChatBox("Please use a lower percentage!",player,255,0,0)
							return
						else
							moveObject(d.Base,((tonumber(percent)/100)*5000),vx,vy,state)
							setElementData(d.Base,"state","down")
						end
					else
						outputChatBox("You need a percentage!",player,255,0,0)
					end
				else
					moveObject(d.Base,5000,vx,vy,sx)
					setElementData(d.Base,"state","down")
				end
			elseif (getElementData(d.Base,"state") == "down") then
				if percent then
					if tonumber(percent) > -1 and tonumber(percent) < 101 then
						local state = vz+((tonumber(percent)/100)*2.371852874756)
						if state > sx+2.371852874756 then
							outputChatBox("Please use a lower percentage!",player,255,0,0)
							return
						else
							moveObject(d.Base,((tonumber(percent)/100)*5000),vx,vy,state)
							setElementData(d.Base,"state","up")
						end
					else
						outputChatBox("You need a percentage!",player,255,0,0)
					end
				else
					moveObject(d.Base,5000,vx,vy,sy)
					setElementData(d.Base,"state","up")
				end
			end
		end
	end
end)