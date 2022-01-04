bind = 'num_enter'

addEventHandler('onResourceStart',resourceRoot,function()
	for i,v in pairs(getElementsByType('player')) do
		bindKey(v,bind,'down',det)
	end
	setWeaponProperty(39,'poor','flags',0x000002)
	setWeaponProperty(39,'std','flags',0x000002)
	setWeaponProperty(39,'pro','flags',0x000002)
	setWeaponProperty(39,'poor','flags',0x000010)
	setWeaponProperty(39,'std','flags',0x000010)
	setWeaponProperty(39,'pro','flags',0x000010)
	setWeaponProperty(39,'poor','flags',0x000020)
	setWeaponProperty(39,'std','flags',0x000020)
	setWeaponProperty(39,'pro','flags',0x000020)
	setWeaponProperty(39,'poor','flags',0x000100)
	setWeaponProperty(39,'std','flags',0x000100)
	setWeaponProperty(39,'pro','flags',0x000100)
end)

addEventHandler('onPlayerJoin',root,function()
	bindKey(source,bind,'down',det)
end)

function det(player,key,state)
	if key == bind and state == 'down' then
		detonateSatchels(player)
	end
end