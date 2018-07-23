function toggleGodMode(thePlayer)
local account = getPlayerAccount(thePlayer)
if (not account or isGuestAccount(account)) then return end
local accountName = getAccountName(account)
if ( isObjectInACLGroup("user."..accountName,aclGetGroup("Console")) or isObjectInACLGroup("user."..accountName,aclGetGroup("Admin")) or isObjectInACLGroup("user."..accountName,aclGetGroup("SuperModerator")) or isObjectInACLGroup("user."..accountName,aclGetGroup("Moderator"))) then
    if getElementData(thePlayer,"invincible") then
        setElementData(thePlayer,"invincible",false)
        outputChatBox("Player Godmode is now Disabled.",thePlayer,0,255,0)
    else
        setElementData(thePlayer,"invincible",true)
        outputChatBox("Player Godmode is now Enabled.",thePlayer,0,255,0)
        end
    end
end
addCommandHandler("god",toggleGodMode)

function godMode(thePlayer, cmd, who)
local account = getPlayerAccount(thePlayer)
if (not account or isGuestAccount(account)) then return end
local accountName = getAccountName(account)
if ( isObjectInACLGroup("user."..accountName,aclGetGroup("Console")) or isObjectInACLGroup("user."..accountName,aclGetGroup("Admin")) or isObjectInACLGroup("user."..accountName,aclGetGroup("SuperModerator")) or isObjectInACLGroup("user."..accountName,aclGetGroup("Moderator"))) then
    if who then
	if getElementData(getPlayerFromPartialName(who),"invincible") then
        setElementData(getPlayerFromPartialName(who),"invincible",false)
        outputChatBox("Player Godmode was disabled.",getPlayerFromPartialName(who),0,255,0)
        outputChatBox("Player Godmode is now disabled for "..who..".",thePlayer,0,255,0)
    else
        setElementData(getPlayerFromPartialName(who),"invincible",true)
        outputChatBox("Player Godmode was enabled.",getPlayerFromPartialName(who),0,255,0)
        outputChatBox("Player Godmode is now enabled for "..who..".",thePlayer,0,255,0)
    end
	end
end
end
addCommandHandler("sgod",godMode)

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