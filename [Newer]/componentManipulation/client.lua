
dff = engineLoadDFF('elegy.dff')
engineReplaceModel(dff,562)

function runPosition(cmd,...)
	print(1)
	if arg[1] and arg[2] and tonumber(arg[2]) then
		print(2)
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if vehicle then
			print(3)
			local component
			for k in pairs(getVehicleComponents(vehicle)) do
				if string.lower(k) == string.lower(arg[1]) then
					print(4)
					component = string.lower(k)
				end
			end
			if component then
				print(5)
				local x,y,z = getVehicleComponentPosition(vehicle,component)
				local rx,ry,rz = getVehicleComponentRotation(vehicle,component)
				if cmd == 'ox' then
					print(6)
					setVehicleComponentPosition(vehicle,component,x+tonumber(arg[2]),y,z)
				elseif cmd == 'oy' then
					setVehicleComponentPosition(vehicle,component,x,y+tonumber(arg[2]),z)
				elseif cmd == 'oz' then
					setVehicleComponentPosition(vehicle,component,x,y,z+tonumber(arg[2]))
				elseif cmd == 'rx' then
					setVehicleComponentRotation(vehicle,component,rx+tonumber(arg[2]),ry,rz)
				elseif cmd == 'ry' then
					setVehicleComponentRotation(vehicle,component,rx,ry+tonumber(arg[2]),rz)
				elseif cmd == 'rz' then
					setVehicleComponentRotation(vehicle,component,rx,ry,rz+tonumber(arg[2]))
				end
			end
		end
	end
end
local cmds = {'ox','oy','oz','rx','ry','rz'}
for i,c in pairs(cmds) do
	addCommandHandler(c,runPosition)
end

function isVehicleComponent(vehicle,component)
	for k in pairs(getVehicleComponents(vehicle)) do
		if k == component then
			return true
		end
	end
	return false
end

addEventHandler('onClientPreRender',root,function()
	local vehs = getElementsByType('vehicle')
	for i,v in pairs(vehs) do
		local self = getElementData(v,'mods')
		if self then
			for i=1,#self.mods do
				if isVehicleComponent(v,self.mods[i].name) then
					local o = self.mods[i].offsets
					if self.mods[i].parent then
						local x,y,z = getVehicleComponentPosition(v,self.mods[i].parent,'world')
						local rx,ry,rz = getVehicleComponentRotation(v,self.mods[i].parent,'world')
						setVehicleComponentPosition(v,self.mods[i].name,x+o.x,y+o.y,z+o.z)
						setVehicleComponentRotation(v,self.mods[i].name,rx+o.rx,ry+o.ry,rz+o.rz,'ZYX')
					end
				end
			end
		end
	end
end)