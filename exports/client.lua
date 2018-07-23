local controls = { "fire", "next_weapon", "previous_weapon", "forwards", "backwards", "left", "right", "zoom_in", "zoom_out",
 "change_camera", "jump", "sprint", "look_behind", "crouch", "action", "walk", "aim_weapon", "conversation_yes", "conversation_no",
 "group_control_forwards", "group_control_back", "enter_exit", "vehicle_fire", "vehicle_secondary_fire", "vehicle_left", "vehicle_right",
 "steer_forward", "steer_back", "accelerate", "brake_reverse", "radio_next", "radio_previous", "radio_user_track_skip", "horn", "sub_mission",
 "handbrake", "vehicle_look_left", "vehicle_look_right", "vehicle_look_behind", "vehicle_mouse_look", "special_control_left", "special_control_right",
 "special_control_down", "special_control_up" }
 
local boundControlsKeys = {}
local bindsData = {}
 
function unbindControlKeys(control)
    assert(type(control) == "string", "Bad argument @ unbindControlKeys [string expected, got " .. type(control) .. "]")
    local validControl
    for _, controlComp in ipairs(controls) do
        if control == controlComp then
            validControl = true
            break
        end
    end
    assert(validControl, "Bad argument @ unbindControlKeys [Invalid control name]")
    assert(boundControlsKeys[control], "Bad argument @ unbindControlKeys [There is no bind on such control]")
    for _, bindData in pairs(bindsData[control]) do
        unbindKey(unpack(bindData))
    end
    boundControlsKeys[control] = nil
    bindsData[control] = nil
    return true
end
 
function bindControlKeys(control, ...)
    assert(type(control) == "string", "Bad argument 1 @ bindControlKeys [string expected, got " .. type(control) .. "]")
    local validControl
    for _, controlComp in ipairs(controls) do
        if control == controlComp then
            validControl = true
            break
        end
    end
    assert(validControl, "Bad argument 1 @ bindControlKeys [Invalid control name]")
    if boundControlsKeys[control] then
        unbindControlKeys(control)
    end
    boundControlsKeys[control] = getBoundKeys(control)
    bindsData[control] = {}
    for key in pairs(boundControlsKeys[control]) do
        assert(bindKey(key, unpack(arg)), "Bad arguments @ bindControlKeys [Could not create key bind]")
        table.insert(bindsData[control], { key, unpack(arg) })
    end
    return true
end

local function keepControlKeyBindsAccurate()
    if next(boundControlsKeys) then
        for boundControl, boundKeys in pairs(boundControlsKeys) do
            if toJSON(boundKeys) ~= toJSON(getBoundKeys(boundControl)) then
                for _, bindData in ipairs(bindsData[boundControl]) do
                    unbindKey(unpack(bindData))
                    for key in pairs(getBoundKeys(boundControl)) do
                        local bindDataNoKey = bindData
                        table.remove(bindDataNoKey, 1)
                        bindKey(key, unpack(bindDataNoKey))
                        bindData[1] = key
                    end
                end
                boundControlsKeys[boundControl] = getBoundKeys(boundControl)
            end
        end
    end
end
addEventHandler("onClientRender", root, keepControlKeyBindsAccurate)

function callClientFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end
addEvent("onServerCallsClientFunction", true)
addEventHandler("onServerCallsClientFunction", resourceRoot, callClientFunction)

function callServerFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    triggerServerEvent("onClientCallsServerFunction", resourceRoot , funcname, unpack(arg))
end

function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    return guiSetPosition(center_window, x, y, false)
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

addEvent("playTTS", true)
local function playTTS(text, lang)
    local URL = "http://translate.google.com/translate_tts?tl=" .. lang .. "&q=" .. text
    return true, playSound(URL), URL
end
addEventHandler("playTTS", root, playTTS)

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

function dxDrawAnimWindow(text,height,width,color,font,anim)
    local x,y = guiGetScreenSize()
    btwidth = width
    btheight = height/20
    local now = getTickCount()
    local elapsedTime = now - start
    local endTime = start + 1500
    local duration = endTime - start
    local progress = elapsedTime / duration
    local x1, y1, z1 = interpolateBetween ( 0, 0, 0, width, height, 255, progress, anim)
    local x2, y2, z2 = interpolateBetween ( 0, 0, 0, btwidth, btheight, btheight/11, progress, anim)
    posx = (x/2)-(x1/2)
    posy = (y/2)-(y1/2)
    dxDrawRectangle ( posx, posy-y2, x2, y2, color )
    dxDrawRectangle ( posx, posy, x1, y1, tocolor ( 0, 0, 0, 200 ) )
    dxDrawText ( text, 0, -(y1)-y2, x, y, tocolor ( 255, 255, 255, 255 ), z2,font,"center","center")   
end

function dxDrawCircle( posX, posY, radius, width, angleAmount, startAngle, stopAngle, color, postGUI )
	if ( type( posX ) ~= "number" ) or ( type( posY ) ~= "number" ) then
		return false
	end
	local function clamp( val, lower, upper )
		if ( lower > upper ) then lower, upper = upper, lower end
		return math.max( lower, math.min( upper, val ) )
	end
	radius = type( radius ) == "number" and radius or 50
	width = type( width ) == "number" and width or 5
	angleAmount = type( angleAmount ) == "number" and angleAmount or 1
	startAngle = clamp( type( startAngle ) == "number" and startAngle or 0, 0, 360 )
	stopAngle = clamp( type( stopAngle ) == "number" and stopAngle or 360, 0, 360 )
	color = color or tocolor( 255, 255, 255, 200 )
	postGUI = type( postGUI ) == "boolean" and postGUI or false
	if ( stopAngle < startAngle ) then
		local tempAngle = stopAngle
		stopAngle = startAngle
		startAngle = tempAngle
	end
	for i = startAngle, stopAngle, angleAmount do
		local startX = math.cos( math.rad( i ) ) * ( radius - width )
		local startY = math.sin( math.rad( i ) ) * ( radius - width )
		local endX = math.cos( math.rad( i ) ) * ( radius + width )
		local endY = math.sin( math.rad( i ) ) * ( radius + width )
 
		dxDrawLine( startX + posX, startY + posY, endX + posX, endY + posY, color, width, postGUI )
	end
	return true
end

function dxDrawEmptyRectangle(startX, startY, endX, endY, color, width, postGUI)
	dxDrawLine ( startX, startY, startX+endX, startY, color, width, postGUI )
	dxDrawLine ( startX, startY, startX, startY+endY, color, width, postGUI )
	dxDrawLine ( startX, startY+endY, startX+endX, startY+endY,  color, width, postGUI )
	dxDrawLine ( startX+endX, startY, startX+endX, startY+endY, color, width, postGUI )
end

function dxDrawGifImage ( x, y, w, h, path, iStart, iType, effectSpeed )
	local gifElement = createElement ( "dx-gif" )
	if ( gifElement ) then
		setElementData (
			gifElement,
			"gifData",
			{
				x = x,
				y = y,
				w = w,
				h = h,
				imgPath = path,
				startID = iStart,
				imgID = iStart,
				imgType = iType,
				speed = effectSpeed,
				tick = getTickCount ( )
			},
			false
		)
		return gifElement
	else
		return false
	end
end
 
addEventHandler ( "onClientRender", root,
	function ( )
		local currentTick = getTickCount ( )
		for index, gif in ipairs ( getElementsByType ( "dx-gif" ) ) do
			local gifData = getElementData ( gif, "gifData" )
			if ( gifData ) then
				if ( currentTick - gifData.tick >= gifData.speed ) then
					gifData.tick = currentTick
					gifData.imgID = ( gifData.imgID + 1 )
					if ( fileExists ( gifData.imgPath .."".. gifData.imgID ..".".. gifData.imgType ) ) then
						gifData.imgID = gifData.imgID
						setElementData ( gif, "gifData", gifData, false )
					else
						gifData.imgID = gifData.startID
						setElementData ( gif, "gifData", gifData, false )
					end
				end
				dxDrawImage ( gifData.x, gifData.y, gifData.w, gifData.h, gifData.imgPath .."".. gifData.imgID ..".".. gifData.imgType )
			end
		end
	end
)

local white = tocolor(255,255,255,255)
function dxDrawImage3D(x,y,z,w,h,m,c,r,...)
        local lx, ly, lz = x+w, y+h, (z+tonumber(r or 0)) or z
	return dxDrawMaterialLine3D(x,y,z, lx, ly, lz, m, h, c or white, ...)
end

function dxDrawImageOnElement(TheElement,Image,distance,height,width,R,G,B,alpha)
				local x, y, z = getElementPosition(TheElement)
				local x2, y2, z2 = getElementPosition(localPlayer)
				local distance = distance or 20
				local height = height or 1
				local width = width or 1
                                local checkBuildings = checkBuildings or true
                                local checkVehicles = checkVehicles or false
                                local checkPeds = checkPeds or false
                                local checkObjects = checkObjects or true
                                local checkDummies = checkDummies or true
                                local seeThroughStuff = seeThroughStuff or false
                                local ignoreSomeObjectsForCamera = ignoreSomeObjectsForCamera or false
                                local ignoredElement = ignoredElement or nil
				if (isLineOfSightClear(x, y, z, x2, y2, z2, checkBuildings, checkVehicles, checkPeds , checkObjects,checkDummies,seeThroughStuff,ignoreSomeObjectsForCamera,ignoredElement)) then
					local sx, sy = getScreenFromWorldPosition(x, y, z+height)
					if(sx) and (sy) then
						local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
						if(distanceBetweenPoints < distance) then
							dxDrawMaterialLine3D(x, y, z+1+height-(distanceBetweenPoints/distance), x, y, z+height, Image, width-(distanceBetweenPoints/distance), tocolor(R or 255, G or 255, B or 255, alpha or 255))
						end
					end
			end
	end
	
local start = getTickCount()
function dxDrawLoading (x, y, width, height, x2, y2, size, color, color2, second)
    local now = getTickCount()
    local seconds = second or 5000
	local color = color or tocolor(0,0,0,170)
	local color2 = color2 or tocolor(255,255,0,170)
	local size = size or 1.00
    local with = interpolateBetween(0,0,0,width,0,0, (now - start) / ((start + seconds) - start), "Linear")
    local text = interpolateBetween(0,0,0,100,0,0,(now - start) / ((start + seconds) - start),"Linear")
    dxDrawText ( "Loading ... "..math.floor(text).."%", x2, y2 , width, height, tocolor ( 0, 255, 0, 255 ), size, "pricedown" )
    dxDrawRectangle(x, y ,width ,height -10, color)
    dxDrawRectangle(x, y, with ,height -10, color2)
 end
 
local dot = dxCreateTexture(1,1)
local white = tocolor(255,255,255,255)
function dxDrawRectangle3D(x,y,z,w,h,c,r,...)
        local lx, ly, lz = x+w, y+h, (z+tonumber(r or 0)) or z
	return dxDrawMaterialLine3D(x,y,z, lx, ly, lz, dot, h, c or white, ...)
end

function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,checkBuildings,checkVehicles,checkPeds,checkDummies,seeThroughStuff,ignoreSomeObjectsForCamera,ignoredElement)
				local x, y, z = getElementPosition(TheElement)
				local x2, y2, z2 = getElementPosition(localPlayer)
				local distance = distance or 20
				local height = height or 1
                                local checkBuildings = checkBuildings or true
                                local checkVehicles = checkVehicles or false
                                local checkPeds = checkPeds or false
                                local checkObjects = checkObjects or true
                                local checkDummies = checkDummies or true
                                local seeThroughStuff = seeThroughStuff or false
                                local ignoreSomeObjectsForCamera = ignoreSomeObjectsForCamera or false
                                local ignoredElement = ignoredElement or nil
				if (isLineOfSightClear(x, y, z, x2, y2, z2, checkBuildings, checkVehicles, checkPeds , checkObjects,checkDummies,seeThroughStuff,ignoreSomeObjectsForCamera,ignoredElement)) then
					local sx, sy = getScreenFromWorldPosition(x, y, z+height)
					if(sx) and (sy) then
						local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
						if(distanceBetweenPoints < distance) then
							dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
			end
		end
	end
end

function dxGetFontSizeFromHeight( height, font )
    if type( height ) ~= "number" then return false end
    font = font or "default"
    local ch = dxGetFontHeight( 1, font )
    return height/ch
end

function dxGetRealFontHeight(font)
    local cap,base = measureGlyph(font, "S")
    local median,decend = measureGlyph(font, "p")
    local ascend,base2 = measureGlyph(font, "h")
    local ascenderSize = median - ascend
    local capsSize = median - cap
    local xHeight = base - median
    local decenderSize = decend - base
    return math.max(capsSize,ascenderSize) + xHeight + decenderSize
end
 
function measureGlyph(font, character)
    local rt = dxCreateRenderTarget(128,128)
    dxSetRenderTarget(rt,true)
    dxDrawText(character,0,0,0,0,tocolor(255,255,255),1,font)
    dxSetRenderTarget()
    local pixels = dxGetTexturePixels(rt)
    local first,last = 127,0
    for y=0,127 do
        for x=0,127 do
            local r = dxGetPixelColor( pixels,x,y )
            if r > 0 then
                first = math.min( first, y )
                last = math.max( last, y )
                break
            end
        end
        if last > 0 and y > last+2 then break end
    end
    destroyElement(rt)
    return first,last
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

function getAlivePlayers()
  local alivePlayers = { }
  for i,p in ipairs (getElementsByType("player")) do
    if getElementHealth(p) > 0 then
      table.insert(alivePlayers,p)
    end 
  end
  return alivePlayers
end

local controlTable = { "fire", "next_weapon", "previous_weapon", "forwards", "backwards", "left", "right", "zoom_in", "zoom_out",
 "change_camera", "jump", "sprint", "look_behind", "crouch", "action", "walk", "aim_weapon", "conversation_yes", "conversation_no",
 "group_control_forwards", "group_control_back", "enter_exit", "vehicle_fire", "vehicle_secondary_fire", "vehicle_left", "vehicle_right",
 "steer_forward", "steer_back", "accelerate", "brake_reverse", "radio_next", "radio_previous", "radio_user_track_skip", "horn", "sub_mission",
 "handbrake", "vehicle_look_left", "vehicle_look_right", "vehicle_look_behind", "vehicle_mouse_look", "special_control_left", "special_control_right",
 "special_control_down", "special_control_up" }
 
function getBoundControls (key)
    local controls = {}
    for _,control in ipairs(controlTable) do
        for k in pairs(getBoundKeys(control)) do
            if (k == key) then
                controls[control] = true
            end
        end
    end
    return controls
end

local fps = false
function getCurrentFPS()
    return fps
end
 
local function updateFPS(msSinceLastFrame)
    fps = (1 / msSinceLastFrame) * 1000
end
addEventHandler("onClientPreRender", root, updateFPS)

function getCursorMoveOn()
    if ( isCursorShowing() ) then
	left = "left"
	right = "right"
	up = "up"
	down = "down"
    zero = "nil"
	if getElementData(localPlayer,"movew") == right then
	return right
	elseif getElementData(localPlayer,"movew") == left then
	return left
	elseif getElementData(localPlayer,"movew") == up then
	return up
	elseif getElementData(localPlayer,"movew") == down then
	return down
	elseif getElementData(localPlayer,"movew") == zero then
	return false
	end
	end
end
 
function executeMoveOn(cursorX,cursorY)
    if ( isCursorShowing() ) then
	setElementData(localPlayer,"moveX",cursorX)
	setElementData(localPlayer,"moveY",cursorY)
	     if cursorX > cX then
         setElementData(localPlayer,"movew",right)
	     elseif cursorX < cX then
	     setElementData(localPlayer,"movew",left)
	     elseif cursorY > cY then
	     setElementData(localPlayer,"movew",down)
	     elseif cursorY < cY then
	     setElementData(localPlayer,"movew",up)
	     end
    end
end
addEventHandler("onClientCursorMove",root,executeMoveOn)
 
setTimer(
function()
    if ( isCursorShowing() ) then
	local curX = getElementData(localPlayer,"moveX")
	local curY = getElementData(localPlayer,"moveY")
		 if cursorX == cX then
		 setElementData(localPlayer,"movew",zero)
		 elseif cursorY == cY then
		 setElementData(localPlayer,"movew",zero)
		 end
	end
end
,50,0)
 
function previousM()
   if ( isCursorShowing() ) then
    cX = getElementData(localPlayer,"moveX")
	cY = getElementData(localPlayer,"moveY")
   end
end
setTimer(previousM,50,0)

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

function getGridListRowIndexFromText(gridList, text, column)
  for i=0, guiGridListGetRowCount(gridList)-1 do
    if (guiGridListGetItemText(gridList, i, column) == text) then
      return i
	end
     end
   return false
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

function getPlayersInPhotograph()
	local players = {}
	local nx, ny, nz = getPedWeaponMuzzlePosition(localPlayer)
	for _, v in ipairs(getElementsByType"player") do
		if (v ~= localPlayer) and (isElementOnScreen(v)) then
			local veh = getPedOccupiedVehicle(v)
			local px, py, pz = getElementPosition(v)
			local _, _, _, _, hit = processLineOfSight(nx, ny, nz, px, py, pz)
			local continue = false
			if (hit == v) or (hit == veh) or (not veh) then
				continue = true
			else
				local bx, by, bz = getPedBonePosition(v, 8)
				local _, _, _, _, hit = processLineOfSight(nx, ny, nz, px, py, pz)
 
				if hit == v then
					continue = true
				end
			end
			if continue then
				table.insert(players, v)
			end
		end
	end
	return players
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
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

function getScreenRotationFromWorldPosition( targetX, targetY, targetZ )
    local camX, camY, _, lookAtX, lookAtY = getCameraMatrix()
    local camRotZ = math.atan2 ( ( lookAtX - camX ), ( lookAtY - camY ) )
    local dirX = targetX - camX
    local dirY = targetY - camY
    local dirRotZ = math.atan2(dirX,dirY)
    local relRotZ = dirRotZ - camRotZ
    return math.deg(relRotZ)
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
    timestamp = timestamp - 3600
    if datetime.isdst then timestamp = timestamp - 3600 end
    return timestamp
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
    local getVehicleType = getVehicleType
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

function guiComboBoxAdjustHeight ( combobox, itemcount )
    if getElementType ( combobox ) ~= "gui-combobox" or type ( itemcount ) ~= "number" then error ( "Invalid arguments @ 'guiComboBoxAdjustHeight'", 2 ) end
    local width = guiGetSize ( combobox, false )
    return guiSetSize ( combobox, width, ( itemcount * 20 ) + 20, false )
end

function guiGridListAddPlayers( GridList, Column, Section, Number )
	if( getElementType( GridList ) == "gui-gridlist" ) then
	assert( tonumber( Column ), "Bad argument @ 'guiGridListAddPlayers' [Expected number at argument 2, got " .. tostring(Column) .. "]" )
		if( Section == false or Section == true ) then
			if( Number == false or Number == true ) then
				for _, player in ipairs( getElementsByType('player') ) do
					guiGridListClear( GridList )
						local Row = guiGridListAddRow( GridList )
						guiGridListSetItemText( GridList, Row, Column, getPlayerName(player), Section, Number )
						end 
					else
					error("Bad argument @ 'guiGridListAddPlayers' [Expected boolean at argument 4, got " .. tostring(Number) .. "]")
				end
			else
			error("Bad argument @ 'guiGridListAddPlayers' [Expected boolean at argument 3, got " .. tostring(Section) .. "]")
		end
	end
end

function guiGridListGetSelectedText(gridList, columnIndex)
    local selectedItem = guiGridListGetSelectedItem(gridList)
    if (selectedItem) then
        local text = guiGridListGetItemText(gridList, selectedItem, columnIndex or 1)
        if (text) and not (text == "") then
            return text
        end
    end
    return false
end

function IfElse(condition, trueReturn, falseReturn)
    if (condition) then return trueReturn
    else return falseReturn end
end

function isElementInPhotograph(ele)
	local nx, ny, nz = getPedWeaponMuzzlePosition(localPlayer)
	if (ele ~= localPlayer) and (isElementOnScreen(ele)) then
		local px, py, pz = getElementPosition(ele)
		local _, _, _, _, hit = processLineOfSight(nx, ny, nz, px, py, pz)
		if (hit == ele) then
			return true
		end
	end
	return false
end

function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end

function isElementWithinAColShape(element)
	element = element or localPlayer or getLocalPlayer()
	if element or isElement(element)then
		for _,colshape in ipairs(getElementsByType("colshape"))do
			if isElementWithinColShape(element,colshape) then
				return colshape
			end
		end
	end
	outputDebugString("isElementWithinAColShape - Element does not exist",1)
	return false
end

function isLeapYear(year)
    if year then year = math.floor(year)
    else year = getRealTime().year + 1900 end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

function isPedAiming ( thePedToCheck )
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
				return true
			end
		end
	end
	return false
end

function isPedAimingNearPed ( thePed, theElement, range )
	if isElement(thePed) and isElement(theElement) and type(range) == "number" then
		if (getElementType(thePed) == "player" or getElementType(thePed) == "ped") then
			local x, y, z = getElementPosition(theElement)
			local col = createColTube(x, y, z-1, range, 2)
			attachElements(col, theElement)
			if getPedTask(thePed, "secondary", 0) == "TASK_SIMPLE_USE_GUN" and getPedTarget(thePed) == theElement and isElementWithinColShape(thePed, col) then
				return true
			end
		end
	end
	return false
end

function isPedDrivingVehicle(ped)
    assert(isElement(ped) and (getElementType(ped) == "ped" or getElementType(ped) == "player"), "Bad argument @ isPedDrivingVehicle [ped/player expected, got " .. tostring(ped) .. "]")
    local isDriving = isPedInVehicle(ped) and getVehicleOccupant(getPedOccupiedVehicle(ped)) == ped
    return isDriving, isDriving and getPedOccupiedVehicle(ped) or nil
end

function isPlayerInTeam(player, team)
    assert(isElement(player) and getElementType(player) == "player", "Bad argument 1 @ isPlayerInTeam [player expected, got " .. tostring(player) .. "]")
    assert((not team) or type(team) == "string" or (isElement(team) and getElementType(team) == "team"), "Bad argument 2 @ isPlayerInTeam [nil/string/team expected, got " .. tostring(team) .. "]")
    return getPlayerTeam(player) == (type(team) == "string" and getTeamFromName(team) or (type(team) == "userdata" and team or (getPlayerTeam(player) or true)))
end

function isSoundFinished(theSound)
    return ( getSoundPosition(theSound) == getSoundLength(theSound) )
end

function isTextInGridList(gridList, text)
      for i=0, guiGridListGetRowCount(gridlist)-1 do
	local t = guiGridListGetItemText(gridlist, i, 1)
	  if (t) then
	    if (t == text) then
	      return true
		end
	    end
	end
    return false
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

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
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
function vehicleWeaponFire(key, keyState, vehicleFireType)
	local vehModel = getElementModel(getPedOccupiedVehicle(localPlayer))
	if (armedVehicles[vehModel]) then
		triggerEvent("onClientVehicleWeaponFire", localPlayer, vehicleFireType, vehModel)
	end
end
bindKey("vehicle_fire", "down", vehicleWeaponFire, "primary")
bindKey("vehicle_secondary_fire", "down", vehicleWeaponFire, "secondary")

function removeHex (text)
    return type(text)=="string" and string.gsub(text, "#%x%x%x%x%x%x", "") or text
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

function setVehicleGravityPoint( targetVehicle, pointX, pointY, pointZ, strength )
	if isElement( targetVehicle ) and getElementType( targetVehicle ) == "vehicle" then
		local vehicleX,vehicleY,vehicleZ = getElementPosition( targetVehicle )
		local vectorX = vehicleX-pointX
		local vectorY = vehicleY-pointY
		local vectorZ = vehicleZ-pointZ
		local length = ( vectorX^2 + vectorY^2 + vectorZ^2 )^0.5
		local propX = vectorX^2 / length^2
		local propY = vectorY^2 / length^2
		local propZ = vectorZ^2 / length^2
		local finalX = ( strength^2 * propX )^0.5
		local finalY = ( strength^2 * propY )^0.5
		local finalZ = ( strength^2 * propZ )^0.5
		if vectorX > 0 then finalX = finalX * -1 end
		if vectorY > 0 then finalY = finalY * -1 end
		if vectorZ > 0 then finalZ = finalZ * -1 end
		return setVehicleGravity( targetVehicle, finalX, finalY, finalZ )
	end
	return false
end

local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	end
end
addEventHandler("onClientPreRender",root,camRender)
 
function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then return false end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
	setTimer(destroyElement,time,1,sm.object2)
	return true
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

function toHex ( n )
    local hexnums = {"0","1","2","3","4","5","6","7",
                     "8","9","A","B","C","D","E","F"}
    local str,r = "",n%16
    if n-r == 0 then str = hexnums[r+1]
    else str = toHex((n-r)/16)..hexnums[r+1] end
    return str
end

local controls = { "fire", "next_weapon", "previous_weapon", "forwards", "backwards", "left", "right", "zoom_in", "zoom_out",
 "change_camera", "jump", "sprint", "look_behind", "crouch", "action", "walk", "aim_weapon", "conversation_yes", "conversation_no",
 "group_control_forwards", "group_control_back", "enter_exit", "vehicle_fire", "vehicle_secondary_fire", "vehicle_left", "vehicle_right",
 "steer_forward", "steer_back", "accelerate", "brake_reverse", "radio_next", "radio_previous", "radio_user_track_skip", "horn", "sub_mission",
 "handbrake", "vehicle_look_left", "vehicle_look_right", "vehicle_look_behind", "vehicle_mouse_look", "special_control_left", "special_control_right",
 "special_control_down", "special_control_up" }
 
local boundControlsKeys = {}
local bindsData = {}
 
function unbindControlKeys(control)
    assert(type(control) == "string", "Bad argument @ unbindControlKeys [string expected, got " .. type(control) .. "]")
    local validControl
    for _, controlComp in ipairs(controls) do
        if control == controlComp then
            validControl = true
            break
        end
    end
    assert(validControl, "Bad argument @ unbindControlKeys [Invalid control name]")
    assert(boundControlsKeys[control], "Bad argument @ unbindControlKeys [There is no bind on such control]")
    for _, bindData in pairs(bindsData[control]) do
        unbindKey(unpack(bindData))
    end
    boundControlsKeys[control] = nil
    bindsData[control] = nil
    return true
end
 
function bindControlKeys(control, ...)
    assert(type(control) == "string", "Bad argument 1 @ bindControlKeys [string expected, got " .. type(control) .. "]")
    local validControl
    for _, controlComp in ipairs(controls) do
        if control == controlComp then
            validControl = true
            break
        end
    end
    assert(validControl, "Bad argument 1 @ bindControlKeys [Invalid control name]")
    if boundControlsKeys[control] then
        unbindControlKeys(control)
    end
    boundControlsKeys[control] = getBoundKeys(control)
    bindsData[control] = {}
    for key in pairs(boundControlsKeys[control]) do
        assert(bindKey(key, unpack(arg)), "Bad arguments @ bindControlKeys [Could not create key bind]")
        table.insert(bindsData[control], { key, unpack(arg) })
    end
    return true
end

local function keepControlKeyBindsAccurate()
    if next(boundControlsKeys) then
        for boundControl, boundKeys in pairs(boundControlsKeys) do
            if toJSON(boundKeys) ~= toJSON(getBoundKeys(boundControl)) then
                for _, bindData in ipairs(bindsData[boundControl]) do
                    unbindKey(unpack(bindData))
                    for key in pairs(getBoundKeys(boundControl)) do
                        local bindDataNoKey = bindData
                        table.remove(bindDataNoKey, 1)
                        bindKey(key, unpack(bindDataNoKey))
                        bindData[1] = key
                    end
                end
                boundControlsKeys[boundControl] = getBoundKeys(boundControl)
            end
        end
    end
end
addEventHandler("onClientRender", root, keepControlKeyBindsAccurate)

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