local attachedEffects = {}

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element )
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z
end
 
function attachEffect(effect, element, pos)
	attachedEffects[effect] = { effect = effect, element = element, pos = pos }
	addEventHandler("onClientElementDestroy", effect, function() attachedEffects[effect] = nil end)
	addEventHandler("onClientElementDestroy", element, function() attachedEffects[effect] = nil end)
	return true
end
 
addEventHandler("onClientPreRender", root, 	
	function()
		for fx, info in pairs(attachedEffects) do
			local x, y, z = getPositionFromElementOffset(info.element, info.pos.x, info.pos.y, info.pos.z)
			setElementPosition(fx, x, y, z)
		end
	end
)

function callClientFunction(client, funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    triggerClientEvent(client, "onServerCallsClientFunction", resourceRoot, funcname, unpack(arg or {}))
end

allowedFunctions = { ["setPlayerTeam"]=true, ["getListOfCheese"]=true }
 
function callServerFunction(funcname, ...)
    if not allowedFunctions[funcname] then
        outputServerLog( "SECURITY: " .. tostring(getPlayerName(client)) .. " tried to use function " .. tostring(funcname) )
        return
    end
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end
addEvent("onClientCallsServerFunction", true)
addEventHandler("onClientCallsServerFunction", resourceRoot , callServerFunction)

local function doCapitalizing( substring )
    return substring:sub( 1, 1 ):upper( ) .. substring:sub( 2 )
end
 
function capitalize( text )
    assert( type( text ) == "string", "Bad argument 1 @ capitalize [String expected, got " .. type( text ) .. "]")
    return ( { string.gsub( text, "%a+", doCapitalizing ) } )[1]
end

function Check(funcname, ...)
    local arg = {...}
    if (type(funcname) ~= "string") then
        error("Argument type mismatch at 'Check' ('funcname'). Expected 'string', got '"..type(funcname).."'.", 2)
    end
    if (#arg % 3 > 0) then
        error("Argument number mismatch at 'Check'. Expected #arg % 3 to be 0, but it is "..(#arg % 3)..".", 2)
    end
    for i=1, #arg-2, 3 do
        if (type(arg[i]) ~= "string" and type(arg[i]) ~= "table") then
            error("Argument type mismatch at 'Check' (arg #"..i.."). Expected 'string' or 'table', got '"..type(arg[i]).."'.", 2)
        elseif (type(arg[i+2]) ~= "string") then
            error("Argument type mismatch at 'Check' (arg #"..(i+2).."). Expected 'string', got '"..type(arg[i+2]).."'.", 2)
        end
        if (type(arg[i]) == "table") then
            local aType = type(arg[i+1])
            for _, pType in next, arg[i] do
                if (aType == pType) then
                    aType = nil
                    break
                end
            end
            if (aType) then
                error("Argument type mismatch at '"..funcname.."' ('"..arg[i+2].."'). Expected '"..table.concat(arg[i], "' or '").."', got '"..aType.."'.", 3)
            end
        elseif (type(arg[i+1]) ~= arg[i]) then
            error("Argument type mismatch at '"..funcname.."' ('"..arg[i+2].."'). Expected '"..arg[i].."', got '"..type(arg[i+1]).."'.", 3)
        end
    end
end

function convertNumber ( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end

function convertServerTickToTimeStamp(tick) return getRealTime().timestamp+((getTickCount()*0.001)-(tick*0.001)); end

function convertTextToSpeech(text, broadcastTo, lang)
    assert(type(text) == "string", "Bad argument 1 @ convertTextToSpeech [ string expected, got " .. type(text) .. "]")
    assert(#text <= 100, "Bad argument 1 @ convertTextToSpeech [ too long string; 100 characters maximum ]")
    if triggerClientEvent then
        assert(broadcastTo == nil or type(broadcastTo) == "table" or isElement(broadcastTo), "Bad argument 2 @ convertTextToSpeech [ table/element expected, got " .. type(broadcastTo) .. "]")
        assert(lang == nil or type(lang) == "string", "Bad argument 3 @ convertTextToSpeech [ string expected, got " .. type(lang) .. "]")
        return triggerClientEvent(broadcastTo or root, "playTTS", root, text, lang or "en")
    else
        local lang = broadcastTo
        assert(lang == nil or type(lang) == "string", "Bad argument 2 @ convertTextToSpeech [ string expected, got " .. type(lang) .. "]")
        return playTTS(text, lang or "en")
    end
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

local gWeekDays = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
function FormatDate(format, escaper, timestamp)
	Check("FormatDate", "string", format, "format", {"nil","string"}, escaper, "escaper", {"nil","string"}, timestamp, "timestamp")
	escaper = (escaper or "'"):sub(1, 1)
	local time = getRealTime(timestamp)
	local formattedDate = ""
	local escaped = false
	time.year = time.year + 1900
	time.month = time.month + 1
	local datetime = { d = ("%02d"):format(time.monthday), h = ("%02d"):format(time.hour), i = ("%02d"):format(time.minute), m = ("%02d"):format(time.month), s = ("%02d"):format(time.second), w = gWeekDays[time.weekday+1]:sub(1, 2), W = gWeekDays[time.weekday+1], y = tostring(time.year):sub(-2), Y = time.year }
	for char in format:gmatch(".") do
		if (char == escaper) then escaped = not escaped
		else formattedDate = formattedDate..(not escaped and datetime[char] or char) end
	end
	return formattedDate
end

function generateRandomASCIIString(chars)
	local str = ""
	for i = 1, chars do 
		str = str..(string.format("%c", math.random(32, 126)))
	end
	return str
end

local allowed = { { 48, 57 }, { 65, 90 }, { 97, 122 } } -- numbers/lowercase chars/uppercase chars
 
function generateString ( len )
    if tonumber ( len ) then
        math.randomseed ( getTickCount () )
        local str = ""
        for i = 1, len do
            local charlist = allowed[math.random ( 1, 3 )]
            str = str .. string.char ( math.random ( charlist[1], charlist[2] ) )
        end
        return str
    end
    return false
end

function getAge(day, month, year)
	local time = getRealTime();
	time.year = time.year + 1900;
	time.month = time.month + 1;
	year = time.year - year;
	month = time.month - month;
	if month < 0 then 
		year = year - 1 
	elseif month == 0 then
		if time.monthday < day then
			year = year - 1;
		end
	end
	return year;
end

function getAlivePlayersInTeam(theTeam)
    local theTable = { }
    local players = getPlayersInTeam(theTeam)
    for i,v in pairs(players) do
      if not isPedDead(v) then
        theTable[#theTable+1]=v
      end
    end
 
    return theTable
end

function getBanFromName (name)
    for key, ban in ipairs(getBans()) do
        if (getBanNick(ban) == name) then
	    return ban
	end
    end
    return false
end

function getDistanceBetweenPointAndSegment2D(pointX, pointY, x1, y1, x2, y2)
	local A = pointX - x1
	local B = pointY - y1
	local C = x2 - x1
	local D = y2 - y1
	local point = A * C + B * D
	local lenSquare = C * C + D * D
	local parameter = point / lenSquare
	local shortestX
	local shortestY
	if parameter < 0 then
		shortestX = x1
    		shortestY = y1
	elseif parameter > 1 then
		shortestX = x2
		shortestY = y2
	else
		shortestX = x1 + parameter * C
		shortestY = y1 + parameter * D
	end
	local distance = getDistanceBetweenPoints2D(pointX, pointY, shortestX, shortestY)
	return distance
end

function getEasterDate(year)
    local y = tonumber(year)
    assert(y, "Bad argument 1 @ getEasterDate [Number expected, got " .. type(year) .. "]")
    local M = 24
    local N = 5
    local a = y%19
    local b = y%4
    local c = y%7 
    local d = (19*a+M)%30 
    local e = (2*b+4*c+6*d+N)%7 
    local dayMar = 22+d+e
    local dayApr = d+e-9
    if dayMar > 31 then
        return dayApr, 4
    else
        return dayMar, 3
    end
end

function getElementsInDimension(theType,dimension)
    local elementsInDimension = { }
      for key, value in ipairs(getElementsByType(theType)) do
        if getElementDimension(value)==dimension then
        table.insert(elementsInDimension,value)
        end
      end
      return elementsInDimension
end

function getElementSpeed(theElement, unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function getElementsWithinMarker(marker)
	if (not isElement(marker) or getElementType(marker) ~= "marker") then
		return false
	end
	local markerColShape = getElementColShape(marker)
	local elements = getElementsWithinColShape(markerColShape)
	return elements
end

function getJetpackWeaponsEnabled()
	local enabled = {}
	for i=0, 46 do
		local wepName = getWeaponNameFromID(i)
		if getJetpackWeaponEnabled(wepName) then
			table.insert(enabled,wepName)
		end
	end
	return enabled
end

function getKeyFromValueInTable(a, b)
    for k,v in pairs(a) do
        if v == b then
           return k
        end
    end
    return false
end

function getOffsetFromXYZ( mat, vec )
    mat[1][4] = 0
    mat[2][4] = 0
    mat[3][4] = 0
    mat[4][4] = 1
    mat = matrix.invert( mat )
    local offX = vec[1] * mat[1][1] + vec[2] * mat[2][1] + vec[3] * mat[3][1] + mat[4][1]
    local offY = vec[1] * mat[1][2] + vec[2] * mat[2][2] + vec[3] * mat[3][2] + mat[4][2]
    local offZ = vec[1] * mat[1][3] + vec[2] * mat[2][3] + vec[3] * mat[3][3] + mat[4][3]
    return {offX, offY, offZ}
end

function getOnlineAdmins()
	local t = {}
	for k,v in ipairs ( getElementsByType("player") ) do
		local acc = getPlayerAccount(v)
		if acc and not isGuestAccount(acc) then
			local accName = getAccountName(acc)
			local isAdmin = isObjectInACLGroup("user."..accName,aclGetGroup("Admin"))
			if isAdmin then
				table.insert(t,v)
			end
		end
	end
	return t
end

function getPedMaxHealth(ped)
    assert(isElement(ped) and (getElementType(ped) == "ped" or getElementType(ped) == "player"), "Bad argument @ 'getPedMaxHealth' [Expected ped/player at argument 1, got " .. tostring(ped) .. "]")
    local stat = getPedStat(ped, 24)
    local maxhealth = 100 + (stat - 569) / 4.31
    return math.max(1, maxhealth)
end

function getPedMaxOxygenLevel(ped)
    assert(isElement(ped) and (getElementType(ped) == "ped" or getElementType(ped) == "player"), "Bad argument @ 'getPedMaxOxygenLevel' [Expected ped at argument 1, got " .. tostring(ped) .. "]")
    local stat = getPedStat(ped, 225)
    local maxoxygen = 1750 + stat * 1.5
    return maxoxygen
end

function getPlayerAcls(thePlayer)
    local acls = {}
    local account = getPlayerAccount(thePlayer)
    if (account) and not (isGuestAccount(account)) then
        local accountName = getAccountName(account)
        for i,group in ipairs(aclGroupList()) do
            if (isObjectInACLGroup( "user." ..accountName, group)) then
                local groupName = aclGroupGetName(group)
                table.insert(acls, groupName)
            end
        end
    end
    return acls
end

function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

function getPlayersByData(dataName)
    if dataName and type(dataName) == "string" then
	local playersTable = {}
	for i,v in ipairs(getElementsByType("player")) do
	    if getElementData(v, dataName) then
                table.insert(playersTable, v)
	    end
	end
	if #playersTable == 0 then
	    return false
	end
	return playersTable
    else
        return false
    end
end

function getPlayersInGroup ( GroupName )
    local aTable = {}
    assert ( tostring ( GroupName ) , "Bad Argument At Argument #1 Group Moust String" )
    assert ( aclGetGroup ( tostring ( GroupName ) ) , "Bad Argument At Argument #1 Group not Found "  )
    for i , player_ in ipairs ( getElementsByType ( "player" ) ) do
    local TheAcc =  getPlayerAccount ( player_ )
    if not isGuestAccount ( TheAcc ) then  
    if isObjectInACLGroup ( "user." ..getAccountName ( TheAcc ) , aclGetGroup ( tostring ( GroupName ) ) ) then
    table.insert ( aTable , player_ )
             end  
        end
    end 
    return aTable
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end

function getRandomVehicle( )
    local vehicles = getElementsByType "vehicle"
    local numberOfVehs = #vehicles
    if numberOfVehs == 0 then
        return false
    end
    return vehicles[ math.random( 1, numberOfVehs ) ]
end

function getResourceScripts(resource)
    local scripts = {}
    local resourceName = getResourceName(resource)
    local theMeta = xmlLoadFile(":"..resourceName.."/meta.xml")
    for i, node in ipairs (xmlNodeGetChildren(theMeta)) do
        if (xmlNodeGetName(node) == "script") then
            local script = xmlNodeGetAttribute(node, "src")
            if (script) then
                table.insert(scripts, script)
            end
        end
    end
    return scripts
end

function getResourceSettings ( resource )
	if ( not resource ) then
		return false
	end
    local settingsTable = { }
    local name          = getResourceName ( resource )
    local meta          = xmlLoadFile     ( ":".. name .."/meta.xml" )
	if ( not meta ) then
		return false
	end
    local settings = xmlFindChild ( meta, "settings", 0 )
    if ( settings ) then
        for _, setting in ipairs ( xmlNodeGetChildren ( settings ) ) do
            local oldName      = xmlNodeGetAttribute ( setting, "name" )
            local temp         = string.gsub ( oldName, '[%*%#%@](.*)','%1' )
            table.insert (
				settingsTable,
					{
						string.gsub ( temp, name ..'%.(.*)','%1' ),
						xmlNodeGetAttribute ( setting, "value" ),
						xmlNodeGetAttribute ( setting, "friendlyname" ),
						xmlNodeGetAttribute ( setting, "accept" ),
						xmlNodeGetAttribute ( setting, "desc" ),
						xmlNodeGetAttribute ( setting, "group" )
					}
				)
        end
    end
    xmlUnloadFile ( meta )
    return settingsTable
end

function getRGColorFromPercentage(percentage)
	if not percentage or
		percentage and type(percentage) ~= "number" or
		percentage > 100 or percentage < 0 then
		outputDebugString( "Invalid argument @ 'getRGColorFromPercentage'", 2 )
		return false
	end
	if percentage > 50 then
		local temp = 100 - percentage
		return temp*5.1, 255
	elseif percentage == 50 then
		return 255, 255
	end
	return 255, percentage*5.1
end

function getTeamFromColor(r,g,b)
	if 
		not r or type(r)~="number" or r<0 or r>255 or
		not g or type(g)~="number" or g<0 or g>255 or
		not b or type(b)~="number" or b<0 or b>255
	then outputDebugString("getTeamFromColor - Bad Arguments",0) return false end
 
	for _,team in ipairs(getElementsByType("team"))do
		local tR,tG,tB = getTeamColor(team)
		if tR==r and tG==g and tB==b then
			return team
		end
	end
	return false
end

function getTeamsWithFewestPlayers(t)
    if t and type(t)=="table" then
        for i,v in ipairs(t) do
             if (not isElement(v)) or (type(v) ~= "team") then
                 return false
             end
        end
    else t = getElementsByType("team") end
    local lowestScorers, lowestCount = {}, math.huge
    for i,v in ipairs(t) do
        local count = countPlayersInTeam(v)
        if count < lowestCount then
            lowestScorers = {v}
            lowestCount = count
        elseif count == lowestCount then
            table.insert(lowestScorers, v)
        end
    end
    return lowestScorers
end

function getTimestamp(year, month, day, hour, minute, second)
    local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second
    for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
    for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second
    if datetime.isdst then timestamp = timestamp - 3600 end
    return timestamp
end

function getValidVehicleModels ( )
	local validVehicles = { }
	local invalidModels = {
		['435']=true, ['449']=true, ['450']=true, ['537']=true,
		['538']=true, ['569']=true, ['570']=true, ['584']=true,
		['590']=true, ['591']=true, ['606']=true, ['607']=true, 
		['608']=true
	}
	for i=400, 609 do
		if ( not invalidModels[tostring(i)] ) then
			table.insert ( validVehicles, i )
		end
	end
	return validVehicles
end

local vehSpawn = {}

_createVehicle = createVehicle
_setVehicleRespawnPosition = setVehicleRespawnPosition

function createVehicle(id, x, y, z, rx, ry, rz, ...)
	local veh = _createVehicle(id, x, y, z, rx, ry, rz, ...)
	if(veh) then
		vehSpawn[veh] = {x, y, z, rx, ry, rz}
		return veh
	else
		return false
	end
end

function setVehicleRespawnPosition(theVehicle, ...)
	assert(vehSpawn[theVehicle], "Bad Argument @ setVehicleRespawnPosition (Vehicle respawn position does not exists)")
	vehSpawn[theVehicle] = {...}
	return _setVehicleRespawnPosition(theVehicle, ...)
end

function getVehicleRespawnPosition(theVehicle)
	if(vehSpawn[theVehicle]) then
		return vehSpawn[theVehicle][1], vehSpawn[theVehicle][2], vehSpawn[theVehicle][3], vehSpawn[theVehicle][4], vehSpawn[theVehicle][5], vehSpawn[theVehicle][6]
	else
		return false
	end
end

function getVehiclesCountByType(vehicleType)
    assert(type(vehicleType) == "string", "expected string at argument 1, got ".. type(vehicleType))
    local getVehicleType = getVehicleType -- Localize
    local vehicleList = getElementsByType("vehicle")
    local vehicleCount = #vehicleList
    local typeCount = 0
    for index = 1, vehicleCount do
        if getVehicleType(vehicleList[index]) == vehicleType then
            typeCount = typeCount + 1
        end
    end
    return typeCount
end

function getXMLNodes(xmlfile,nodename)
   local xml = xmlLoadFile(xmlfile)
   if xml then
      local ntable={}
      local a = 0
      while xmlFindChild(xml,nodename,a) do
         table.insert(ntable,a+1)
         ntable[a+1]={}
         local attrs = xmlNodeGetAttributes ( xmlFindChild(xml,nodename,a) )
         for name,value in pairs ( attrs ) do
            table.insert(ntable[a+1],name)
            ntable[a+1][name]=value
         end
         ntable[a+1]["nodevalue"]=xmlNodeGetValue(xmlFindChild(xml,nodename,a))
         a=a+1
      end
      return ntable
   else
      return {}
   end
end

function IfElse(condition, trueReturn, falseReturn)
    if (condition) then return trueReturn
    else return falseReturn end
end

function isCursorOnElement(x,y,w,h)
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end

function isElementMoving ( theElement )
    if isElement ( theElement ) then
        local x, y, z = getElementVelocity( theElement )
        return x ~= 0 or y ~= 0 or z ~= 0
    end
    return false
end

function isElementWithinAColShape(element)
	if element or isElement(element)then
		for _,colshape in ipairs(getElementsByType("colshape"))do
			if isElementWithinColShape(element,colshape) then
				return colshape
			end
		end
	end
	outputDebugString("isElementWithinAColShape - Invalid arguments or element does not exist",1)
	return false
end

function isLeapYear(year)
    if year then year = math.floor(year)
    else year = getRealTime().year + 1900 end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

function isMouseInPosition ( x, y, width, height )
    if ( not isCursorShowing ( ) ) then
        return false
    end
 
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
        return true
    else
        return false
    end
end

function isCursorOverText(posX, posY, sizeX, sizeY)
    if(isCursorShowing()) then
        local cX, cY = getCursorPosition()
        local screenWidth, screenHeight = guiGetScreenSize()
        local cX, cY = (cX*screenWidth), (cY*screenHeight)
        if(cX >= posX and cX <= posX+(sizeX - posX)) and (cY >= posY and cY <= posY+(sizeY - posY)) then
            return true
        else
            return false
        end
    else
        return false	
    end
end

function isPedDrivingVehicle(ped)
    assert(isElement(ped) and (getElementType(ped) == "ped" or getElementType(ped) == "player"), "Bad argument @ isPedDrivingVehicle [ped/player expected, got " .. tostring(ped) .. "]")
    local isDriving = isPedInVehicle(ped) and getVehicleOccupant(getPedOccupiedVehicle(ped)) == ped
    return isDriving, isDriving and getPedOccupiedVehicle(ped) or nil
end

function isPlayerInACL ( player, acl )
	local account = getPlayerAccount ( player )
	if ( isGuestAccount ( account ) ) then
		return false
	end
        return isObjectInACLGroup ( "user."..getAccountName ( account ), aclGetGroup ( acl ) )
end

function isPlayerInTeam(player, team)
    assert(isElement(player) and getElementType(player) == "player", "Bad argument 1 @ isPlayerInTeam [player expected, got " .. tostring(player) .. "]")
    assert((not team) or type(team) == "string" or (isElement(team) and getElementType(team) == "team"), "Bad argument 2 @ isPlayerInTeam [nil/string/team expected, got " .. tostring(team) .. "]")
    return getPlayerTeam(player) == (type(team) == "string" and getTeamFromName(team) or (type(team) == "userdata" and team or (getPlayerTeam(player) or true)))
end

function isValidMail( mail )
    assert( type( mail ) == "string", "Bad argument @ isValidMail [string expected, got " .. tostring( mail ) .. "]" )
    return mail:match( "[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?" ) ~= nil
end

function isVehicleEmpty( vehicle )
	if not isElement( vehicle ) or getElementType( vehicle ) ~= "vehicle" then
		return true
	end
	local passengers = getVehicleMaxPassengers( vehicle )
	if type( passengers ) == 'number' then
		for seat = 0, passengers do
			if getVehicleOccupant( vehicle, seat ) then
				return false
			end
		end
	end
	return true
end

function isVehicleOccupied(vehicle)
    assert(isElement(vehicle) and getElementType(vehicle) == "vehicle", "Bad argument @ isVehicleOccupied [expected vehicle, got " .. tostring(vehicle) .. "]")
    local _, occupant = next(getVehicleOccupants(vehicle))
    return occupant and true, occupant
end

function isVehicleOnRoof(vehicle)
        local rx,ry=getElementRotation(vehicle)
        if (rx>90 and rx<270) or (ry>90 and ry<270) then
                return true
        end
        return false
end

function iterElements( elementType )
	local i = 0;
	local tab = getElementsByType( elementType );
	return function( )
		i = i + 1;
		if tab[ i ] then
			return i, tab[ i ];
		end
	end
end

function math.hypot( legX, legY )
    return ((legX ^ 2) + (legY ^ 2)) ^ .5
end

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        local x = (maxvalue*percent)/100
        return x
    end
    return false
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function mathNumber ( num, integer, type )
    if not ( num ) or not ( integer ) then return false end
    local function formatNumber( numb )
    if not ( numb ) then return false end
        local fn = string.sub( tostring( numb ), ( #tostring( numb ) -6 ) )
        return tonumber( fn )
    end
    if not ( type ) or ( type == "+" ) then
        local fn = string.sub( tostring( num ), 1, -8 )..( formatNumber ( num ) ) + integer
        return tonumber( fn )
    else
        local fn = string.sub( tostring( num ), 1, -8 )..( formatNumber ( num ) ) - integer
        return tonumber( fn )
    end
end

function multi_check( source, ... )
	local arguments = { ... };
	for _, argument in ipairs( arguments ) do
		if argument == source then
			return true;
		end
	end
	return false;
end

armedVehicles = {[425]=true, [520]=true, [476]=true, [447]=true, [430]=true, [432]=true, [464]=true, [407]=true, [601]=true}
function vehicleWeaponFire(thePresser, key, keyState, vehicleFireType)
	local vehModel = getElementModel(getPedOccupiedVehicle(thePresser))
	if (armedVehicles[vehModel]) then
		triggerEvent("onVehicleWeaponFire", thePresser, vehicleFireType, vehModel)
	end
end
 
function bindOnJoin()
	bindKey(source, "vehicle_fire", "down", vehicleWeaponFire, "primary")
	bindKey(source, "vehicle_secondary_fire", "down", vehicleWeaponFire, "secondary")
end
addEventHandler("onPlayerJoin", root, bindOnJoin)
 
function bindOnStart()
	for index, thePlayer in pairs(getElementsByType("player")) do
		bindKey(thePlayer, "vehicle_fire", "down", vehicleWeaponFire, "primary")
		bindKey(thePlayer, "vehicle_secondary_fire", "down", vehicleWeaponFire, "secondary")
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), bindOnStart)

function rangeToTable( range )
    assert(range, type(range)=="string", "Bad argument @ rangeToTable. Expected 'string', got '"..type(range).."'")
    local numbers = split(range, ",")
    local output = {}
    for k, v in ipairs(numbers) do
        if tonumber(v) then
            table.insert(output, tonumber(v))
        else
            local st,en = tonumber(gettok(v, 1, "-")), tonumber(gettok(v, 2, "-"))
            if st and en then
                for i = st, en, (st<en and 1 or -1) do
                    table.insert(output, tonumber(i))
                end
            end
        end
    end
    return output
end

function refreshResource ()
local newBytes = 0
local meta = xmlLoadFile(":"..getResourceName(getThisResource()).."/meta.xml")
	if meta then
		for k,v in ipairs(xmlNodeGetChildren(meta)) do
			if fileExists(xmlNodeGetAttribute(v, "src")) then
			local file = fileOpen(xmlNodeGetAttribute(v, "src"))
			local _ = fileGetSize(file)
			newBytes = newBytes + _
			fileClose(file)
			end
		end
		if newBytes ~= Bytes then
		print(getResourceName(getThisResource()).." has changed.. reloading...")
		restartResource(getThisResource())
		else
		return false
		end
	end
end

function removeHex (text)
    return type(text)=="string" and string.gsub(text, "#%x%x%x%x%x%x", "") or text
end

function renameAclGroup( old, new )
	if ( type( old ) ~= "string" ) then
		outputDebugString( "Bad argument 1 @ renameAclGroup [ string expected, got " .. type( old ) .. " ] ", 2 )
		return false
	end
	if ( type( new ) ~= "string" ) then
		outputDebugString( "Bad argument 2 @ renameAclGroup [ string expected, got " .. type( new ) .. " ] ", 2 )
		return false
	end
	local oldACLGroup = aclGetGroup( old )
	if ( not oldACLGroup ) then
		outputDebugString( "Bad argument 1 @ renameAclGroup [ no acl group found with this name ] ", 2 )
		return false
	end
	if ( aclGetGroup( new ) ) then
		outputDebugString( "Bad argument 2 @ renameAclGroup [ there is already a group with this name ] ", 2 )
		return false
	end
	local oldACL = aclGroupListACL( oldACLGroup )
	local oldObjects = aclGroupListObjects( oldACLGroup )
	local newACLGroup = aclCreateGroup( new )
	for _,nameOfACL in pairs( oldACL ) do
		aclGroupAddACL( newACLGroup, nameOfACL )
	end
	for _,nameOfObject in pairs( oldObjects ) do
		aclGroupAddObject( newACLGroup, nameOfObject )
	end
	aclDestroyGroup( oldACLGroup )
	aclSave( )
	aclReload( )
	return true
end

function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end

function secondsToTimeDesc( seconds )
	if seconds then
		local results = {}
		local sec = ( seconds %60 )
		local min = math.floor ( ( seconds % 3600 ) /60 )
		local hou = math.floor ( ( seconds % 86400 ) /3600 )
		local day = math.floor ( seconds /86400 )
		if day > 0 then table.insert( results, day .. ( day == 1 and " day" or " days" ) ) end
		if hou > 0 then table.insert( results, hou .. ( hou == 1 and " hour" or " hours" ) ) end
		if min > 0 then table.insert( results, min .. ( min == 1 and " minute" or " minutes" ) ) end
		if sec > 0 then table.insert( results, sec .. ( sec == 1 and " second" or " seconds" ) ) end
		return string.reverse ( table.concat ( results, ", " ):reverse():gsub(" ,", " dna ", 1 ) )
	end
	return ""
end

function setAccountName( plr, old, new )
	if old and new then
		local oldAccount, newAccount, newPass = getAccount ( old ), getAccount ( new ), "mta"..math.random(10000,100000)
		if oldAccount and not newAccount then
			if addAccount ( new, newPass ) then
				local newAccount = getAccount ( new )
				local player = getAccountPlayer ( oldAccount )
				for index, value in pairs ( getAllAccountData ( oldAccount ) ) do
					setAccountData ( newAccount, index, value )
				end
				for index, value in ipairs ( aclGroupList ( ) ) do
					if isObjectInACLGroup ( "user."..old, value ) then
						aclGroupAddObject ( value, "user."..new )
						aclGroupRemoveObject ( value, "user."..old )
					end
				end
				if player then
					logOut ( player )
					logIn ( player, newAccount, newPass )				
					if plr == player then
						outputChatBox ( "* Your new account and password: [ "..new.." ] [ "..newPass.." ].", player, 255, 255, 0, true )
					else
						outputChatBox ( "* Your new account and password: [ "..new.." ] [ "..newPass.." ].", player, 255, 255, 0, true )
						outputChatBox ( "* New account and password: [ "..new.." ] [ "..newPass.." ].", plr, 255, 255, 0, true )
					end
				else
					outputChatBox ( "* New account and password: [ "..new.." ] [ "..newPass.." ].", plr, 255, 255, 0, true )
				end
				setTimer ( removeAccount, 100, 1, oldAccount )
				return true
			end
		end
	end
	return false
end

function setElementSpeed(element, unit, speed)
	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element, unit)
	if (acSpeed~=false) then
		local diff = speed/acSpeed
		if diff ~= diff then return end
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	end
	return false
end

function setTableProtected (tbl)
  return setmetatable ({}, 
    {
    __index = tbl,
    __newindex = function (t, n, v)
       error ("attempting to change constant " .. 
             tostring (n) .. " to " .. tostring (v), 2)
      end
    })
end

function string.count (text, search)
	if ( not text or not search ) then return false end
	return select ( 2, text:gsub ( search, "" ) );
end

function string.explode(self, separator)
    Check("string.explode", "string", self, "ensemble", "string", separator, "separator")
    if (#self == 0) then return {} end
    if (#separator == 0) then return { self } end
    return loadstring("return {\""..self:gsub(separator, "\",\"").."\"}")()
end

function switch(arg)
        if(type(arg)~="table")then return switch end
        local switching, default, done; --Default is nil
        if(tostring(arg[1]):len()<=2)and(tostring(arg[2]):len()<=2)then switching=arg[1] end
        table.remove(arg, 1);
        for i=1, #arg do
                if(tostring(arg[i]):len()<=3)and(arg[i]==switching)then
                        if(type(arg[i+1])=="function")then
                                pcall(arg[i+1])
                                done=true;
                                break
                        else
                                break
                        end
                end
                if(arg[i]==nil)and(arg[i]==switching)and(type(arg[i+1])=="function")then pcall(arg[i+1]) end
        end
        if(not done)then print("No action.") end
end

function table.compare( a1, a2 )
	if 
		type( a1 ) == 'table' and
		type( a2 ) == 'table'
	then
		local function size( t )
			if type( t ) ~= 'table' then
				return false 
			end
			local n = 0
			for _ in pairs( t ) do
				n = n + 1
			end
			return n
		end
		if size( a1 ) == 0 and size( a2 ) == 0 then
			return true
		elseif size( a1 ) ~= size( a2 ) then
			return false
		end
		for _, v in pairs( a1 ) do
			local v2 = a2[ _ ]
			if type( v ) == type( v2 ) then
				if type( v ) == 'table' and type( v2 ) == 'table' then
					if size( v ) ~= size( v2 ) then
						return false
					end
					if size( v ) > 0 and size( v2 ) > 0 then
						if not table.compare( v, v2 ) then 
							return false 
						end
					end	
				elseif 
					type( v ) == 'string' or type( v ) == 'number' and
					type( v2 ) == 'string' or type( v2 ) == 'number'
				then
					if v ~= v2 then
						return false
					end
				else
					return false
				end
			else
				return false
			end
		end
		return true
	end
	return false
end

function table.copy(tab, recursive)
    local ret = {}
    for key, value in pairs(tab) do
        if (type(value) == "table") and recursive then ret[key] = table.copy(value)
        else ret[key] = value end
    end
    return ret
end

function table.empty( a )
    if type( a ) ~= "table" then
        return false
    end
    return not next( a )
end

function table.map(tab, depth, func, ...)
    for key, value in pairs(tab) do
        if (type(value) == "table" and depth ~= 0) then tab[key] = table.map(value, depth - 1, func, ...)
        else tab[key] = func(value, ...) end
    end
    return tab
end

function table.merge(table1,...)
    for _,table2 in ipairs({...}) do
        for key,value in pairs(table2) do
            if (type(key) == "number") then
                table.insert(table1,value)
            else
                table1[key] = value
            end
        end
    end
    return table1
end

function table.random ( theTable )
    return theTable[math.random ( #theTable )]
end

function table.removeValue(table, val)
    for index, value in ipairs(table) do
        if value == val then
            table.remove(table, index)
            return index
        end
    end
    return false
end

function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end

function var_dump(...)
	local verbose = false
	local firstLevel = true
	local outputDirectly = true
	local noNames = false
	local indentation = "\t\t\t\t\t\t"
	local depth = nil
	local name = nil
	local output = {}
	for k,v in ipairs(arg) do
		if type(v) == "string" and k < #arg and v:sub(1,1) == "-" then
			local modifiers = v:sub(2)
			if modifiers:find("v") ~= nil then
				verbose = true
			end
			if modifiers:find("s") ~= nil then
				outputDirectly = false
			end
			if modifiers:find("n") ~= nil then
				verbose = false
			end
			if modifiers:find("u") ~= nil then
				noNames = true
			end
			local s,e = modifiers:find("d%d+")
			if s ~= nil then
				depth = tonumber(string.sub(modifiers,s+1,e))
			end
		elseif type(v) == "string" and k < #arg and name == nil and not noNames then
			name = v
		else
			if name ~= nil then
				name = ""..name..": "
			else
				name = ""
			end
			local o = ""
			if type(v) == "string" then
				table.insert(output,name..type(v).."("..v:len()..") \""..v.."\"")
			elseif type(v) == "userdata" then
				local elementType = "no valid MTA element"
				if isElement(v) then
					elementType = getElementType(v)
				end
				table.insert(output,name..type(v).."("..elementType..") \""..tostring(v).."\"")
			elseif type(v) == "table" then
				local count = 0
				for key,value in pairs(v) do
					count = count + 1
				end
				table.insert(output,name..type(v).."("..count..") \""..tostring(v).."\"")
				if verbose and count > 0 and (depth == nil or depth > 0) then
					table.insert(output,"\t{")
					for key,value in pairs(v) do
						local newModifiers = "-s"
						if depth == nil then
							newModifiers = "-sv"
						elseif  depth > 1 then
							local newDepth = depth - 1
							newModifiers = "-svd"..newDepth
						end
						local keyString, keyTable = var_dump(newModifiers,key)
						local valueString, valueTable = var_dump(newModifiers,value)
						if #keyTable == 1 and #valueTable == 1 then
							table.insert(output,indentation.."["..keyString.."]\t=>\t"..valueString)
						elseif #keyTable == 1 then
							table.insert(output,indentation.."["..keyString.."]\t=>")
							for k,v in ipairs(valueTable) do
								table.insert(output,indentation..v)
							end
						elseif #valueTable == 1 then
							for k,v in ipairs(keyTable) do
								if k == 1 then
									table.insert(output,indentation.."["..v)
								elseif k == #keyTable then
									table.insert(output,indentation..v.."]")
								else
									table.insert(output,indentation..v)
								end
							end
							table.insert(output,indentation.."\t=>\t"..valueString)
						else
							for k,v in ipairs(keyTable) do
								if k == 1 then
									table.insert(output,indentation.."["..v)
								elseif k == #keyTable then
									table.insert(output,indentation..v.."]")
								else
									table.insert(output,indentation..v)
								end
							end
							for k,v in ipairs(valueTable) do
								if k == 1 then
									table.insert(output,indentation.." => "..v)
								else
									table.insert(output,indentation..v)
								end
							end
						end
					end
					table.insert(output,"\t}")
				end
			else
				table.insert(output,name..type(v).." \""..tostring(v).."\"")
			end
			name = nil
		end
	end
	local string = ""
	for k,v in ipairs(output) do
		if outputDirectly then
			outputConsole(v)
		end
		string = string..v
	end
	return string, output
end

function wavelengthToRGBA (length)
	local r, g, b, factor
	if (length >= 380 and length < 440) then
		r, g, b = -(length - 440)/(440 - 380), 0, 1
	elseif (length < 489) then
		r, g, b = 0, (length - 440)/(490 - 440), 1
	elseif (length < 510) then
		r, g, b = 0, 1, -(length - 510)/(510 - 490)
	elseif (length < 580) then
		r, g, b = (length - 510)/(580 - 510), 1, 0
	elseif (length < 645) then
		r, g, b = 1, -(length - 645)/(645 - 580), 0
	elseif (length < 780) then
		r, g, b = 1, 0, 0
	else
		r, g, b = 0, 0, 0
	end
	if (length >= 380 and length < 420) then
		factor = 0.3 + 0.7*(length - 380)/(420 - 380)
	elseif (length < 701) then
		factor = 1
	elseif (length < 780) then
		factor = 0.3 + 0.7*(780 - length)/(780 - 700)
	else
		factor = 0
	end
	return r*255, g*255, b*255, factor*255
end