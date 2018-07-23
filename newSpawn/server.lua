local root = getRootElement()
-------------------------------------------------- Configuration --------------------------------------------------
defaultTeam = "Freeroamer"

teams = {
    {team = "Freeroamer",skin = 1,x = -1980.03125,y = 884.171875,z = 45.203125,rot = 90,r = 0,g = 255,b = 255},
    {team = "Staff",skin = 0,x = -2025.8017578125,y = 171.3896484375,z = 28.84375,rot = -90,r = 255,g = 0,b = 80}
}
-------------------------------------------------------------------------------------------------------------------
groups = {}

setTimer(function()
	for i,p in pairs(getElementsByType("player")) do
		local team = getTeam(p)
		setPlayerTeam(p,getTeamFromName(team))
	end
end,2000,0)

function getTeam(player)
	for k,s in pairs(teams) do
		if s.tag then
			if groups[s.team] then
				for i,l in pairs(groups[s.team]['members']) do
					local serial = getPlayerSerial(player)
					if serial == l[1] then
						return s.team
					else
						if getPlayerRank(player,"Moderator") or getPlayerRank(player,"SuperModerator") or getPlayerRank(player,"Admin") then
							return "Staff"
						else
							return defaultTeam
						end
					end
				end
			end
		else
			if getPlayerRank(player,"Moderator") or getPlayerRank(player,"SuperModerator") or getPlayerRank(player,"Admin") then
				if s.team == "Staff" then
					return s.team
				end
			else
				if s.team == defaultTeam then
					return s.team
				end
			end
		end
	end
end

for i,t in pairs(teams) do
	createTeam(t.team,t.r,t.g,t.b)
end
 
addEventHandler("onPlayerLogin",root,function()
	for i,r in pairs(teams) do
		if r.team == getTeam(source) then
			spawnPlayer(source,r.x,r.y,r.z,r.rot,r.skin,0,0,getTeamFromName(r.team))
			setCameraTarget(source,source)
		end
	end
end)
 
addEventHandler("onPlayerWasted",root,function()
	local source = source
	setTimer(function()
		local account = getPlayerAccount(source)
		if getAccountData(account,'jailed') == true then
			local x,y,z,int,dim = getAccountData(account,'jx'),getAccountData(account,'jy'),getAccountData(account,'jz'),getAccountData(account,'jint'),getAccountData(account,'jdim')
			spawnPlayer(source,x,y,z)
			setElementInterior(source,int)
			setElementDimension(source,dim)
			setElementPosition(source,x,y,z)
			setCameraTarget(source,source)
		else
			for i,r in pairs(teams) do
				if r.team == getTeam(source) then
					spawnPlayer(source,r.x,r.y,r.z,r.rot,r.skin,0,0,getTeamFromName(r.team))
					setCameraTarget(source,source)
				end
			end
		end
	end,4000,1)
end)

function getPlayerRank(player,rank)
	local accountName = getAccountName(getPlayerAccount(player))
	if rank == "Moderator" then
		if isObjectInACLGroup("user."..accountName,aclGetGroup("Moderator")) or isObjectInACLGroup("user."..accountName,aclGetGroup("SuperModerator")) or isObjectInACLGroup("user."..accountName,aclGetGroup("Admin")) then
			return true
		else
			return false
		end
	elseif rank == "SuperModerator" then
		if isObjectInACLGroup("user."..accountName,aclGetGroup("SuperModerator")) or isObjectInACLGroup("user."..accountName,aclGetGroup("Admin")) then
			return true
		else
			return false
		end
	elseif rank == "Admin" then
		if isObjectInACLGroup("user."..accountName,aclGetGroup("Admin")) then
			return true
		else
			return false
		end
	end
end

function aclAdd(player,cmd,group,t,other)
	if group then
		local aclGroup = aclGetGroup(group)
		if aclGroup then
			if getPlayerRank(player,group) == true then
				if t then
					if t == "resource" then
						if other then
							for i,r in pairs(getResources()) do
								if getResourceName(r) == other then
									if isObjectInACLGroup(t.."."..other,aclGroup) then
										outputChatBox("This resource is already in this acl group!",player,255,0,0)
									else
										aclGroupAddObject(aclGroup,t.."."..other)
										outputChatBox(other.." successfully added to "..group.."!",player,0,255,0)
									end
								end
							end
						else
							outputChatBox("You need to specify a resource!",player,255,0,0)
						end
					elseif t == "user" then
						if other then
							if isObjectInACLGroup(t.."."..other,aclGroup) then
								outputChatBox("This user is already in this acl group!",player,255,0,0)
							else
								aclGroupAddObject(aclGroup,t.."."..other)
								outputChatBox(other.." successfully added to "..group.."!",player,0,255,0)
							end
						else
							outputChatBox("You need to specify a user!",player,255,0,0)
						end
					else
						outputChatBox(t.." is not a valid type! (resource or user)",player,255,0,0)
					end
				else
					outputChatBox("You need to specify a type! (resource or user)",player,255,0,0)
				end
			else
				outputChatBox("You are not permitted to that ACL Group!",player,255,0,0)
			end
		else
			outputChatBox(group.." is not a valid ACL Group!",player,255,0,0)
		end
	else
		outputChatBox("You need to specify an ACL Group!",player,255,0,0)
	end
end
addCommandHandler("acladd",aclAdd)

function aclRemove(player,cmd,group,t,other)
	if group then
		local aclGroup = aclGetGroup(group)
		if aclGroup then
			if getPlayerRank(player,group) == true then
				if t then
					if t == "resource" then
						if other then
							for i,r in pairs(getResources()) do
								if getResourceName(r) == other then
									if not isObjectInACLGroup(t.."."..other,aclGroup) then
										outputChatBox("This object is not in this acl group!",player,255,0,0)
									else
										aclGroupRemoveObject(aclGroup,t.."."..other)
										outputChatBox(other.." successfully removed from "..group.."!",player,0,255,0)
									end
								end
							end
						else
							outputChatBox("You need to specify a resource!",player,255,0,0)
						end
					elseif t == "user" then
						if other then
							if not isObjectInACLGroup(t.."."..other,aclGroup) then
								outputChatBox("This user is not in this acl group!",player,255,0,0)
							else
								aclGroupRemoveObject(aclGroup,t.."."..other)
								outputChatBox(other.." successfully removed from "..group.."!",player,0,255,0)
							end
						else
							outputChatBox("You need to specify a user!",player,255,0,0)
						end
					else
						outputChatBox(t.." is not a valid type! (resource or user)",player,255,0,0)
					end
				else
					outputChatBox("You need to specify a type! (resource or user)",player,255,0,0)
				end
			else
				outputChatBox("You are not permitted to that ACL Group!",player,255,0,0)
			end
		else
			outputChatBox(group.." is not a valid ACL Group!",player,255,0,0)
		end
	else
		outputChatBox("You need to specify an ACL Group!",player,255,0,0)
	end
end
addCommandHandler("aclremove",aclRemove)

function getacc(player,cmd,otherPlayer)
	if otherPlayer then
		local other = getPlayerFromName(otherPlayer)
		if other then
			local accountName = getAccountName(getPlayerAccount(other))
			local playerName = getPlayerName(other)
			outputChatBox(playerName.."'s Account Name: "..accountName,player,0,255,255)
		end
	end
end
addCommandHandler("getacc",getacc)

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

addCommandHandler('test',function(player,cmd)
	outputChatBox(tostring(cmd))
end)

function addToGroup(player,cmd,other)
	if other then
		if getPlayerRank(player,"Admin") then
			local otherPlayer = getPlayerFromPartialName(other)
			if otherPlayer then
				local team = getTeamName(getPlayerTeam(player))
				if groups[team] then
					local serial = getPlayerSerial(otherPlayer)
					for u,n in pairs(groups[team]) do
						if not n == serial then
							table.insert(groups[team],serial)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("add",addToGroup)

function createRank(player,cmd,rankName)
	if rankName then
		local team = getTeamName(getPlayerTeam(player))
		if groups[team] then
			local serial = getPlayerSerial(otherPlayer)
			for q,w in pairs(groups[team]['members']) do
				if w[1] == serial then
					for qq,ww in pairs(groups[team]['ranks']) do
						if qq == w[2] then
							for qqq,www in pairs(groups[team]['ranks'][w[2]]['perms']) do
								if www == cmd or getPlayerRank(player,"Admin") then
									table.insert(groups[team]['ranks'],rankName)
								end
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("createrank",createRank)