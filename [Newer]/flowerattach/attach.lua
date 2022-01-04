local invalidmodels
local vehicleobj = {}
local attachment = {}
local maxobjects = 60
local maxsize = {25,25,25}
local maxscale = 5
local bannedids = {}

function attach(player,command,objectid,x,y,z,rx,ry,rz)
	local account = getPlayerAccount(player)
	if (isGuestAccount(account) == true) then
		outputChatBox("You need to be logged in to use this!",player,0,255,255)
	return end
	if not vehicleobj[player] then
		if objectid then
			local vehicle = getPedOccupiedVehicle(player)
			if vehicle and (isDriver(player) or hasPerms(player)) then
				if not attachment[vehicle] then attachment[vehicle] = {} end
				if bannedids[objectid] then return outputChatBox('This ID is not allowed.',player,0,255,255) end
				local var = objectid
				local vx,vy,vz = getElementPosition(vehicle)
				if type(tonumber(var)) == 'number' then
					local var = tonumber(var)
					if var > 611 and var <= 18199 or (var <= 372 and var >= 321) then
						vehicleobj[player] = createObject(var,vx,vy,vz)
					elseif var <= 611 and var >= 400 then
						if hasPerms(player) then
							vehicleobj[player] = createVehicle(var,vx,vy,vz)
						end
					end
				else
					if hasPerms(player) then
						local veh = getVehicleModelFromName(var)
						if veh then
							vehicleobj[player] = createVehicle(veh,vx,vy,vz)
						end
					end
				end
				if vehicleobj[player] then
					setElementCollisionsEnabled(vehicleobj[player],false)
					attachElements(vehicleobj[player],vehicle,x,y,z,rx,ry,rz)
					setElementParent(vehicleobj[player],vehicle)
					triggerClientEvent('updateAttachGridlines',root,vehicleobj[player],player)
					if getElementType(vehicleobj[player]) == 'object' then
						triggerClientEvent(player,'checkElementSize',root,vehicleobj[player],maxsize[1],maxsize[2],maxsize[3])
					end
				else
					outputChatBox(var..' is not a valid model ID.',player)
				end
			else
				outputChatBox('You must be the driver of a vehicle to use this command.',player,0,255,255)
			end
		else
			triggerClientEvent(player,'toggleAttachPanel',player)
		end
	else
		triggerClientEvent(player,'toggleAttachPanel',player)
	end
end
addCommandHandler('attach',attach)
addEvent('attachObject',true)
addEventHandler('attachObject',root,attach)

function collision(player,command,col)
		if vehicleobj[player] then
			local colon = tonumber(col)
			if colon == 1 then
				setElementCollisionsEnabled(vehicleobj[player],true)
				outputChatBox('Collision enabled.',player,0,255,255)
			elseif colon == 0 then
				setElementCollisionsEnabled(vehicleobj[player],false)
				outputChatBox('Collision disabled.',player,0,255,255)
			end
		end
end
addCommandHandler('acol',collision)
addEvent('col',true)
addEventHandler('col',root,collision)

function vehiclecolor(player,command,...)
		if vehicleobj[player] then
			local model = getElementModel(vehicleobj[player])
			if tonumber(model) <= 611 and tonumber(model) >= 400 then
				local colors = {getVehicleColor(vehicleobj[player])}
				local args = {...}
				for i=1,12 do
					if not args[i] then args[i] = 255 end
					colors[i] = args[i] and tonumber(args[i]) or colors[i]
				end
				setVehicleColor(vehicleobj[player],unpack(colors))
			else
				outputChatBox('You must be editing a vehicle to change its colour.',player,0,255,255)
			end
		end
end
addCommandHandler('vehcol',vehiclecolor)

function moveAttachment(player,command,value)
	if vehicleobj[player] and type(tonumber(value)) == 'number' then
		local x,y,z,rx,ry,rz = getElementAttachedOffsets(vehicleobj[player])
		if command == 'ox' then
			x = x+value
		elseif command == 'oy' then
			y = y+value
		elseif command == 'oz' then
			z = z+value
		elseif command == 'rx' then
			rx = rx+ value
		elseif command == 'ry' then
			ry = ry+value
		elseif command == 'rz' then
			rz = rz+value
		end
		setElementAttachedOffsets(vehicleobj[player],x,y,z,rx,ry,rz)
	end
end
addEvent('moveObject',true)
addEventHandler('moveObject',root,moveAttachment)

local movementcommands = {'ox','oy','oz', 'rx','ry','rz'}
for _,v in pairs(movementcommands) do
	addCommandHandler(v,moveAttachment)
end

function scale(player,command,scalex,scaley,scalez)
	if tonumber(scalex) then
		if not scalez then 
			scaley = scalex
			scalez = scalex
		end
		if (tonumber(scalex) > maxscale or tonumber(scaley) > maxscale or tonumber(scalez) > maxscale) and not hasPerms(player) then
			return outputChatBox('Please use scales below '..maxscale..'.',player,0,255,255)
		end
		if vehicleobj[player] and (isDriver(player) or hasPerms(player)) then
			if getElementType(vehicleobj[player]) == 'object' then
				local model = getElementModel(vehicleobj[player])
				if model then
					setObjectScale(vehicleobj[player],scalex,scaley,scalez)
				end
			else
				outputChatBox('Only objects can be scaled.',player,0,255,255)
			end
		else
			outputChatBox('You must select an object',player,0,255,255)
		end
	end
end
addCommandHandler('ascale',scale)
addEvent('scale',true)
addEventHandler('scale',root,scale)

function destroyObject(player,command,id)
	local element
	local num = false
	local vehicle
	if id then
		if type(tonumber(id)) == 'number' then
			vehicle = getPedOccupiedVehicle(player)
			if vehicle and (isDriver(player) or hasPerms(player)) then
				if attachment[vehicle] then
					id = tonumber(id)
					num = id
					if attachment[vehicle][id] then
						element = attachment[vehicle][id]
					else
						outputChatBox('Invalid object ID: '..id,player,0,255,255)
					end
				end
			else
				outputChatBox('You must be the driver of a vehicle to use this command.',player,0,255,255)
			end
		else
			outputChatBox('Invalid object ID: '..id,player,0,255,255)
		end
	else
		if vehicleobj[player] then
			vehicle = getElementParent(vehicleobj[player])
			if attachment[vehicle] then
				if vehicleobj[player] then
					element = vehicleobj[player]
					for i=0,#attachment[vehicle] do
						if attachment[vehicle][i] == vehicleobj[player] then
							num = i
							break
						end
					end
				end
			end
		else
			outputChatBox('You must be either editing an object or supply a valid object ID',player,0,255,255)
		end
	end
	
	if element then
		if num then
			attachment[vehicle][num] = false
			outputChatBox('Object ID deleted: '..num,player,0,255,255)
		else
			outputChatBox('Current object deleted.',player,0,255,255)
		end
		destroyElement(element)
		if element == vehicleobj[player] then
			triggerClientEvent('updateAttachGridlines',root)
			vehicleobj[player] = false
		end
	end
end
addCommandHandler('adestroy',destroyObject)
addEvent('destroy',true)
addEventHandler('destroy',root,destroyObject)

function saveObject(player,command)
	if vehicleobj[player] then
		local model = getElementModel(vehicleobj[player])
		local vehicle = getElementParent(vehicleobj[player])
		if vehicle and model then
			local first = true
			local id
			for i=0,maxobjects+1 do
				if attachment[vehicle][i] == vehicleobj[player] then
					id = i
					break
				elseif not attachment[vehicle][i] then
					if first then
						first = false
						id = i
					else
						break
					end
				end
			end
			if id > maxobjects then return outputChatBox('You have reached the limit of attachments.',player,0,255,255) end
			attachment[vehicle][id] = vehicleobj[player]
			outputChatBox('Attachment saved as ID: '..id,player,0,255,255)
			triggerClientEvent('updateAttachGridlines',root,vehicleobj[player],player)
			vehicleobj[player] = false
		end
	end
end
addCommandHandler('asave',saveObject)
addEvent('save',true)
addEventHandler('save',root,saveObject)

function selects(player,command,id)
		if id then
			local vehicle = getPedOccupiedVehicle(player)
			if vehicle and (isDriver(player) or hasPerms(player)) then
				local num = tonumber(id)
				if vehicleobj[player] then
					saveObject(player)
				end
				if attachment[vehicle][num] then 
					vehicleobj[player] = attachment[vehicle][num] 
					triggerClientEvent('updateAttachGridlines',root,attachment[vehicle][num],player)
					outputChatBox('Object ID selected: '..id,player,0,255,255)
				else
					outputChatBox('ID '..num..' does not exist.',player,0,255,255)
				end
			else
				outputChatBox('You must be the driver of a vehicle to use this command.',player,0,255,255)
			end
		end
	end
addCommandHandler('asel',selects)
addEvent('asel',true)
addEventHandler('asel',root,selects)

function info(player,command,id)
		local element
		if id then
			local vehicle = getPedOccupiedVehicle(player)
			if vehicle and (isDriver(player) or hasPerms(player)) then
				local id = tonumber(id)
				if attachment[vehicle][id] then
					element = attachment[vehicle][id]
				else
					outputChatBox('Invalid object ID: '..id,player,0,255,255)
				end
			else
				outputChatBox('You must be the driver of a vehicle to use this command.',player,0,255,255)
			end
		else
			if vehicleobj[player] then
				element = vehicleobj[player]
			else
				outputChatBox('You must be editing an object or supply a valid ID.',player,0,255,255)
			end
		end
		if element then
			local model = getElementModel(element)
			local x,y,z,rx,ry,rz = getElementAttachedOffsets(element)
			local scalex,scaley,scalez = getObjectScale(element)
			if not model then return end
			outputChatBox('Object Info - Object Model ID: '..model,player,0,255,255)
			outputChatBox('Pos X: '..x..' Pos Y: '..y..' Pos Z: '..z,player,0,255,255)
			outputChatBox('Rot X: '..rx..' Rot Y: '..ry..' Rot Z: '..rz,player,0,255,255)
			outputChatBox('Scale X: '..scalex..' Scale Y: '..scaley..' Scale Z: '..scalez,player,0,255,255)
		end
end
addCommandHandler('ainfo',info)

function saveattach(player,command,attachname)
		local account = getPlayerAccount(player)
		if (isGuestAccount(account) == true) then
			outputChatBox("You need to be logged in to use this!",player,0,255,255)
		return end
		if attachname then
			if not string.find(attachname,'%W') then
				local vehicle = getPedOccupiedVehicle(player)
				if vehicle and (isDriver(player) or hasPerms(player)) then
					if attachment[vehicle] then 
						if #attachment[vehicle] >= 1 then
							local tempdata = {}
							tempdata['serial'] = getPlayerSerial(player)
							for i=0,#attachment[vehicle] do
								if attachment[vehicle][i] then
									tempdata[i] = {}
									tempdata[i]['model'] = getElementModel(attachment[vehicle][i])
									tempdata[i]['col'] = getElementCollisionsEnabled(attachment[vehicle][i])
									local x,y,z,rx,ry,rz = getElementAttachedOffsets(attachment[vehicle][i])
									tempdata[i]['pos'] = {x,y,z,rx,ry,rz}
									if getElementType(attachment[vehicle][i]) == 'vehicle' then
										tempdata[i]['type'] = 'vehicle'
										local colours = {getVehicleColor(attachment[vehicle][i],true)}
										for k=1,12 do
											if not colours[k] then colours[k] = 255 end
										end
										tempdata[i]['colour'] = colours
									else
										local scalex,scaley,scalez = getObjectScale(attachment[vehicle][i])
										tempdata[i]['scale'] = {scalex,scaley,scalez}
										tempdata[i]['type'] = 'object'
									end
								end
							end
							local file = fileCreate('attachments/'..attachname..'.json')
							fileWrite(file,toJSON(tempdata))
							fileClose(file)
							tempdata = {}
							outputChatBox('Saved attachments as '..attachname,player,0,255,255)
						else
							return outputChatBox('This vehicle has no attachments to save.',player,0,255,255)
						end
					else
						outputChatBox('This vehicle has no savable attachments.',player,0,255,255)
					end
				else
					outputChatBox('You must be the driver of a vehicle to use this command.',player,0,255,255)
				end
			else
				outputChatBox('Invalid attachment name.',player,0,255,255)
			end
		end
end
addCommandHandler('saveattach',saveattach)
addEvent('saveAttach',true)
addEventHandler('saveAttach',root,saveattach)

function loadAttachment(attachname,vehicle,player)
	local account = getPlayerAccount(player)
		if (isGuestAccount(account) == true) then
			outputChatBox("You need to be logged in to use this!",player,0,255,255)
		return end
	local vehicle = vehicle
	if not vehicle then 
		vehicle = getPedOccupiedVehicle(player)
	end
	if vehicle then
		if fileExists('attachments/'..attachname..'.json') then
			local name
			if isElement(player) then
				clearVehicleObjects(player)
				outputChatBox('Attachment loaded: '..attachname,player,0,255,255)
				name = getPlayerName(player)
			else
				name = 'the server'
			end
			
			local file = fileOpen('attachments/'..attachname..'.json')
			local size = fileGetSize(file)
			local buffer = fileRead(file, size)
			local tempdata = fromJSON(buffer)
			fileClose(file)
			attachment[vehicle] = {}
			local vx, vy, vz = getElementPosition(vehicle)
			for k,v in pairs (tempdata) do
				if k ~= 'info' then
					local id = tonumber(k)
					local ids = tostring(k)
					if tempdata[ids]['type'] == 'vehicle' then
						attachment[vehicle][id] = createVehicle(tempdata[ids]['model'],vx,vy,vz)
						setVehicleColor(attachment[vehicle][id],unpack(tempdata[ids]['colour']))
					else
						attachment[vehicle][id] = createObject(tempdata[ids]['model'],vx,vy,vz)
						scalex, scaley, scalez = unpack(tempdata[ids]['scale'])
						setObjectScale(attachment[vehicle][id],scalex,scaley,scalez)
					end
					setElementCollisionsEnabled(attachment[vehicle][id],tempdata[ids]['col'])
					attachElements(attachment[vehicle][id],vehicle,unpack(tempdata[ids]['pos']))
					setElementParent(attachment[vehicle][id],vehicle)
				end
			end
			tempdata = {}
		else
			outputChatBox("Attachment " ..attachname.. " failed to load.", player, 0, 255, 255)
		end
	else
		outputChatBox('You must be the driver of a vehicle to use this command.', player, 0, 255, 255)
	end
end

function tempload(player,command,attachname)
		local vehicle = getPedOccupiedVehicle(player) 
		if vehicle and (isDriver(player) or hasPerms(player)) then
			if attachname then
				loadAttachment(attachname,vehicle,player)
			end
		else
			outputChatBox('You must be the driver of a vehicle to use this command.',player,0,255,255)
		end
end
addCommandHandler('loadattach',tempload)
addEvent('loadAttach',true)
addEventHandler('loadAttach',root,tempload)

function deleteattach(player,command,type,string)
	if hasPerms(player) then
		if string then
			if fileExists('attachments/'..string..'.json') then
				fileDelete('attachments/'..string..'.json')
				outputChatBox('Deleted '..string, player)
			else
				outputChatBox(string..' does not exist',player)
			end
		end
	else
		outputChatBox ('#FA1464Only administrators can use this command.',player,255,255,255,true,0,255,255)
	end
end
addCommandHandler('delattach',deleteattach)

function attachinfo(player,command,attachname)
		if hasPerms(player) then
			if fileExists('attachments/'..attachname..'.json') then
				local file = fileOpen('attachments/'..attachname..'.json')
				local size = fileGetSize(file)
				local buffer = fileRead(file,size)
				local tempdata = fromJSON(buffer)
				fileClose(file)
				for k,v in pairs (tempdata) do
					if k == 'info' then
						outputChatBox('Serial: '..tempdata['serial'],player)
					end
				end
				tempdata = {}
			else
				outputChatBox(attachname..' does not exist',player,0,255,255)
			end
		else
			return outputChatBox('#FA1464Only administrators can use this command',player,255,255,255,true)
		end
end
addCommandHandler('attachinfo',attachinfo)

function clearObjects(player,single)
	if not getElementData(player,'staff') == true then return end
	for k,v in ipairs (getElementsByType('vehicle')) do
		local attachments = getAttachedElements(v)
		if attachments then
			for j,l in ipairs (attachments) do
				if getElementType(l) == 'object' or getElementType(l) == 'vehicle' then
					destroyElement(l)
				end
			end
		end
	end
	triggerClientEvent('updateAttachGridlines',root)
	attachment = {}
	for k,v in ipairs (getElementsByType('player')) do
		vehicleobj[v] = false
	end
	outputChatBox('Attachments cleared.')
end
addCommandHandler('aclear',clearObjects)

function clearVehicleObjects(player,command,name)
	local element
	if name then
		if hasPerms(player) then
			local reference = getPlayerFromPartialName(name)
			if reference then
				local vehicle = getPedOccupiedVehicle(reference)
				if vehicle then
					element = reference
				else
					outputChatBox('This player is not in a vehicle',player,0,255,255,true)
				end
			else
				outputChatBox('Player '..name..' does not exist.',player,0,255,255,true)
			end
		else
			outputChatBox('#FA1464Only administrators can use this command',player,255,255,255,true)
		end
	
	else
		local vehicle = getPedOccupiedVehicle(player)
		if vehicle and (isDriver(player) or hasPerms(player)) then
			element = player
		else
			outputChatBox('You must be the driver of a vehicle to use this command.',player,0,255,255,true)
		end
	end
	
	if element then
		local vehicle = getPedOccupiedVehicle(element)
		local occupants = getVehicleOccupants(vehicle)
		local seats = getVehicleMaxPassengers(vehicle)
		for seat=0,seats do
			local occupant = occupants[seat]
			if occupant and vehicleobj[occupant] then
				vehicleobj[occupant] = false
			end
		end
		
		local attachments = getAttachedElements(vehicle)
		if attachments then
			for k,v in ipairs (attachments) do
				if getElementType(v) == 'object' or getElementType(v) == 'vehicle' then
					destroyElement(v)
				end
			end
		end
		triggerClientEvent('updateAttachGridlines',root)
		attachment[vehicle] = {}
	end
end  	
addCommandHandler('dee',clearVehicleObjects)
addEvent('dee',true)
addEventHandler('dee',root,clearVehicleObjects)

function banid(player,command,id)
		if hasPerms(player) then
			if id then
				if bannedids[id] then
					outputChatBox('ID is already banned.',player,0,255,255)
				else
					bannedids[id] = true
					triggerEvent('updateBannedIDs',root)
					outputChatBox('Banned '..id,player)
				end
			end
		else
			outputChatBox ('#FA1464Only administrators can use this command',player,255,255,255,true)
		end
	end
addCommandHandler('banid',banid)

function unbanid(player,command,id)
		if hasPerms(player) then
			if id then
				if bannedids[id] then
					bannedids[id] = nil
					outputChatBox('Unbanned '..id,player)
					triggerEvent('updateBannedIDs',root)
				else
					outputChatBox(id..' is not banned.',player,0,255,255)
				end
			else
				outputChatBox('SYNTAX: /unbanid objectid',player,0,255,255)
			end
		else
			outputChatBox ('#FA1464Only administrators can use this command',player,255,255,255,true)
		end
	end
addCommandHandler('unbanid',unbanid)

function hasPerms(player)
	local value = false
	if hasObjectPermissionTo(player,'function.kickPlayer',true) or getElementData(player,'staff') == true then
		value = true
	end
	return value
end

function isDriver(player)
	local value = false
	if getPedOccupiedVehicleSeat(player) == 0 then
		value = true
	end
	return value
end

function getPlayerFromPartialName(name)
	local matches = {}
	for i,player in ipairs (getElementsByType('player')) do
		if getPlayerName(player) == name then
			return player
		end
		if string.find(string.lower(getPlayerName(player)),string.lower(name),0,false) then
			table.insert(matches,player)
		end
	end
	if #matches == 1 then
		return matches[1]
	else
		return false
	end
end

function getTimeStamp()
	local time = getRealTime()
	return (time.year + 1900).."-"..(time.month+1).."-"..time.monthday.." "..time.hour..":"..time.minute..":"..time.second
end

function _set(table)
	local set = {}
	for _,v in ipairs (table) do
		set[tostring(v)] = true
	end
	return set
end

addEvent('elementSize', true)
addEventHandler('elementSize',root,function(player,var)
	if var == true then
		outputChatBox('This object is too large!',player,0,255,255)
		destroyObject(player)
		vehicleobj[player] = false
	end
end)

addEventHandler('onElementDestroy',root,function()
	if getElementType(source) == 'vehicle' then
		local occupants = getVehicleOccupants(source)
		local seats = getVehicleMaxPassengers(source)
		if seats and occupants then
			for seat=0, seats do
				local occupant = occupants[seat]
				if occupant and vehicleobj[occupant] then
					triggerClientEvent('updateAttachGridlines',root)
					vehicleobj[occupant] = false
				end
			end
		end
	end
end)

addEventHandler('onPlayerQuit',root,function()
	if vehicleobj[source] then
		destroyElement(vehicleobj[source])
		triggerClientEvent('updateAttachGridlines',root)
	end
end)

addEvent('updateBannedIDs',true)
addEventHandler('updateBannedIDs',resourceRoot,function()
	local file = fileCreate('banned.json')
	fileWrite(file,toJSON(bannedids))
	fileClose(file)
end)

addEventHandler('onResourceStart',resourceRoot,function()
	if not fileExists('banned.json') then
		fileCreate('banned.json')
	end
	local file1 = fileOpen('banned.json')
	local size1 = fileGetSize(file1)
	local buffer1 = fileRead(file1,size1)
	bannedids = fromJSON(buffer1)
	fileClose(file1)
	local file2 = fileOpen('invalidmodels.json')
	local size2 = fileGetSize(file2)
	local buffer2 = fileRead(file2,size2)
	invalidmodels = fromJSON(buffer2)
	fileClose(file2)
end)