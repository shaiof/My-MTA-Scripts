local wheelNames = {'wheel_lf_dummy','wheel_rf_dummy','wheel_lb_dummy','wheel_rb_dummy','wheel_lm_dummy','wheel_rm_dummy'}

function getOffsets(vehicle,object)
	for i,veh in pairs(offsets) do
		if veh == getElementModel(vehicle) then
			for k,obj in pairs(offsets[veh]) do
				if obj == getElementModel(object) then
					local x,y,z,rx,ry,rz = offsets[veh][obj]
					return x,y,z,rx,ry,rz
				end
			end
		end
	end
	return false
end

addEventHandler('onClientPreRender',root,function()
	local vehs = getElementsByType('vehicle')
	for i,v in pairs(vehs) do
		local self = getElementData(v,'wheels')
		if self then
			for i=1,#self.wheels do
				if isElement(self.wheels[i]) then
					local x,y,z = getVehicleComponentPosition(self.vehicle,wheelNames[i],'world')
					local rx,ry,rz = getVehicleComponentRotation(self.vehicle,wheelNames[i],'world')
					local newPos1 = (z-(self.wx1/2))+(getObjectScale(self.wheels[i])/2)
					local newPos2 = (z-(self.wx2/2))+(getObjectScale(self.wheels[i])/2)
					if i == 1 then self.camber = self.camber*-1 end
					if i == 1 or i == 2 then
						setElementPosition(self.wheels[i],x,y,newPos1)
					else
						setElementPosition(self.wheels[i],x,y,newPos2)
					end
					setElementRotation(self.wheels[i],rx,ry+self.camber,rz,'ZYX')
				end
			end
			for k,attach in pairs(self.attached) do
				if k >= 1 then
					if attach.offsets[1] then
						local position = Vector3(getVehicleComponentPosition(self.vehicle,attach.offsets[2],'world'))
						local rotation = Vector3(getVehicleComponentRotation(self.vehicle,attach.offsets[2],'world'))
						rotation = rotation+Vector3(attach.offsets[6],attach.offsets[7],attach.offsets[8])
						local matrix = Matrix(position,rotation)
						matrix = Matrix(matrix:transformPosition(Vector3(attach.offsets[3],attach.offsets[4],attach.offsets[5])),rotation)
						setElementPosition(attach.object,matrix:getPosition())
						setElementRotation(attach.object,matrix:getRotation(),'ZYX')
					end
				end
			end
			if isElement(self.objTest.obj) then
				local position = Vector3(getVehicleComponentPosition(self.vehicle,self.objTest.bind,'world'))
				local rotation = Vector3(getVehicleComponentRotation(self.vehicle,self.objTest.bind,'world'))
				rotation = rotation+Vector3(self.objTest.rx,self.objTest.ry,self.objTest.rz)
				local matrix = Matrix(position,rotation)
				matrix = Matrix(matrix:transformPosition(Vector3(self.objTest.ox,self.objTest.oy,self.objTest.oz)),rotation)
				setElementPosition(self.objTest.obj,matrix:getPosition())
				setElementRotation(self.objTest.obj,matrix:getRotation(),'ZYX')
			end
			for i=1,#self.rComponents do
				setVehicleComponentVisible(self.vehicle,tostring(self.rComponents[i]),false)
			end
		end
	end
end)

addEvent('removeWheels',true)
addEventHandler('removeWheels',root,function(self)
	for i,wheel in pairs(self.wheels) do
		setVehicleComponentVisible(self.vehicle,wheelNames[i],false)
	end
end)

addEvent('setParent',true)
addEventHandler('setParent',root,function(self)
	for i=1,#self.wheels do
		setElementParent(self.wheels[i],self.vehicle)
	end
end)

picador_dff = engineLoadDFF('/mods/picador.dff')
engineReplaceModel(picador_dff,600)
burrito_dff = engineLoadDFF('/mods/burrito.dff')
engineReplaceModel(burrito_dff,482)
turismo_dff = engineLoadDFF('/mods/turismo.dff')
engineReplaceModel(turismo_dff,451)
--sandking_txd = engineLoadTXD('/mods/sandking.txd')
--engineImportTXD(sandking_txd,495)
sandking_dff = engineLoadDFF('/mods/sandking.dff')
engineReplaceModel(sandking_dff,495)
supergt_dff = engineLoadDFF('/mods/supergt.dff')
engineReplaceModel(supergt_dff,506)

--[[
function clientRenderFunc()
    if(handl) then
	dxDrawRectangle(sx/2,0,1,256,tocolor(255,255,255,127))
        local bt = getSoundFFTData(handl,2048,257)
	if(not bt) then return end
        for i=1,256 do
            bt[i] = math.sqrt(bt[i])*256 --scale it (sqrt to make low values more visible)
            dxDrawRectangle(sx/2-bt[i]/2,i-1,bt[i],1)
        end
    end
end
]]