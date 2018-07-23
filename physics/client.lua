local dff = engineLoadDFF('elegy.dff')
engineReplaceModel(dff,562)

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
						local position = Vector3(getVehicleComponentPosition(v,self.mods[i].parent,'world'))
						local rotation = Vector3(getVehicleComponentRotation(v,self.mods[i].parent,'world'))
						position = position+Vector3(o.x,o.y,o.z)
						rotation = rotation+Vector3(o.rx,o.ry,o.rz)
						local matrix = Matrix(position,rotation)
						matrix = Matrix(matrix:transformPosition(position,rotation))
						setVehicleComponentPosition(v,self.mods[i].name,matrix:getPosition())
						setVehicleComponentRotation(v,self.mods[i].name,matrix:getRotation(),'ZYX')
					end
				end
			end
		end
	end
end)