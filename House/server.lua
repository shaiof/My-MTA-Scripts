local houseFile = 'houses.json'
houses = {}
markers = {}

local interiors = {
	{1,222.8564453125,1287.427734375,1082.140625},
	{4,260.98046875,1284.5498046875,1080.2578125},
	{5,140.1865234375,1366.9140625,1083.859375},
	{9,82.9501953125,1322.4404296875,1083.859375},
	{15,-283.5498046875,1470.98046875,1084.375},
	{4,-260.599609375,1456.6201171875,1084.3671875},
	{8,-42.580078125,1405.6103515625,1084.4296875},
	{6,-68.6904296875,1351.9697265625,1080.2109375},
	{6,2333.1103515625,-1077.099609375,1049.0234375},
	{5,2233.7998046875,-1115.3603515625,1050.8828125},
	{8,2365.2998046875,-1134.919921875,1050.875},
	{11,2282.91015625,-1140.2900390625,1050.8984375},
	{6,2196.7900390625,-1204.349609375,1049.0234375},
	{10,2270.2822265625,-1210.1943359375,1047.5625},
	{6,2308.5439453125,-1212.93359375,1049.0234375},
	{1,2217.5400390625,-1076.2900390625,1050.484375},
	{2,2237.58984375,-1080.8701171875,1049.0234375},
	{9,2317.8203125,-1026.75,1050.2177734375}
}

local garages = {}

function loadHouses()
	if not fileExists(houseFile) then fileCreate(houseFile) end
	local file = fileOpen(houseFile)
	local size = fileGetSize(file)
	local buffer = fileRead(file,size)
	local houses = fromJSON(buffer)
	fileClose(file)
end
loadHouses()

function saveHouses()
	if not fileExists(houseFile) then fileCreate(houseFile) end
	local file = fileOpen(houseFile)
	fileWrite(file,toJSON(houses))
	fileClose(file)
end

function houseVisit(player,cmd,houseid)
	local id = tonumber(houseid)
	for h,j in pairs(interiors) do
		if id == h then
			local x,y,z = getElementPosition(player)
			local int = getElementInterior(player)
			local dim = getElementDimension(player)
			setElementData(player,'visiting',true)
			setElementData(player,'vox',x)
			setElementData(player,'voy',y)
			setElementData(player,'voz',z)
			setElementData(player,'vint',int)
			setElementData(player,'vdim',dim)
			setElementInterior(player,v[1])
			setElementPosition(player,v[2],v[3],v[4])
			outputChatBox('You are visiting house id: '..h..' please use /hleave before you leave!',player,0,255,255)
		end
	end
end
addCommandHandler('hvisit',houseVisit)

function exitVisit(player,cmd)
	if getElementData(player,'visiting') == true then
		local x,y,z = getElementData(player,'vox'),getElementData(player,'voy'),getElementData(player,'voz')
		local int = getElementData(player,'vint')
		local dim = getElementData(player,'vdim')
		setElementInterior(player,int)
		setElementPosition(player,x,y,z)
		setElementDimension(player,dim)
		setElementData(player,'visiting',false)
		outputChatBox('You have exited your visit.',player,0,255,255)
	end
end
addCommandHandler('hleave',exitVisit)

addEvent('createHouse',true)
addEventHandler('createHouse',root,function(x1,y1,z1,x2,y2,z2,price,id,dimension)
	local blip = createBlip(v.x1,v.y1,v.z1,31,0.8)
	setBlipVisibleDistance(blip,100)
	local marker = createMarker(v.x1,v.y1,v.z1-0.9,'cylinder',1)
	setElementData(marker,'houseid',i)
	table.insert(markers,{marker,blip})
	table.insert(houses,{x1=x1,y1=y1,z1=z1,x2=x2,y2=y2,z2=z2,price=price,hid=id,dim=dimension,owner='none',garage='none',blip=blip,marker=marker})
	saveHouses()
	loadHouses()
end)

addEventHandler('onMarkerHit',root,function(element,dimension)
	if dimension == true then
		for o,u in pairs(markers) do
			for k,l in pairs(houses) do
				if o == k then
					if getElementType(element) == 'player' then
						setElementData(element,'onHouse',true)
						setElementData(element,'ownerHouse',l.owner)
						setElementData(element,'priceHouse',l.price)
						setElementData(element,'garage',l.garage)
					end
				end
			end
		end
	end
end)

addEventHandler('onMarkerLeave',root,function(element,dimension)
	if dimension == true then
		for e,r in pairs(markers) do
			for f,g in pairs(houses) do
				if e == f then
					if getElementType(element) == 'player' then
						setElementData(element,'onHouse',false)
					end
				end
			end
		end
	end
end)

addEvent('createGarage',true)
addEventHandler('createGarage',root,function(x1,y1,z1,x2,y2,z2,houseID)
	
end)