[[
function isPlayerInACL(player,acl)
	local account = getPlayerAccount(player)
    if account and not isGuestAccount(account) then
		local accountName = getAccountName(account)
		if accountName ~= 'guest' and type(aclGetGroup(acl)) == 'userdata' then
			return isObjectInACLGroup('user.'..accountName,aclGetGroup(acl))
		end
	end
	return false
end
]]