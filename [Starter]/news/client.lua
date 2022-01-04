local messagesList = {
	'GTA Online Coming Soon!',
	'Visit the site! http://fenscki.ga/',
	'Let your voice be heard! http://fencski.ga/forum/',
	'READ F9!'
}
local sx,sy = guiGetScreenSize()
local sw,sh = 1366,768
local currentMessage = 1

function dxRect(...)
	arg[1],arg[2],arg[3],arg[4] = arg[1]/sw*sx,arg[2]/sh*sy,arg[3]/sw*sx,arg[4]/sh*sy
	return dxDrawRectangle(unpack(arg))
end

function dxText(...)
	arg[2],arg[3],arg[4],arg[5],arg[7] = arg[2]/sw*sx,arg[3]/sh*sy,(arg[4]+arg[2])/sw*sx,(arg[5]+arg[3])/sh*sy,(arg[7] or 1)/sw*sx
	return dxDrawText(unpack(arg))
end

y = 113
h = 27
addEventHandler('onClientRender',root,function()
	local textWidth = dxGetTextWidth(messagesList[currentMessage],1,'default')
	
	dxRect(sx-textWidth-4-16,y-1,textWidth+8,h+1,tocolor(0,0,0,192),false)
	dxText(messagesList[currentMessage],sx-textWidth-16,y,textWidth,h,tocolor(0,255,255,255),1,'default-bold','center','center',false,false,false)
end)

setTimer(function()
	if currentMessage ~= #messagesList then
		currentMessage = currentMessage+1
	else
		currentMessage = 1
	end
end,5000,0)