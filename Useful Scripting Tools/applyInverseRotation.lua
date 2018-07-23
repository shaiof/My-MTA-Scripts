[[
function applyInverseRotation(x,y,z,rx,ry,rz)
	local dtg = (math.pi*2)/360
	rx = rx*dtg
	ry = ry*dtg
	rz = rz*dtg
	local ty = y
	local tx = x
	
	y = math.cos(rx)*ty+math.sin(rx)*z
	z = -math.sin(rx)*ty+math.cos(rx)*z
	x = math.cos(ry)*tx-math.sin(ry)*z
	z = math.sin(ry)*tx+math.cos(ry)*z
	tx = x
	x = math.cos(rz)*tx+math.sin(rz)*y
	y = -math.sin(rz)*tx+math.cos(rz)*y

	return x,y,z
end
]]