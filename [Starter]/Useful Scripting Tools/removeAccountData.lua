[[
function removeAccountData(playerAccount,data)
	if (playerAccount ~= '') and (data ~= '') then
		if getAccount(playerAccount) then
			local dataName = getAccountData(playerAccount,data)
			if (dataName ~= nil) or (dataName ~= '') then
				setAccountData(playerAccount,data,nil)
				return true
			end
		end
	end
end
]]