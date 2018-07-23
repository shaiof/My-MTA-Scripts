[[
addEvent('onCursorMove')
local cP = {x=0,y=0,move='nil',timer=nil}
addEventHandler('onClientCursorMove',root,function(cx,cy)
    if isCursorShowing() then
		if cx > cP.x then
			cP.move = 'right'
		elseif cx < cP.x then
			cP.move = 'left'
		elseif cy > cP.y then
			cP.move = 'up'
		elseif cy < cP.y then
			cP.move = 'down'
		end
		
		cP.x = cx
		cP.y = cy
		
		if isTimer(cP.timer) then
			killTimer(cP.timer)
		end
		
		cP.timer = setTimer(function()
			cP.move = 'nil'
		end,50,1)
		triggerEvent('onCursorMove',root,cp.move)
	end
end)
]]