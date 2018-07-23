setTimer(function()
	for _,p in ipairs(getElementsByType("player")) do
		local account = getAccountName(getPlayerAccount(p))
		if account then
			if (isObjectInACLGroup("user."..account,aclGetGroup("Admin"))) or (isObjectInACLGroup("user."..account,aclGetGroup("SuperModerator"))) or (isObjectInACLGroup("user."..account,aclGetGroup("Moderator"))) then
				setAccountData(getPlayerAccount(p),"pTeam","Staff")
			else
				setAccountData(getPlayerAccount(p),"pTeam","Freeroamer")
			end
		end
	end
end,50,0)