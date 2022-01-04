local commandSpam = {}

addEventHandler("onPlayerCommand",root,function()
	if not commandSpam[source] then
		commandSpam[source] = 1
	elseif (commandSpam[source] == 5) then
		cancelEvent()
	else
		commandSpam[source] = commandSpam[source]+1
	end
end)

setTimer(function()
	commandSpam = {}
end,3000,0)