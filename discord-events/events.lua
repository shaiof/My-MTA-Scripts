--[[
[ { "message": { "id": "302938752928710656", "text": "message" }, "author": { "id": "228305462938959872", "name": "Shay", "roles": [ "@everyone", "Owner" ] } } ]
]]
DirectLink = 'http://www.fencski.ga/mta/'
symbol = '!'
functions = {
	{'start','startResource',{'Admin','Owner'}},
	{'stop','stopResource',{'Admin','Owner'}},
	{'restart','restartResource',{'Admin','Owner'}},
	{'say','outputChat',{'@everyone'}},
	{'s','outputChat',{'@everyone'}},
	{'kill','killPed',{'Moderator','Super Moderator','Admin','Owner'}},
	{'players','listPlayers',{'@everyone'}},
	{'plrs','listPlayers',{'@everyone'}},
	{'cunts','listPlayers',{'@everyone'}},
	{'account','getAccount',{'@everyone'}},
	{'acc','getAccount',{'@everyone'}},
	{'kick','kickPlayer',{'Moderator','Super Moderator','Admin','Owner'}},
	{'unmute','unmutePlayer',{'Moderator','Super Moderator','Admin','Owner'}},
	{'mute','mutePlayer',{'Moderator','Super Moderator','Admin','Owner'}},
	{'banserial','banserial',{'Admin','Owner'}},
	{'banip','banip',{'Admin','Owner'}},
	{'banlist','banlist',{'Admin','Owner'}},
	{'ban','banPlayer',{'Admin','Owner'}},
	{'unban','unban',{'Admin','Owner'}},
	{'getserial','getSerial',{'Admin','Owner'}},
	{'reloadbans','reloadBans',{'Owner'}},
	{'cmds','commands',{'@everyone'}},
	{'commands','commands',{'@everyone'}},
	{'server','showServerInfo',{'@everyone'}}
}
chatReplacements = {-- Use these if you want to replace some text in the discord to mta chat..
	{':smile:',':D'},-- Format textToReplace,textYouWantToReplaceItWith
	{':smiley:',':)'},
	{':frowning:',':('},
	{':stuck_out_tongue:',':P'},
	{':unamused:',':$'},
	{':rage:',':@'},
	{':kissing:',':*'}
}
dataTable = {}
-- Predefined Functions --
function string.count(text,search)
	if (not text or not search) then return false end
	return select(2,text:gsub(search,""))
end

function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x",""):lower() or nil
    if name then
        for _,player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x",""):lower()
            if name_:find(name,1,true) then
                return player
            end
        end
    end
end

SERVER_IP = "127.0.0.1"
function getServerIp()
    return SERVER_IP
end
fetchRemote("http://checkip.dyndns.com/",function (response)
    if response ~= "ERROR" then
        SERVER_IP = response:match("<body>Current IP Address: (.-)</body>") or "127.0.0.1"
    end
end)

function runFunction(payload)
	local mTable = split(payload.message.text,' ')
	for i,v in pairs(functions) do
		if symbol..v[1] == mTable[1] then
			for l,k in pairs(payload.author.roles) do
				for o,p in pairs(v[3]) do
					if k == p then
						triggerEvent(v[2],root,payload,mTable)
						local file = fileCreate('test.json')
						local data = toJSON(payload)
						fileWrite(file,data)
						fileClose(file)
					end
				end
            end
        end
    end
end

addEvent('outputChat',true)
addEventHandler('outputChat',root,function(payload,extra)
	if extra[2] then
		table.remove(extra,1)
		local message = table.concat(extra,' ')
		for i,v in pairs(chatReplacements) do
			if string.find(message,v[1]) then
				message = string.gsub(message,v[1],v[2],1,true)
			end
		end
		if message then
			outputChatBox("#FF0050[Discord] #FFFFFF"..payload.author.name..": "..message,root,255,255,255,true)
		end
	end
end)

addEvent('killPed',true)
addEventHandler('killPed',root,function()
	local newPlayer = getPlayerFromPartialName(dataTable[2])
	if newPlayer then
		killPed(newPlayer)
		outputChatBox("#FF0050[Discord] #FFFFFF"..payload.author.name.." killed "..getPlayerName(newPlayer)..".",root,255,255,255,true)
		exports.discord:send("chat.message.action", { author = payload.author.name, text = "killed "..getPlayerName(newPlayer).."." })
	end
end)

function getPlayerCount()
	local num = 0
	for i,v in pairs(getElementsByType('player')) do
		num = num+1
	end
	return num
end

addEvent('showServerInfo',true)
addEventHandler('showServerInfo',root,function()
	local name = getServerName()
	local port = getServerPort()
	local version = getVersion()
	local fpsLimit = getFPSLimit()
	local maxPlayers = getMaxPlayers()
	local serverip = getServerIp()
	local playerCount = getPlayerCount()
	exports.discord:send("chat.message.text",{author = 'Server',text = name..'\n'..'mtasa://'..serverip..':'..port..' '..'['..version.os..'] '..version.name..' '..version.mta..'\nPlayers: '..playerCount..'/'..maxPlayers..' FPS Limit: '..fpsLimit..'\nDirect Join Link: '..DirectLink})
end)

addEvent('listPlayers',true)
addEventHandler('listPlayers',root,function()
	players = {}
	for i,v in pairs(getElementsByType('player')) do
		local name = getPlayerName(v)
		table.insert(players,name)
	end
	if players[1] then
		exports.discord:send("chat.message.text",{author = 'Server',text = table.concat(players,', ')})
	else
		exports.discord:send("chat.message.text",{author = 'Server',text = 'No players are online currently.'})
	end
end)

addEvent('getAccount',true)
addEventHandler('getAccount',root,function()
	local newPlayer = getPlayerFromPartialName(dataTable[2])
	if newPlayer then
		local account = getPlayerAccount(newPlayer)
		if account then
			exports.discord:send("chat.message.text",{author = 'Server',text = getPlayerName(newPlayer).."'s account is: "..getAccountName(account)})
		else
			exports.discord:send("chat.message.text",{author = 'Server',text = getPlayerName(newPlayer).." is not logged in."})
		end
	end
end)

addEvent('kickPlayer',true)
addEventHandler('kickPlayer',root,function()
	local new = getPlayerFromPartialName(dataTable[2])
	if new then
		kickPlayer(new,payload.author.name,'Kicked by '..payload.author.name)
	end
end)

addEvent('mutePlayer',true)
addEventHandler('mutePlayer',root,function()
	local new = getPlayerFromPartialName(dataTable[2])
	if new then
		if isPlayerMuted(new) then
			setPlayerMuted(new,false)
			outputChatBox("#FF0050[Discord] #FFFFFF"..payload.author.name.." unmuted "..getPlayerName(new)..".",root,255,255,255,true)
		else
			setPlayerMuted(new,true)
			outputChatBox("#FF0050[Discord] #FFFFFF"..payload.author.name.." muted "..getPlayerName(new)..".",root,255,255,255,true)
		end
	end
end)

addEvent('unmutePlayer',true)
addEventHandler('unmutePlayer',root,function()
	local new = getPlayerFromPartialName(dataTable[2])
	if new then
		if isPlayerMuted(new) then
			setPlayerMuted(new,false)
			outputChatBox("#FF0050[Discord] #FFFFFF"..payload.author.name.." unmuted "..getPlayerName(new)..".",root,255,255,255,true)
		end
	end
end)

addEvent('banserial',true)
addEventHandler('banserial',root,function()
	if dataTable[2] then
		addBan(dataTable[2],payload.author.name)
		exports.discord:send("chat.message.text",{author = payload.author.name,text = "banned Serial: "..dataTable[2]})
	end
end)

addEvent('banip',true)
addEventHandler('banip',root,function()
	if dataTable[2] then
		addBan(dataTable[2],payload.author.name)
		exports.discord:send("chat.message.text",{author = payload.author.name,text = "banned IP: "..dataTable[2]})
	end
end)

addEvent('banPlayer',true)
addEventHandler('banPlayer',root,function()
	local new = getPlayerFromPartialName(dataTable[2])
	if new then
		banPlayer(new,false,false,true,payload.author.name)
	end
end)

addEvent('unban',true)
addEventHandler('unban',root,function()
	local bans = getBans()
	if bans then
		for i,ban in ipairs(bans) do
			if tostring(i) == dataTable[2] or getBanNick(ban) == dataTable[2] or getBanSerial(ban) == dataTable[2] or getBanIP(ban) == dataTable[2] or getBanUsername(ban) == dataTable[2] then
				removeBan(ban,payload.author.name)
				exports.discord:send("chat.message.text",{author = payload.author.name,text = "unbanned: "..dataTable[2]})
			end
		end
	end
end)

addEvent('getSerial',true)
addEventHandler('getSerial',root,function()
	local new = getPlayerFromPartialName(dataTable[2])
	if new then
		exports.discord:send("chat.message.text",{author = 'Server',text = getPlayerName(new).."'s serial: "..getPlayerSerial(new)})
	end
end)

addEvent('banlist',true)
addEventHandler('banlist',root,function()
	local bans = getBans()
	if bans then
		for i,ban in ipairs(bans) do
			local nick = getBanNick(ban)
			local ip = getBanIP(ban)
			local serial = getBanSerial(ban)
			local who = getBanAdmin(ban)
			exports.discord:send("chat.message.text",{author = 'Server',text = 'ID: '..i..' Name: '..nick..' Serial: '..serial..' By: '..who})
		end
	end
end)

addEvent('reloadBans',true)
addEventHandler('reloadBans',root,function()
	if reloadBans() then
		exports.discord:send("chat.message.text",{author = payload.author.name,text = 'sucessfully removed all bans.'})
	end
end)

function getPlayerACL(player)
	
end

addEvent('commands',true)
addEventHandler('commands',root,function(payload)
	cmdList = {}
	for i,v in ipairs(functions) do
        local accessGroups = v[3]
		for k,l in pairs(accessGroups) do
			for y,u in pairs(payload.author.roles) do
				if l == u then
					table.insert(cmdList,symbol..v[1])
				end
			end
		end
	end
	cmdList = table.concat(cmdList,', ')
	setTimer(function()
		exports.discord:send("chat.message.text",{author = 'Server',text = payload.author.name..' You can do the following commands: '..cmdList})
	end,1000,1)
end)

addEvent('startResource',true)
addEventHandler('startResource',root,function(payload,extra)
	if extra[2] then
		local r = getResourceFromName(extra[2])
		if r then
			if getResourceState(r) == 'loaded' then
				startResource(r)
			elseif getResourceState(r) == 'running' then
				exports.discord:send("chat.message.interchat",{author = 'Server',text = 'Resource Already Started: '..extra[2]})
			end
		end
	end
end)

addEvent('stopResource',true)
addEventHandler('stopResource',root,function(payload,extra)
	if extra[2] then
		local r = getResourceFromName(extra[2])
		if r then
			if getResourceState(r) == 'running' then
				stopResource(r)
			elseif getResourceState(r) == 'loaded' then
				exports.discord:send("chat.message.interchat",{author = 'Server',text = 'Resource Already Stopped: '..extra[2]})
			end
		end
	end
end)

addEvent('restartResource',true)
addEventHandler('restartResource',root,function(payload,extra)
	if extra[2] then
		local r = getResourceFromName(extra[2])
		if r then
			if getResourceState(r) == 'running' then
				stopResource(r)
				startResource(r)
			end
		end
	end
end)
----------------------------------

function string:monochrome()
    local colorless = self:gsub("#%x%x%x%x%x%x","")
    if colorless == "" then
        return self:gsub("#(%x%x%x%x%x%x)","#\1%1")
    else
        return colorless
    end
end

function getPlayerName(player)
    return player.name:monochrome()
end

addEventHandler("onPlayerJoin",root,function()
    exports.discord:send("player.join",{player=getPlayerName(source)})
end)

addEventHandler("onPlayerQuit",root,function(quitType,reason,responsible)
    local playerName = getPlayerName(source)
    if isElement(responsible) then
        if getElementType(responsible) == "player" then
            responsible = getPlayerName(responsible)
        else
            responsible = "Console"
        end
    else
        responsible = false
    end
    if type(reason) ~= "string" or reason == "" then
        reason = false
    end
    if quitType == "Kicked" and responsible then
        exports.discord:send("player.kick",{player=playerName,responsible=responsible,reason=reason})
    elseif quitType == "Banned" and responsible then
        exports.discord:send("player.ban",{player=playerName,responsible=responsible,reason=reason})
    else
        exports.discord:send("player.quit",{player=playerName,type=quitType,reason=reason})
    end
end)

addEventHandler("onPlayerChangeNick",root,function(previous,nick)
    exports.discord:send("player.nickchange",{player=nick:monochrome(),previous=previous:monochrome()})
end)

addEventHandler("onPlayerChat",root,function(message,messageType)
    if messageType == 0 then
        exports.discord:send("chat.message.text",{author=getPlayerName(source),text=message})
    elseif messageType == 1 then
        exports.discord:send("chat.message.action",{author=getPlayerName(source),text=message})
    end
end)

addEvent("onInterchatMessage")
addEventHandler("onInterchatMessage",root,function(server,playerName,message)
    exports.discord:send("chat.message.interchat",{author=playerName:monochrome(),server=server,text=message})
end)

addEvent("onDiscordPacket")
addEventHandler("onDiscordPacket",root,function(packet,payload)
	runFunction(payload)
end)

addEventHandler("onPlayerMute",root,function(state)
    exports.discord:send("player.mute",{player=getPlayerName(source)})
end)

addEventHandler("onPlayerUnmute",root,function()
    exports.discord:send("player.unmute",{player=getPlayerName(source)})
end)