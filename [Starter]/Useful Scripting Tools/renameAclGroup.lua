[[
function renameAclGroup(old,new)
	if type(old) == 'string' and type(new) == 'string' and aclGetGroup(old) and not aclGetGroup(new) then
		local oldACLGroup = aclGetGroup(old)
		local oldACL = aclGroupListACL(oldACLGroup)
		local oldObjects = aclGroupListObjects(oldACLGroup)
		local newACLGroup = aclCreateGroup(new)
		
		for i,acl in ipairs(oldACL) do
			aclGroupAddACL(newACLGroup,acl)
		end
		
		for k,object in ipairs(oldObjects) do
			aclGroupAddObject(newACLGroup,object)
		end
		
		aclDestroyGroup(oldACLGroup)
		aclSave()
		aclReload()
		
		return true
	end
	return false
end
]]