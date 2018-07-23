[[
function isVehicleComponent(vehicle,component)
	for k in pairs(getVehicleComponents(vehicle)) do
		if k == component then
			return true
		end
	end
	return false
end
]]