------------ Configuration ------------
local apiKey = 'AIzaSyBtKLqfMivRoqZ2hlnWMQDgXvVv56qEg08'-- This is your google youtube api key.
-- This api is used to get the name and duration of the videos. Visit https://developers.google.com/youtube/v3/ for help getting your api key.

local converter = 'http://convertmp3.io/fetch/?video={url}'-- {url} stands for a full youtube url, use {ytid} for converters that need an id instead of link
-- This api is used to convert youtube links into mp3 format so that MTA can play them.

aclStaffGroups = {'Moderator','SuperModerator','Admin','Console'}-- Change this if you have different acl groups, these are the defaults.

Radios = {-- Add or remove stations here, these are all from the older flowersounds.
	{'classicrock','http://108.61.73.117:10002'},
	{'herpy','http://68.68.105.148:80'},
	{'qdance','http://radio.q-dance.nl/q-danceradio.pls'},
	{'goldies','http://108.61.73.119:8900'},
	{'oldies','http://108.61.73.117:8900'},
	{'lounge','http://205.164.36.5'},
	{'dnb','http://50.7.98.106:8398'},
	{'181','http://108.61.73.119:8128'},
	{'house','http://goo.gl/LY7AAx'},
	{'trance','http://goo.gl/YxQVof'},
	{'moardubs','http://goo.gl/H1PuDX'},
	{'90sdance','http://goo.gl/1JVGCm'},
	{'80spop','http://goo.gl/7bmfjf'},
	{'dancehits2','http://goo.gl/ca8VRv'},
	{'electrodance1','http://goo.gl/948MfL'},
	{'hiphop','http://yp.shoutcast.com/sbin/tunein-station.pls?id=8318'},
	{'90s','http://108.61.73.115:8052'},
	{'Break','http://air.radiorecord.ru:8102/brks_320'},
	{'Trap','http://air.radiorecord.ru:8102/trap_320'},
	{'evenmoardubs','http://air.radiorecord.ru:8102/dub_320'},
	{'Hardkick','http://air.radiorecord.ru:8102/dc_320'},
	{'DnB2','http://air.radiorecord.ru:8102/ps_320'},
	{'Hardkick2','http://air.radiorecord.ru:8102/teo_320'},
	{'Gold104','http://player.arn.com.au/alternate/gold1043.pls'},
	{'Oldies2','http://servers.internet-radio.com/tools/playlistgenerator/?u=http://uplink.181.fm:8062/listen.pls&t=.pls'},
	{'TripleJ','http://www.abc.net.au/res/streaming/audio/aac/triplej.pls'},
	{'LuvTunes1','http://servers.internet-radio.com/tools/playlistgenerator/?u=http://205.164.62.15:10048/listen.pls&t=.pls'},
	{'Soup2','http://sc-tcl.1.fm:8010'},
	{'Soup3','http://rmnrelax1.powerstream.de:8023'},
	{'dragonforce','http://a.tumblr.com/rCFBmkCiupp87w9cK55ubcDco1.mp3'},
	{'DnB3','www.dirtlabaudio.com/listen.m3u'},
	{'AirRus2','http://air.radiorecord.ru:8102/sd90_320'},
	{'AirRus1','http://air.radiorecord.ru:8102/rus_320'},
	{'disco','http://208.77.21.31:9830'},
	{'homeofhiphop','http://listen.radionomy.com:80/HomeofHipHop'},
	{'gfunk','http://listen.radionomy.com:80/G-FunkClassics'},
	{'CaveFM','http://108.61.30.179:5000'},
	{'oldschoolrap3','http://truehiphop.dyndns.org:9020/listen.pls'}
}
local matchingIDs = {'v=(.+)','tu.be/(.+)','/v/(.+)'}
---------------------------------------
----------- Useful Functions ----------
function isPlayerStaff(player)
	local result
	local acc = getPlayerAccount(player)
	if acc then
		local accName = getAccountName(acc)
		if accName then
			local check = 'user.'..accName
			for i,v in pairs(aclStaffGroups) do
				if isObjectInACLGroup(check,aclGetGroup(v)) then
					result = true
				end
			end
		end
	end
	return false
end

function getReserved(path)
	for i,v in pairs(Radios) do
		if path == v[1] then
			return v[2]
		end
	end
	return false
end

function validateURL(url)
	local id
	for i,matching in ipairs(matchingIDs) do
		if not id then
			id = url:match(matching)
		end
	end
	if id then
		local id = id:sub(0,11)
		return id
	end
end

function convertLink(linkUrl)
	if validateURL(linkUrl) then
		if string.find(converter,'{url}',1,true) then
			return string.gsub(converter,'{url}',tostring(linkUrl)) or linkUrl
		elseif string.find(converter,'{ytid}',1,true) then
			return string.gsub(converter,'{ytid}',tostring(validateURL(linkUrl))) or linkUrl
		end
	end
end

function getPlayerFromPartialName(name)
    local name = name and name:gsub('#%x%x%x%x%x%x',''):lower() or nil
    if name then
        for _,player in ipairs(getElementsByType('player')) do
            local name_ = getPlayerName(player):gsub('#%x%x%x%x%x%x',''):lower()
            if name_:find(name,1,true) then
                return player
            end
        end
    end
end
---------------------------------------
local cmds = {'play','radio','stopsongs','stopsounds','clearsounds'}

function playSound(player,cmd,url,value)
	if not url then triggerClientEvent('stopPlayerSongs',root,player) return end
	local id = validateURL(url)
	if id then
		local fetch = fetchRemote('https://www.googleapis.com/youtube/v3/videos?id='..id..'&key='..apiKey..'&fields=items(snippet(title),contentDetails(duration))&part=snippet,contentDetails',2,
		function(data,err)
			if err == 0 then
				local info = fromJSON(data)
				if info then
					for _,v in pairs(info.items) do
						title = v.snippet.title
						author = v.snippet.channelTitle
					end
					if title then
						title = title or url
						author = author or 'None'
						local soundLink = convertLink(url)
						local name = '[YouTube] '..title
						if cmd == cmds[1] then
							triggerClientEvent('play',root,player,soundLink,name,author)
						elseif cmd == cmds[2] then
							local vehicle = getPedOccupiedVehicle(player)
							if vehicle then
								local x,y,z = getElementPosition(vehicle)
								triggerClientEvent('playSound',root,player,vehicle,x,y,z,soundLink,name,false)
							elseif value then
								if value == 'false' then
									local x,y,z = getElementPosition(player)
									triggerClientEvent('playSound',root,player,false,x,y,z,soundLink,name,true)
								end
							else
								local x,y,z = getElementPosition(player)
								triggerClientEvent('playSound',root,player,false,x,y,z,soundLink,name,false)
							end
						elseif cmd == cmds[3] then
							triggerClientEvent('stopPlayerSongs',root,player,player)
						elseif cmd == cmds[4] and isPlayerStaff(player) then
							if other then
								local otherPlayer = getPlayerFromPartialName(other)
								if otherPlayer then
									triggerClientEvent('stopPlayerSongs',root,player,otherPlayer)
									outputChatBox(getPlayerName(player)..' has stopped your sounds!',otherPlayer,255,0,0)
									outputChatBox('You have stoppped '..getPlayerName(otherPlayer).."'s sounds!",otherPlayer,255,0,0)
								end
							end
						elseif cmd == cmds[5] and isPlayerStaff(player) then
							triggerClientEvent('stopAllSongs',root,player)
							outputChatBox(getPlayerName(player)..' has stopped all sounds!',root,255,0,0)
						end
					end
				end
			end
			return
		end,'',true)
	elseif not id then
		if cmd == cmds[1] then
			local reservedSound = getReserved(url)
			if reservedSound then
				url = reservedSound
			end
			triggerClientEvent('play',root,player,url,url,'')
		elseif cmd == cmds[2] then
			local reservedSound = getReserved(url)
			if reservedSound then
				url = reservedSound
			end
			local vehicle = getPedOccupiedVehicle(player)
			if vehicle then
				local x,y,z = getElementPosition(vehicle)
				triggerClientEvent('playSound',root,player,true,x,y,z,url,url,false)
			elseif value then
				if value == 'false' then
					local x,y,z = getElementPosition(player)
					triggerClientEvent('playSound',root,player,false,x,y,z,url,url,true)
				end
			else
				local x,y,z = getElementPosition(player)
				triggerClientEvent('playSound',root,player,false,x,y,z,url,url,false)
			end
		elseif cmd == cmds[3] then
			triggerClientEvent('stopPlayerSongs',root,player,player)
		elseif cmd == cmds[4] and isPlayerStaff(player) then
			if other then
				local otherPlayer = getPlayerFromPartialName(other)
				if otherPlayer then
					triggerClientEvent('stopPlayerSongs',root,player,otherPlayer)
					outputChatBox(getPlayerName(player)..' has stopped your sounds!',otherPlayer,255,0,0)
					outputChatBox('You have stoppped '..getPlayerName(otherPlayer).."'s sounds!",otherPlayer,255,0,0)
				end
			end
		elseif cmd == cmds[5] and isPlayerStaff(player) then
			triggerClientEvent('stopAllSongs',root,player)
			outputChatBox(getPlayerName(player)..' has stopped all sounds!',root,255,0,0)
		end
	end
end

for i=1,#cmds do
	addCommandHandler(cmds[i],playSound)
end