function garage(player, cmd, ID)
	if (not isGarageOpen(ID)) then
		setGarageOpen(ID, true)
	else
		setGarageOpen(ID, false)
	end
end
addCommandHandler("door", garage)

garage1 = createObject(14795,2239.7568359375,-1711.3251953125,96.974105834961,0,0,0)
garage2 = createObject(14795,2239.7568359375,-1711.3251953125,104.38960266113,0,180,0)