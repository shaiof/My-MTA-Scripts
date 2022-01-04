
function health(player, cmd)
	setElementHealth(player, 200)
end
addCommandHandler("hp", health)

function armour(player, cmd)
	setPedArmor(player, 100)
end
addCommandHandler("a", armour)

function stats(player, cmd)
	setPedStat(player, 24, 1000)
	setPedStat(player, 23, 1000)
	setPedStat(player, 69, 1000)
	setPedStat(player, 70, 1000)
	setPedStat(player, 71, 1000)
	setPedStat(player, 72, 1000)
	setPedStat(player, 73, 1000)
	setPedStat(player, 74, 1000)
	setPedStat(player, 75, 1000)
	setPedStat(player, 76, 1000)
	setPedStat(player, 77, 1000)
	setPedStat(player, 78, 1000)
	setPedStat(player, 79, 1000)
	setPedStat(player, 230, 1000)
	setElementHealth(player, 200)
end
addCommandHandler("stats", stats)