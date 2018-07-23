news = ""

addEventHandler("onPlayerJoin",root,function()
	if news == "" then
		return
	else
		outputChatBox("#FF0000[#00FFFFNEWS#FF0000] #FFFFFF"..news,source,0,255,255,true)
	end
end)

addEventHandler("onResourceStart",resourceRoot,function()
	for _,plr in ipairs(getElementsByType("player")) do
		if news == "" then
			return
		else
			outputChatBox("#FF0000[#00FFFFNEWS#FF0000] #FFFFFF"..news,plr,0,255,255,true)
		end
	end
end)

setTimer(function()
	for _,plr in ipairs(getElementsByType("player")) do
		if news == "" then
			return
		else
			outputChatBox("#FF0000[#00FFFFNEWS#FF0000] #FFFFFF"..news,plr,0,255,255,true)
		end
	end
end,2400000,0)

function newNews(player,cmd,...)
	local words = {...}
	local message = table.concat(words," ")
	news = message
	for _,plr in ipairs(getElementsByType("player")) do
		if news == "" then
			return
		else
			outputChatBox("#FF0000[#00FFFFNEWS#FF0000] #FFFFFF"..news,plr,0,255,255,true)
		end
	end
end
addCommandHandler("news",newNews)