-------- Tuneshop Script Made by Shaio Fencski ---------
--------------------------------------------------------

--[[
Objectives:
* Finished
% In Progress
! Not Started

% Replace Wheels
* Resizable Wheels
* Camber Wheels Effect
! Indivual Wheel Customization
! Rim Color
% Vehicle Upgrades
* Removable Components
! Nos effects
! Color Shaders
! Reflection Shaders
! Brightness Shaders
% User Interface
! Handling Editing OR Engine/Transmission/Traction etc upgrades.
! Handling Presets
]]

moddedWheels = {}
local wheelNames = {'wheel_lf_dummy','wheel_rf_dummy','wheel_lb_dummy','wheel_rb_dummy','wheel_lm_dummy','wheel_rm_dummy'}
wheelSizes = {}
local file = fileOpen('wheels.json')
local size = fileGetSize(file)
local buffer = fileRead(file,size)
wheelSizes = fromJSON(buffer)
fileClose(file)

sixWheels = {408,437,433,443,515,514,455,578,524}
invalidModels = {581,509,481,462,521,463,510,522,461,448,468,586,472,473,493,595,484,430,453,452,446,454,592,577,511,512,593,520,553,476,519,460,513,548,425,417,487,488,497,563,447,469,539,441,464,594,501,465,564,590,538,570,569,537,449,432,606,607,610,584,611,608,435,450,591}
function isValid(model)
	for i=1,#invalidModels do
		if invalidModels[i] == model then
			return false
		end
	end
	return true
end

function getOffsets(vehicle,object)
	if offsets and offsets[vehicle] then
		if offsets[vehicle][object] then
			return offsets[vehicle][object]
		end
	end
	return false
end

function math.clamp(min,max,value)
	return (value < min and min or (value > max and max )) or value
end

function openVehicleDoor(vehicle,door,percent)
	assert((isElement(vehicle) and isValid(vehicle) and getElementType(vehicle) == 'vehicle'),'Bad argument @doors.openClose at argument 1, expected vehicle got '..(isElement(vehicle) and getElementType(vehicle) or type(vehicle)))
	assert((type(door)=='number'),'Bad argument @doors.openClose at argument 2, expected number got '..type(door))
	if percent then percent = tonumber(percent)/100 end
	if percent then
		percent = math.clamp(0,1,percent)
	else
		percent = 0
	end
	setVehicleDoorOpenRatio(vehicle,door,percent,1000)
end

function createWheels(vehicle,model)
	assert((isElement(vehicle) and isValid(vehicle) and getElementType(vehicle) == 'vehicle'),'Bad argument @wheels.create at argument 1, expected vehicle got '..(isElement(vehicle) and getElementType(vehicle) or type(vehicle)))
	if isValid(getElementModel(vehicle)) then
		local self = {}
		self.vehicle = vehicle
		self.wheelAmount = getWheelAmount(self.vehicle)
		self.wheels = {}
		self.objTest = {}
		self.rComponents = {}
		self.attached = {}
		self.increment = 1
		self.camber = 0
		self.model = tonumber(model) or 1080
		self.objTest.ox,self.objTest.oy,self.objTest.oz,self.objTest.rx,self.objTest.ry,self.objTest.rz = 0,0,0,0,0,0
		self.objTest.obj = createObject(1001,0,0,0)
		self.objTest.bind = 'boot_dummy'
		self.wx1,self.wx2 = getDefaultWheelSize(self.vehicle)
		for i=1,self.wheelAmount do
			self.wheels[i] = createObject(self.model,0,0,0)
			if i == 1 or i == 2 then
				setObjectScale(self.wheels[i],self.wx1)
			else
				setObjectScale(self.wheels[i],self.wx2)
			end
		end
		
		addEventHandler('onElementDestroy',self.vehicle,function()
			for i,wheel in pairs(self.wheels) do
				if isElement(wheel) then
					destroyElement(wheel)
				end
			end
			for i,object in pairs(self.attached) do
				if isElement(object.object) then
					destroyElement(object.object)
				end
			end
		end)
		
		triggerClientEvent('removeWheels',root,self)
		triggerClientEvent('setParent',root,self)
		table.insert(moddedWheels,self)
		return self
	end
end

function resizeWheels(vehicle,size)
	assert((isElement(vehicle) and isValid(vehicle) and getElementType(vehicle)=='vehicle'),'Bad argument @wheels.size at argument 1, expected vehicle got '..(isElement(vehicle) and getElementType(vehicle) or type(vehicle)))
	assert((type(tonumber(size))=='number'),'Bad argumement @wheels.size at argument 2, expected number got '..type(size))
	for i,v in pairs(moddedWheels) do
		if v.vehicle == vehicle then
			v.increment = tonumber(size)
			for e=1,#v.wheels do
				setObjectScale(v.wheels[e],v.increment)
			end
		end
	end
end

function getDefaultWheelSize(vehicle)
	assert((isElement(vehicle) and isValid(vehicle) and getElementType(vehicle)=='vehicle'),'Bad argument @wheels.getDefaultSize at argument 1, expected vehicle got '..(isElement(vehicle) and getElementType(vehicle) or type(vehicle)))
	if isValid(getElementModel(vehicle)) then
		local model = getElementModel(vehicle)
		for i,v in pairs(wheelSizes) do
			if v[1] == model then
				return v[2],v[3]
			end
		end
	end
	return false
end

function getWheelAmount(vehicle)
	assert((isElement(vehicle) and isValid(vehicle) and getElementType(vehicle)=='vehicle'),'Bad argument @wheels.getWheelAmount at argument 1, expected vehicle got '..(isElement(vehicle) and getElementType(vehicle) or type(vehicle)))
	local model = getElementModel(vehicle)
	if isValid(model) then
		for i=1,#sixWheels do
			if model == sixWheels[i] then
				return 6
			end
		end
		return 4
	end
	return false
end

local validComponents = {'boot_dummy','ug_nitro','chassis','chassis_vlo','ug_roof','door_rf_dummy','door_lf_dummy','door_rb_dummy','door_lb_dummy','bonnet_dummy','ug_wing_right','bump_front_dummy','bump_rear_dummy','windscreen_dummy','ug_wing_left','exhaust_ok'}
function isValidComponent(component)
	if component then
		for i,v in pairs(validComponents) do
			if v == component then
				return true
			end
		end
	end
	return false
end

function removeComponent(vehicle,component)
	assert((isElement(vehicle) and isValid(vehicle) and getElementType(vehicle)=='vehicle'),'Bad argument @removeComponent at argument 1, expected vehicle got '..(isElement(vehicle) and getElementType(vehicle) or type(vehicle)))
	assert(isValidComponent(component),'Bad argument @removeComponent at argument 2, expected component name got '..component or type(component))
	for i,self in pairs(moddedWheels) do
		if self.vehicle == vehicle then
			table.insert(self.rComponents,component)
		end
	end
end

setTimer(function()
	for k,l in pairs(getElementsByType('vehicle')) do
		for i,v in pairs(moddedWheels) do
			if v.vehicle == l then
				setElementData(l,'wheels',v)
			end
		end
	end
end,50,0)

function setValue(player,cmd,...)
	local veh = getPedOccupiedVehicle(player)
	for i,self in pairs(moddedWheels) do
		if self.vehicle == veh then
			if cmd == 'ox' then
				self.objTest.ox = self.objTest.ox+tonumber(arg[1])
				local sx,sy,sz = getObjectScale(self.objTest.obj)
				print('X: '..self.objTest.ox..', Y: '..self.objTest.oy..', Z: '..self.objTest.oz..', RX: '..self.objTest.rx..', RY: '..self.objTest.ry..', RZ: '..self.objTest.rz..', ScaleX: '..sx..', ScaleY: '..sy..', ScaleZ: '..sz)
			elseif cmd == 'oy' then
				self.objTest.oy = self.objTest.oy+tonumber(arg[1])
				local sx,sy,sz = getObjectScale(self.objTest.obj)
				print('X: '..self.objTest.ox..', Y: '..self.objTest.oy..', Z: '..self.objTest.oz..', RX: '..self.objTest.rx..', RY: '..self.objTest.ry..', RZ: '..self.objTest.rz..', ScaleX: '..sx..', ScaleY: '..sy..', ScaleZ: '..sz)
			elseif cmd == 'oz' then
				self.objTest.oz = self.objTest.oz+tonumber(arg[1])
				local sx,sy,sz = getObjectScale(self.objTest.obj)
				print('X: '..self.objTest.ox..', Y: '..self.objTest.oy..', Z: '..self.objTest.oz..', RX: '..self.objTest.rx..', RY: '..self.objTest.ry..', RZ: '..self.objTest.rz..', ScaleX: '..sx..', ScaleY: '..sy..', ScaleZ: '..sz)
			elseif cmd == 'rx' then
				self.objTest.rx = self.objTest.rx+tonumber(arg[1])
				local sx,sy,sz = getObjectScale(self.objTest.obj)
				print('X: '..self.objTest.ox..', Y: '..self.objTest.oy..', Z: '..self.objTest.oz..', RX: '..self.objTest.rx..', RY: '..self.objTest.ry..', RZ: '..self.objTest.rz..', ScaleX: '..sx..', ScaleY: '..sy..', ScaleZ: '..sz)
			elseif cmd == 'ry' then
				self.objTest.ry = self.objTest.ry+tonumber(arg[1])
				local sx,sy,sz = getObjectScale(self.objTest.obj)
				print('X: '..self.objTest.ox..', Y: '..self.objTest.oy..', Z: '..self.objTest.oz..', RX: '..self.objTest.rx..', RY: '..self.objTest.ry..', RZ: '..self.objTest.rz..', ScaleX: '..sx..', ScaleY: '..sy..', ScaleZ: '..sz)
			elseif cmd == 'rz' then
				self.objTest.rz = self.objTest.rz+tonumber(arg[1])
				local sx,sy,sz = getObjectScale(self.objTest.obj)
				print('X: '..self.objTest.ox..', Y: '..self.objTest.oy..', Z: '..self.objTest.oz..', RX: '..self.objTest.rx..', RY: '..self.objTest.ry..', RZ: '..self.objTest.rz..', ScaleX: '..sx..', ScaleY: '..sy..', ScaleZ: '..sz)
			elseif cmd == 'show' then
				local sx,sy,sz = getObjectScale(self.objTest.obj)
				outputChatBox('ID: '..getElementModel(self.objTest.obj)..', Component: '..self.objTest.bind..', X: '..self.objTest.ox..', Y: '..self.objTest.oy..', Z: '..self.objTest.oz..', RX: '..self.objTest.rx..', RY: '..self.objTest.ry..', RZ: '..self.objTest.rz..', ScaleX: '..sx..', ScaleY: '..sy..', ScaleZ: '..sz)
			elseif cmd == 'setobj' then
				if isElement(self.objTest.obj) then
					destroyElement(self.objTest.obj)
				end
				self.objTest.obj = createObject(arg[1],0,0,0)
			elseif cmd == 'comp' then
				self.objTest.bind = arg[1]
				print(bind)
			elseif cmd == 'scale' then
				lx = arg[1] or 1
				ly = arg[2] or 1
				lz = arg[3] or 1
				setObjectScale(self.objTest.obj,lx,ly,lz)
			elseif cmd == 'setpos' then
				if arg[1] then
					self.objTest.ox = tonumber(arg[1])
				end
				if arg[2] then
					self.objTest.oy = tonumber(arg[2])
				end
				if arg[3] then
					self.objTest.oz = tonumber(arg[3])
				end
			elseif cmd == 'setrot' then
				if arg[1] then
					self.objTest.rx = tonumber(arg[1])
				end
				if arg[2] then
					self.objTest.ry = tonumber(arg[2])
				end
				if arg[3] then
					self.objTest.rz = tonumber(arg[3])
				end
			end
		end
	end
end
local cmdss = {'ox','oy','oz','rx','ry','rz','show','setobj','comp','scale','cardoor','setpos','setrot'}
for i=1,#cmdss do
	addCommandHandler(cmdss[i],setValue)
end

function runThem(player,cmd,...)
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle then
		if cmd == 'wheels' then
			createWheels(vehicle,arg[1])
		elseif cmd == 'rcomponent' then
			removeComponent(vehicle,arg[1])
		elseif cmd == 'wsize' then
			resizeWheels(vehicle,arg[1])
		elseif cmd == 'camber' then
			for i,v in pairs(moddedWheels) do
				if v.vehicle == vehicle then
					v.camber = tonumber(arg[1])
				end
			end
		end
	end
end
addCommandHandler('wheels',runThem)
addCommandHandler('rcomponent',runThem)
addCommandHandler('wsize',runThem)
addCommandHandler('camber',runThem)

addEventHandler('onResourceStop',resourceRoot,function()
	for i,v in pairs(getElementsByType('vehicle')) do
		setElementData(v,'wheels',nil)
	end
end)

local timer1 = {}
local timer2 = {}
local timer3 = {}

function startLeftBlinker(vehicle)
	setVehicleOverrideLights(vehicle,2)
	if isTimer(timer2[vehicle]) then
		killTimer(timer2[vehicle])
	end
	if isTimer(timer3[vehicle]) then
		killTimer(timer3[vehicle])
	end
	timer1[vehicle] = setTimer(function(vehicle)
		if getVehicleLightState(vehicle,0) == 0 then
			setVehicleLightState(vehicle,0,1)
			setVehicleLightState(vehicle,3,1)
			
		else
			setVehicleLightState(vehicle,0,0)
			setVehicleLightState(vehicle,3,0)
		end
	end,500,0,vehicle)
end

function startRightBlinker(vehicle)
	setVehicleOverrideLights(vehicle,2)
	if isTimer(timer1[vehicle]) then
		killTimer(timer1[vehicle])
	end
	if isTimer(timer3[vehicle]) then
		killTimer(timer3[vehicle])
	end
	timer2[vehicle] = setTimer(function(vehicle)
		if getVehicleLightState(vehicle,1) == 0 then
			setVehicleLightState(vehicle,1,1)
			setVehicleLightState(vehicle,2,1)
			
		else
			setVehicleLightState(vehicle,1,0)
			setVehicleLightState(vehicle,2,0)
		end
	end,500,0,vehicle)
end

function startHazardBlinker(vehicle)
	setVehicleOverrideLights(vehicle,2)
	if isTimer(timer1[vehicle]) then
		killTimer(timer1[vehicle])
	end
	if isTimer(timer2[vehicle]) then
		killTimer(timer2[vehicle])
	end
	timer3[vehicle] = setTimer(function(vehicle)
		if getVehicleLightState(vehicle,0) == 0 then
			setVehicleLightState(vehicle,0,1)
			setVehicleLightState(vehicle,1,1)
			setVehicleLightState(vehicle,2,1)
			setVehicleLightState(vehicle,3,1)
			
		else
			setVehicleLightState(vehicle,0,0)
			setVehicleLightState(vehicle,1,0)
			setVehicleLightState(vehicle,2,0)
			setVehicleLightState(vehicle,3,0)
		end
	end,500,0,vehicle)
end

for i,v in pairs(getElementsByType('player')) do
	bindKey(v,',','down',function(player)
		local vehicle = getPedOccupiedVehicle(player)
		if vehicle then
			if getVehicleOverrideLights(vehicle) > 0 then
				if isTimer(timer1[vehicle]) then
					killTimer(timer1[vehicle])
				end
				if isTimer(timer2[vehicle]) then
					killTimer(timer2[vehicle])
				end
				if isTimer(timer3[vehicle]) then
					killTimer(timer3[vehicle])
				end
				setVehicleOverrideLights(vehicle,0)
				setVehicleLightState(vehicle,0,0)
				setVehicleLightState(vehicle,3,0)
			else
				startLeftBlinker(vehicle)
			end
		end
	end)
	bindKey(v,'.','down',function(player)
		local vehicle = getPedOccupiedVehicle(player)
		if vehicle then
			if getVehicleOverrideLights(vehicle) > 0 then
				if isTimer(timer1[vehicle]) then
					killTimer(timer1[vehicle])
				end
				if isTimer(timer2[vehicle]) then
					killTimer(timer2[vehicle])
				end
				if isTimer(timer3[vehicle]) then
					killTimer(timer3[vehicle])
				end
				setVehicleOverrideLights(vehicle,0)
				setVehicleLightState(vehicle,1,0)
				setVehicleLightState(vehicle,2,0)
			else
				startRightBlinker(vehicle)
			end
		end
	end)
	bindKey(v,'/','down',function(player)
		local vehicle = getPedOccupiedVehicle(player)
		if vehicle then
			if getVehicleOverrideLights(vehicle) > 0 then
				if isTimer(timer1[vehicle]) then
					killTimer(timer1[vehicle])
				end
				if isTimer(timer2[vehicle]) then
					killTimer(timer2[vehicle])
				end
				if isTimer(timer3[vehicle]) then
					killTimer(timer3[vehicle])
				end
				setVehicleOverrideLights(vehicle,0)
				setVehicleLightState(vehicle,0,0)
				setVehicleLightState(vehicle,1,0)
				setVehicleLightState(vehicle,2,0)
				setVehicleLightState(vehicle,3,0)
			else
				startHazardBlinker(vehicle)
			end
		end
	end)
end