rcData = {
	{v = 441,w = 'minigun'},
    {v = 464,w = 'minigun'},
    {v = 594,w = 'silenced'},
    {v = 501,w = 'minigun'},
    {v = 465,w = 'minigun'},
    {v = 564,w = 'deagle'}
}

weap = {}

addEventHandler('onClientVehicleEnter',root,function(player,seat)
    if seat == 0 then
        for i,v in ipairs(rcData) do
            if getElementModel(source) == v.v then
                local x,y,z = getElementPosition(source)
                weap[player] = createWeapon(v.w,x,y,z)
				attachElements(weap[player],source,0,0,0,0,0,90)
				setElementAlpha(weap[player],0)
                bindKey('lctrl','both',fire,player)
            end
        end
    end
end)

addEventHandler('onClientVehicleExit',root,function(player,seat)
	if weap[player] then
		destroyElement(weap[player])
	end
end)

function fire(key,state,player)
	if state == 'up' then
		setWeaponState(weap[player],'ready')
	elseif state == 'down' then
		setWeaponState(weap[player],'firing')
	end
end