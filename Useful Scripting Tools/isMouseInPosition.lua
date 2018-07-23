[[
function isMouseInPosition(x,y,w,h)
	if isCursorShowing() then
		local sx,sy = guiGetScreenSize()
		local cx,cy = getCursorPosition()
		local cx,cy = (cx*sx),(cy*sy)
		if (cx >= x and cx <= x+w) and (cy >= y and cy <= y+h) then
			return true
		end
	end
end
]]