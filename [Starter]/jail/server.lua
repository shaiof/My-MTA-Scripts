jails = {
	{x = 264.5791015625,y = 77.41796875,z = 1001.2,int = 6,dim = 1},
	{x = 198.50390625,y = 161.935546875,z = 1003.2,int = 3,dim = 1},
	{x = 197.939453125,y = 174.7607421875,z = 1003.2,int = 3,dim = 1},
	{x = 193.64453125,y = 174.962890625,z = 1003.2,int = 3,dim = 1},
	{x = 215.2412109375,y = 110.5703125,z = 999.2,int = 10,dim = 1},
	{x = 219.6318359375,y = 109.9228515625,z = 999.2,int = 10,dim = 1},
	{x = 223.5625,y = 110.626953125,z = 999.2,int = 10,dim = 1},
	{x = 227.6103515625,y = 110.6259765625,z = 999.2,int = 10,dim = 1}
}
allowedCMDS = {"say"}

function blockCommand(command)
	local account = getPlayerAccount(source)
	if getAccountData(account,'jailed') == true then
		for u,a in pairs(allowedCMDS) do
			if not a == command then
				cancelEvent()
			end
		end
	end
end
addEventHandler('onPlayerCommand',root,blockCommand)

function unjailPlayer(p)
	local player = getPlayerFromName(p)
	local account = getPlayerAccount(player)
	if getAccountData(account,'jailed') == true then
		setAccountData(account,'jailed',false)
		setAccountData(account,'jail',nil)
		local int = getAccountData(account,'oldint')
		local dim = getAccountData(account,'olddim')
		local x = getAccountData(account,'oldx')
		local y = getAccountData(account,'oldy')
		local z = getAccountData(account,'oldz')
		setElementInterior(player,int)
		setElementPosition(player,x,y,z)
		setElementDimension(player,dim)
		outputChatBox(getPlayerName(player)..' has been unjailed!',root,0,255,255)
	end
end

function jailPlayer(player,num)
	local player = getPlayerFromName(player)
	local account = getPlayerAccount(player)
	if getAccountData(account,'jailed') == false or getAccountData(account,'jailed') == nil then
		local ox,oy,oz = getElementPosition(player)
		local pint = getElementInterior(player)
		local pdim = getElementDimension(player)
		for k,j in pairs(jails) do
			if k == tonumber(num) then
				local account = getPlayerAccount(player)
				if account then
					setAccountData(account,'jailed',true)
					setAccountData(account,'jail',num)
					setAccountData(account,'oldint',pint)
					setAccountData(account,'olddim',pdim)
					setAccountData(account,'oldx',ox)
					setAccountData(account,'oldy',oy)
					setAccountData(account,'oldz',oz)
					setAccountData(account,'jx',j.x)
					setAccountData(account,'jy',j.y)
					setAccountData(account,'jz',j.z)
					setAccountData(account,'jint',j.int)
					setAccountData(account,'jdim',j.dim)
				end
				if getPedOccupiedVehicle(player) then
					removePedFromVehicle(player)
				end
				setElementInterior(player,j.int)
				setElementDimension(player,j.dim)
				setElementPosition(player,j.x,j.y,j.z)
				outputChatBox(getPlayerName(player)..' has been jailed!',root,0,255,255)
			end
		end
	end
end

function isPlayerStaff(player)
	if player then
		local acc = getAccountName(getPlayerAccount(player))
		if acc then
			if isObjectInACLGroup('user.'..acc,aclGetGroup('Admin')) then
				return true
			else
				return false
			end
		end
	end
end

addCommandHandler('jail',function(player,cmd,other,jail,leng)
	if isPlayerStaff(player) then
		if other and jail then
			if leng then
				jailPlayer(other,jail)
				setTimer(unjailPlayer,(tonumber(leng)*1000),1,other)
			else
				jailPlayer(other,jail)
			end
		end
	end
end)

addCommandHandler('unjail',function(player,cmd,other)
	if isPlayerStaff(player) then
		if other then
			unjailPlayer(other)
		end
	end
end)