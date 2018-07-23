function stripWeap(player,cmd,holder)
re = getPlayerFromPartialName(holder)
	if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)),aclGetGroup("Console")) or isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)),aclGetGroup("Admin")) or isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)),aclGetGroup("SuperModerator")) or isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)),aclGetGroup("Moderator")) then
		takeAllWeapons(re)
		for _,plr in ipairs(getElementsByType("player")) do
			outputChatBox(getPlayerName(player).." has stripped "..getPlayerName(re).." of all weapons!",plr,0,255,255)
		end
	end
end
addCommandHandler("strip",stripWeap)

function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end