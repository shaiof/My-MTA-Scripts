[[
function setAccountName(old,new,password)
	if old and new and password then
		local oldAccount,newAccount,newPass = getAccount(old),getAccount(new),password
		if oldAccount and not newAccount then
			if addAccount(new,newPass) then
				local newAccount = getAccount(new)
				for index,value in pairs(getAllAccountData(oldAccount)) do
					setAccountData(newAccount,index,value)
				end
				for index,value in ipairs(aclGroupList()) do
					if isObjectInACLGroup('user.'..old,value) then
						aclGroupAddObject(value,'user.'..new)
						aclGroupRemoveObject(value,'user.'..old)
					end
				end
				setTimer(removeAccount,100,1,oldAccount)
				return true
			end
		end
	end
	return false
end
]]