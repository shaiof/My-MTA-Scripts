[[
function RGBToHex(r,g,b,a)
	if ((r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255) or (a and (a < 0 or a > 255))) then
		return nil
	end
	if a then
		return string.format('#%.2X%.2X%.2X%.2X',r,g,b,a)
	else
		return string.format('#%.2X%.2X%.2X',r,g,b)
	end
end
]]