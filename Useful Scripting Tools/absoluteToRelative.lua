[[
function absoluteToRelative(x,y,w,h,devx,devy)
	local sx,sy = guiGetScreenSize()
	return x/devx*sx,y/devy*sy,w/devx*sx,h/devy*sy
end
]]