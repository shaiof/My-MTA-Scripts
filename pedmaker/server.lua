function makePed(player,cmd,id,frozen,animGroup,anim)
		local x,y,z = getElementPosition(player)
		local rx,ry,rz = getElementRotation(player)
		local dim = getElementDimension(player)
		local int = getElementInterior(player)
		if not id then
			outputChatBox("Syntax: /ped (id) [animationGroup] [animation] [frozen=true/false]",player,0,255,255)
		else
			if not animGroup then
				ped = createPed(tonumber(id),x,y,z)
				setElementDimension(ped,dim)
				setElementInterior(ped,int)
				setElementRotation(ped,rx,ry,rz)
				setElementFrozen(ped,true)
				for _,s in ipairs(getElementsByType("player")) do
					outputChatBox(getPlayerName(player).." has created a ped at X:"..x.." Y:"..y.." Z:"..z.." Skin: "..id,s,0,255,255)
					if frozen then
						if not animGroup then
							outputChatBox("Ped Info: Frozen: "..frozen,s,0,255,255)
						else
							if not anim then
								outputChatBox("Ped Info: Frozen: "..frozen.." Animation: "..animGroup.."/nil",s,0,255,255)
							else
								outputChatBox("Ped Info: Frozen: "..frozen.." Animation: "..animGroup.."/"..anim,s,0,255,255)
							end
						end
					end
				end
			else
				ped = createPed(tonumber(id),x,y,z)
				setElementDimension(ped,dim)
				setElementInterior(ped,int)
				setElementRotation(ped,rx,ry,rz)
				if frozen == "true" then
					setElementFrozen(ped,true)
				elseif frozen == "false" then
					setElementFrozen(ped,false)
				else
					setElementFrozen(ped,true)
				end
				setElementData(ped,"animGroup",tostring(animGroup))
				setElementData(ped,"anim",tostring(anim))
				if animGroup then
					if anim then
						timed = setTimer(pedContinue,3000,0)
					end
				end
				for _,s in ipairs(getElementsByType("player")) do
					outputChatBox(getPlayerName(player).." has created a ped at X:"..x.." Y:"..y.." Z:"..z,s,0,255,255)
					if frozen then
						if not animGroup then
							outputChatBox("Ped Info: Frozen: "..frozen,s,0,255,255)
						else
							if not anim then
								outputChatBox("Ped Info: Frozen: "..frozen.." Animation: "..animGroup.."/nil",s,0,255,255)
							else
								outputChatBox("Ped Info: Frozen: "..frozen.." Animation: "..animGroup.."/"..anim,s,0,255,255)
							end
						end
					end
				end
			end
		end
end
addCommandHandler("ped",makePed)

function pedContinue()
	setPedAnimation(ped,getElementData(ped,"animGroup"),getElementData(ped,"anim"))
	animGroup = ""
	anim = ""
end

function clearPed(player,cmd)
	for _,v in ipairs(getElementsByType("player")) do
		outputChatBox(getPlayerName(player).." has cleared all peds!",v,0,255,255)
	end
	killTimer(timed)
	for _,ped in ipairs(getElementsByType("ped")) do
		destroyElement(ped)
	end
end
addCommandHandler("clearpeds",clearPed)