local mods = {}
local offsets = {
	[562] = {
		['window_lf'] = {0,0,0,0,0,0}
	}
}

local moddedC = {
	{'window_lf','door_lf_dummy'},
	{'window_rf','door_rf_dummy'},
	{'window_lb','door_lb_dummy'},
	{'window_rb','door_rb_dummy'},
	{'mirror_lf','door_lf_dummy'},
	{'mirror_rf','door_rf_dummy'},
	{'mirror_c','chassis'},
	{'steering','chassis'}
}

function getOffsets(model,componet)
	if offsets[model] then
		local o = offsets[model]
		if o[component] then
			local x,y,z,rx,ry,rz = unpack(o[component])
			return x,y,z,rx,ry,rz
		end
	end
end

function startMods(vehicle)
	if vehicle and isElement(vehicle) and getElementType(vehicle) == 'vehicle' then
		local self = {}
		self.vehicle = vehicle
		self.mods = {}
		
		for i=1,#moddedC do
			self.mods[i] = {}
			self.mods[i].name = moddedC[i][1]
			self.mods[i].parent = moddedC[i][2]
			local x,y,z,rx,ry,rz = getOffsets(getElementModel(vehicle),self.mods[i])
			self.mods[i].offsets = {x=x,y=y,z=z,rx=rx,ry=ry,rz=rz}
		end
		
		table.insert(mods,self)
		return self
	end
end

addEventHandler('onResourceStart',resourceRoot,function()
	for i,v in pairs(getElementsByType('vehicle')) do
		startMods(vehicle)
	end
end)

setTimer(function()
	for i,v in pairs(getElementsByType('vehicle')) do
		for i=1,#mods do
			local m = mods[i]
			if m.vehicle == v then
				setElementData(v,'mods',m)
			end
		end
	end
end,50,0)