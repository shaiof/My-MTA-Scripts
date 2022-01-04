function vehicleGodMod(player)
local account = getPlayerAccount(player)
if (not account or isGuestAccount(account)) then return end
local accountName = getAccountName(account)
if ( isObjectInACLGroup("user."..accountName,aclGetGroup("Console")) or isObjectInACLGroup("user."..accountName,aclGetGroup("Admin")) or isObjectInACLGroup("user."..accountName,aclGetGroup("SuperModerator")) or isObjectInACLGroup("user."..accountName,aclGetGroup("Moderator"))) then
	if (isVehicleDamageProof(getPedOccupiedVehicle(player))) then
		setVehicleDamageProof(getPedOccupiedVehicle(player),false)
		outputChatBox("Vehicle Godmode is now Disabled!",player,0,255,0)
	else
		setVehicleDamageProof(getPedOccupiedVehicle(player),true)
		outputChatBox("Vehicle Godmode is now Enabled!",player,0,255,0)
    end
end
end
addCommandHandler("vgod",vehicleGodMod)

function vehicleGodMod(player, cmd, otherPlayer)
local account = getPlayerAccount(player)
if (not account or isGuestAccount(account)) then return end
local accountName = getAccountName(account)
if ( isObjectInACLGroup("user."..accountName,aclGetGroup("Console")) or isObjectInACLGroup("user."..accountName,aclGetGroup("Admin")) or isObjectInACLGroup("user."..accountName,aclGetGroup("SuperModerator")) or isObjectInACLGroup("user."..accountName,aclGetGroup("Moderator"))) then
	if otherPlayer then
	if (isVehicleDamageProof(getPedOccupiedVehicle(getPlayerFromPartialName(otherPlayer)))) then
		setVehicleDamageProof(getPedOccupiedVehicle(getPlayerFromPartialName(otherPlayer)),false)
		outputChatBox("Vehicle Godmode is now Disabled for "..otherPlayer.."!",player,0,255,0)
		outputChatBox("Vehicle Godmode is now Disabled!",getPlayerFromPartialName(otherPlayer),0,255,0)
	else
		setVehicleDamageProof(getPedOccupiedVehicle(getPlayerFromPartialName(otherPlayer)),true)
		outputChatBox("Vehicle Godmode is now Enabled for "..otherPlayer.."!",player,0,255,0)
		outputChatBox("Vehicle Godmode is now Enabled!",getPlayerFromPartialName(otherPlayer),0,255,0)
    end
	end
end
end
addCommandHandler("svgod",vehicleGodMod)

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