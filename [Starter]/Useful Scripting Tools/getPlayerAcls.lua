[[
function getPlayerAcls(player)
    local acls = {}
    local account = getPlayerAccount(player)
    if account and not isGuestAccount(account) then
        local accountName = getAccountName(account)
        for i,group in ipairs(aclGroupList()) do
            if (isObjectInACLGroup('user.'..accountName,group)) then
                local groupName = aclGroupGetName(group)
                table.insert(acls,groupName)
            end
        end
    end
    return acls
end
]]