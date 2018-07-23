default = {}
wheels = {}

--[[function cWheel(cmd,w)
	if w then
		local r = getPedOccupiedVehicle(localPlayer)
		if r then
			if wheels[r] then
				
			end
		end
	end
end
addCommandHandler('cwheel',cWheel)]]

addEventHandler('onClientElementDestroy',root,function()
    if wheels[source] then
        for i,j in pairs(wheels[source]) do
            destroyElement(j)
        end
    end
end)

function setWheel(ve)
	if not wheels[ve] then
		if not default[ve] then
			wheels[ve] = {}
			wheels[ve][1] = createObject(1075,0,0,0)
			wheels[ve][2] = createObject(1075,0,0,0)
			wheels[ve][3] = createObject(1075,0,0,0)
			wheels[ve][4] = createObject(1075,0,0,0)
			setObjectScale(wheels[ve][1],0.7)
			setObjectScale(wheels[ve][2],0.7)
			setObjectScale(wheels[ve][3],0.7)
			setObjectScale(wheels[ve][4],0.7)
			attachElements(wheels[ve][1],ve)
			attachElements(wheels[ve][2],ve)
			attachElements(wheels[ve][3],ve)
			attachElements(wheels[ve][4],ve)
			setElementData(wheels[ve][1],'wheel',1075)
			setElementData(wheels[ve][2],'wheel',1075)
			setElementData(wheels[ve][3],'wheel',1075)
			setElementData(wheels[ve][4],'wheel',1075)
			default[ve] = true
			for t in pairs(getVehicleComponents(ve)) do
				if t == 'wheel_rf_dummy' or t == 'wheel_lf_dummy' or t == 'wheel_rb_dummy' or t == 'wheel_lb_dummy' then
					setVehicleComponentVisible(ve,t,false)
				end
			end
		end
	end
end

addEventHandler('onClientVehicleEnter',root,function()
    setWheel(source)
end)

addEventHandler('onClientResourceStart',resourceRoot,function()
	for s,vehicle in pairs(getElementsByType('vehicle')) do
        setWheel(vehicle)
		if wheels[vehicle] then
			addEventHandler('onClientRender',root,function()
				for k in pairs(getVehicleComponents(vehicle)) do
					if k == 'wheel_rf_dummy' or k == 'wheel_lf_dummy' or k == 'wheel_rb_dummy' or k == 'wheel_lb_dummy' then
						setVehicleComponentVisible(vehicle,k,false)
					end
					if k == 'wheel_rf_dummy' then
						local x,y,z = getVehicleComponentPosition(vehicle,k)
						local rx,ry,rz = getVehicleComponentRotation(vehicle,k)
						setElementAttachedOffsets(wheels[vehicle][1],x,y,z,rx,0,rz)
					end
					if k == 'wheel_lf_dummy' then
						local x,y,z = getVehicleComponentPosition(vehicle,k)
						local rx,ry,rz = getVehicleComponentRotation(vehicle,k)
						setElementAttachedOffsets(wheels[vehicle][2],x,y,z,rx,0,rz)
					end
					if k == 'wheel_rb_dummy' then
						local x,y,z = getVehicleComponentPosition(vehicle,k)
						local rx,ry,rz = getVehicleComponentRotation(vehicle,k)
						setElementAttachedOffsets(wheels[vehicle][3],x,y,z,rx,0,rz)
					end
					if k == 'wheel_lb_dummy' then
						local x,y,z = getVehicleComponentPosition(vehicle,k)
						local rx,ry,rz = getVehicleComponentRotation(vehicle,k)
						setElementAttachedOffsets(wheels[vehicle][4],x,y,z,rx,0,rz)
					end
				end
			end)
		end
	end
end)