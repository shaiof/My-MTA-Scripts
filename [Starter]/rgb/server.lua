function rgbToggle(player,cmd,toggle)
    if toggle == "on" then
		setElementData(getPedOccupiedVehicle(player),"rgb",true)
        outputChatBox("Enabled.",player,0,255,255)
    elseif toggle == "off" then
		setElementData(getPedOccupiedVehicle(player),"rgb",false)
        outputChatBox("Disabled.",player,0,255,255)
	elseif not toggle then
		outputChatBox("Incorrect Syntax! /rgb <on/off>",player,255,0,0)
		return
    end
end
addCommandHandler("rgb",rgbToggle)