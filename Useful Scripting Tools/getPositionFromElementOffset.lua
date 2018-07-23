[[
function getPositionFromElementOffset(element,ox,oy,oz)
	local m = getElementMatrix(element)
	local x = ox*m[1][1]+oy*m[2][1]+oz*m[3][1]+m[4][1]
	local y = ox*m[1][2]+oy*m[2][2]+oz*m[3][2]+m[4][2]
	local z = ox*m[1][3]+oy*m[2][3]+oz*m[3][3]+m[4][3]
	return x,y,z
end
]]