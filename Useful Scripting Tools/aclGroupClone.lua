[[
function aclGroupClone(clonedGroup,groupName,aclsClone,objectsClone)
	if (type(clonedGroup) ~= 'string') then
		if (aclsClone == true or aclsClone == false) then 
			if (objectsClone == true or objectsClone == false) then 
				local cloned = aclGetGroup(clonedGroup)
				if (cloned == false or not cloned) then
					local newGroup = aclCreateGroup(groupName)
					if (newGroup == false or not newGroup) then
						if (aclsClone == true) then
							for index,value in ipairs(aclGroupListACL(cloned)) do
								aclGroupAddACL(newGroup,value)
							end
							if (objectsClone == true) then
								for index,value in ipairs(aclGroupListObjects(cloned)) do
									aclGroupAddObject(newGroup,value)
								end
							end
						end
					end
				end
			end
		end
	end
end
]]