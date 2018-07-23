local root = getRootElement()
local personalCar = {}

function pay(player,cmd,other,amount)
local money = getPlayerMoney(player)
local otherPlayer = getPlayerFromPartialName(other)
    if not other then
		outputChatBox("Syntax: /pay (playerName) (amount)",player,0,255,255)
	else
		if ((tonumber(money) - tonumber(amount)) < 0) then
			outputChatBox("You do not have enough money!",player,0,255,255)
			return
		else
			setPlayerMoney(otherPlayer,getPlayerMoney(otherPlayer) + amount)
			setPlayerMoney(player,money - amount)
			outputChatBox("$"..amount.." has been sent to "..getPlayerName(otherPlayer).."!",player,0,255,255)
			outputChatBox("You have received $"..amount.." from "..getPlayerName(player).."!",otherPlayer,0,255,255)
		end
	end
end
addCommandHandler("pay",pay)

function buy(player,cmd,purchase)
	local money = getPlayerMoney(player)
	if not purchase then
		outputChatBox("Syntax: /buy (item)",player,0,255,255)
		outputChatBox("Item List: grapplepass, mappass, flypass, bbpass, ggunpass, minigun, rocket, hsrocket, rhino, hydra, hunter, ssparrow",player,0,255,255)
	elseif (purchase == "grapplepass") then
		setElementData(player,"purchase","grapplepass")
		outputChatBox("Type /confirm within 30 seconds to confirm your purchase. Price: $200,000 Expires: When you leave the server.",player,0,255,255)
		setTimer(function()
			if not (getElementData(player,"purchase") == false) then
				setElementData(player,"purchase",false)
				outputChatBox("Purchase Cancelled!",player,255,0,0)
			end
		end,30000,1)
	elseif (purchase == "mappass") then
		setElementData(player,"purchase","mappass")
		outputChatBox("Type /confirm within 30 seconds to confirm your purchase. Price: $200,000 Expires: When you leave the server.",player,0,255,255)
		setTimer(function()
			if not (getElementData(player,"purchase") == false) then
				setElementData(player,"purchase",false)
				outputChatBox("Purchase Cancelled!",player,255,0,0)
			end
		end,30000,1)
	elseif (purchase == "flypass") then
		setElementData(player,"purchase","flypass")
		outputChatBox("Type /confirm within 30 seconds to confirm your purchase. Price: $200,000 Expires: When you leave the server.",player,0,255,255)
		setTimer(function()
			if not (getElementData(player,"purchase") == false) then
				setElementData(player,"purchase",false)
				outputChatBox("Purchase Cancelled!",player,255,0,0)
			end
		end,30000,1)
	elseif (purchase == "bbpass") then
		setElementData(player,"purchase","bbpass")
		outputChatBox("Type /confirm within 30 seconds to confirm your purchase. Price: $200,000 Expires: When you leave the server.",player,0,255,255)
		setTimer(function()
			if not (getElementData(player,"purchase") == false) then
				setElementData(player,"purchase",false)
				outputChatBox("Purchase Cancelled!",player,255,0,0)
			end
		end,30000,1)
	elseif (purchase == "ggunpass") then
		setElementData(player,"purchase","ggunpass")
		outputChatBox("Type /confirm within 30 seconds to confirm your purchase. Price: $200,000 Expires: When you leave the server.",player,0,255,255)
		setTimer(function()
			if not (getElementData(player,"purchase") == false) then
				setElementData(player,"purchase",false)
				outputChatBox("Purchase Cancelled!",player,255,0,0)
			end
		end,30000,1)
	elseif (purchase == "minigun") then
		setElementData(player,"purchase","minigun")
		outputChatBox("Type /confirm within 30 seconds to confirm your purchase. Price: $100,000 Ammo: 1000",player,0,255,255)
		setTimer(function()
			if not (getElementData(player,"purchase") == false) then
				setElementData(player,"purchase",false)
				outputChatBox("Purchase Cancelled!",player,255,0,0)
			end
		end,30000,1)
	elseif (purchase == "rocket") then
		setElementData(player,"purchase","rocket")
		outputChatBox("Type /confirm within 30 seconds to confirm your purchase. Price: $20,000 Ammo: 10.",player,0,255,255)
		setTimer(function()
			if not (getElementData(player,"purchase") == false) then
				setElementData(player,"purchase",false)
				outputChatBox("Purchase Cancelled!",player,255,0,0)
			end
		end,30000,1)
	elseif (purchase == "hsrocket") then
		setElementData(player,"purchase","hsrocket")
		outputChatBox("Type /confirm within 30 seconds to confirm your purchase. Price: $80,000 Ammo: 10.",player,0,255,255)
		setTimer(function()
			if not (getElementData(player,"purchase") == false) then
				setElementData(player,"purchase",false)
				outputChatBox("Purchase Cancelled!",player,255,0,0)
			end
		end,30000,1)
	elseif (purchase == "rhino") then
		setElementData(player,"purchase","rhino")
		outputChatBox("Type /confirm within 30 seconds to confirm your purchase. Price: $500,000",player,0,255,255)
		setTimer(function()
			if not (getElementData(player,"purchase") == false) then
				setElementData(player,"purchase",false)
				outputChatBox("Purchase Cancelled!",player,255,0,0)
			end
		end,30000,1)
	elseif (purchase == "hydra") then
		setElementData(player,"purchase","hydra")
		outputChatBox("Type /confirm within 30 seconds to confirm your purchase. Price: $600,000",player,0,255,255)
		setTimer(function()
			if not (getElementData(player,"purchase") == false) then
				setElementData(player,"purchase",false)
				outputChatBox("Purchase Cancelled!",player,255,0,0)
			end
		end,30000,1)
	elseif (purchase == "hunter") then
		setElementData(player,"purchase","hunter")
		outputChatBox("Type /confirm within 30 seconds to confirm your purchase. Price: $600,000",player,0,255,255)
		setTimer(function()
			if not (getElementData(player,"purchase") == false) then
				setElementData(player,"purchase",false)
				outputChatBox("Purchase Cancelled!",player,255,0,0)
			end
		end,30000,1)
	elseif (purchase == "ssparrow") then
		setElementData(player,"purchase","ssparrow")
		outputChatBox("Type /confirm within 30 seconds to confirm your purchase. Price: $400,000",player,0,255,255)
		setTimer(function()
			if not (getElementData(player,"purchase") == false) then
				setElementData(player,"purchase",false)
				outputChatBox("Purchase Cancelled!",player,255,0,0)
			end
		end,30000,1)
	elseif not (purchase == "grappplepass") or (purchase == "mappass") or (purchase == "flypass") or (purchase == "bbpass") or (purchase == "ggunpass") or (purchase == "rhino") or (purchase == "hydra") or (purchase == "hunter") or (purchase == "ssparrow") then
		outputChatBox(purchase.." is not a valid item!",player,0,255,255)
	end
end
addCommandHandler("buy",buy)

function confirm(player,cmd)
	local money = getPlayerMoney(player)
	if (getElementData(player,"purchase") == false) then
		outputChatBox("You have no purchase to confirm!",player,0,255,255)
		return
	elseif (getElementData(player,"purchase") == "grapplepass") then
		if ((money - 200000) < 0) then
			outputChatBox("You do not have enough money for this item!",player,0,255,255)
			return
		else
			setElementData(player,"grapplepass",true)
			setPlayerMoney(player,money - 200000)
			outputChatBox("Purchase Complete!",player,0,255,255)
			setElementData(player,"purchase",false)
			for _,p in ipairs(getElementsByType("player")) do
				outputChatBox(getPlayerName(player).." has bought a Grapplepass for $200,000!",p,0,255,255)
			end
		end
	elseif (getElementData(player,"purchase") == "mappass") then
		if ((money - 200000) < 0) then
			outputChatBox("You do not have enough money for this item!",player,0,255,255)
			return
		else
			setElementData(player,"builder",true)
			setPlayerMoney(player,money - 200000)
			outputChatBox("Purchase Complete!",player,0,255,255)
			setElementData(player,"purchase",false)
			for _,p in ipairs(getElementsByType("player")) do
				outputChatBox(getPlayerName(player).." has bought a Mappass for $200,000!",p,0,255,255)
			end
		end
	elseif (getElementData(player,"purchase") == "flypass") then
		if ((money - 200000) < 0) then
			outputChatBox("You do not have enough money for this item!",player,0,255,255)
			return
		else
			setElementData(player,"flypass",true)
			setPlayerMoney(player,money - 200000)
			outputChatBox("Purchase Complete!",player,0,255,255)
			setElementData(player,"purchase",false)
			for _,p in ipairs(getElementsByType("player")) do
				outputChatBox(getPlayerName(player).." has bought a Flypass for $200,000!",p,0,255,255)
			end
		end
	elseif (getElementData(player,"purchase") == "bbpass") then
		if ((money - 200000) < 0) then
			outputChatBox("You do not have enough money for this item!",player,0,255,255)
			return
		else
			setElementData(player,"bbullet",true)
			setPlayerMoney(player,money - 200000)
			outputChatBox("Purchase Complete!",player,0,255,255)
			setElementData(player,"purchase",false)
			for _,p in ipairs(getElementsByType("player")) do
				outputChatBox(getPlayerName(player).." has bought a bbpass for $200,000!",p,0,255,255)
			end
		end
	elseif (getElementData(player,"purchase") == "ggunpass") then
		if ((money - 200000) < 0) then
			outputChatBox("You do not have enough money for this item!",player,0,255,255)
			return
		else
			setElementData(player,"ggunallow",true)
			setPlayerMoney(player,money - 200000)
			outputChatBox("Purchase Complete!",player,0,255,255)
			setElementData(player,"purchase",false)
			for _,p in ipairs(getElementsByType("player")) do
				outputChatBox(getPlayerName(player).." has bought Ggunpass for $200,000!",p,0,255,255)
			end
		end
	elseif (getElementData(player,"purchase") == "minigun") then
		if ((money - 100000) < 0) then
			outputChatBox("You do not have enough money for this item!",player,0,255,255)
			return
		else
			giveWeapon(player,38,1000)
			setPlayerMoney(player,money - 100000)
			outputChatBox("Purchase Complete!",player,0,255,255)
			setElementData(player,"purchase",false)
			for _,p in ipairs(getElementsByType("player")) do
				outputChatBox(getPlayerName(player).." has bought 1000 Minigun for $100,000!",p,0,255,255)
			end
		end
	elseif (getElementData(player,"purchase") == "rocket") then
		if ((money - 20000) < 0) then
			outputChatBox("You do not have enough money for this item!",player,0,255,255)
			return
		else
			giveWeapon(player,35,10)
			setPlayerMoney(player,money - 20000)
			outputChatBox("Purchase Complete!",player,0,255,255)
			setElementData(player,"purchase",false)
			for _,p in ipairs(getElementsByType("player")) do
				outputChatBox(getPlayerName(player).." has bought 10 Rocket for $10,000!",p,0,255,255)
			end
		end
	elseif (getElementData(player,"purchase") == "hsrocket") then
		if ((money - 80000) < 0) then
			outputChatBox("You do not have enough money for this item!",player,0,255,255)
			return
		else
			giveWeapon(player,36,10)
			setPlayerMoney(player,money - 80000)
			outputChatBox("Purchase Complete!",player,0,255,255)
			setElementData(player,"purchase",false)
			for _,p in ipairs(getElementsByType("player")) do
				outputChatBox(getPlayerName(player).." has bought 10 HsRocket for $80,000!",p,0,255,255)
			end
		end
	elseif (getElementData(player,"purchase") == "rhino") then
		if ((money - 500000) < 0) then
			outputChatBox("You do not have enough money for this item!",player,0,255,255)
			return
		else
			local x,y,z = getElementPosition(player)
			personalCar[player] = createVehicle(432,x,y,z+1.2)
			warpPedIntoVehicle(player,personalCar[player])
			setPlayerMoney(player,money - 500000)
			outputChatBox("Purchase Complete!",player,0,255,255)
			setElementData(player,"purchase",false)
			for _,p in ipairs(getElementsByType("player")) do
				outputChatBox(getPlayerName(player).." has bought a Rhino for $500,000!",p,0,255,255)
			end
		end
	elseif (getElementData(player,"purchase") == "hydra") then
		if ((money - 600000) < 0) then
			outputChatBox("You do not have enough money for this item!",player,0,255,255)
			return
		else
			local x,y,z = getElementPosition(player)
			personalCar[player] = createVehicle(520,x,y,z+1.2)
			warpPedIntoVehicle(player,personalCar[player])
			setPlayerMoney(player,money - 600000)
			outputChatBox("Purchase Complete!",player,0,255,255)
			setElementData(player,"purchase",false)
			for _,p in ipairs(getElementsByType("player")) do
				outputChatBox(getPlayerName(player).." has bought a Hydra for $600,000!",p,0,255,255)
			end
		end
	elseif (getElementData(player,"purchase") == "hunter") then
		if ((money - 600000) < 0) then
			outputChatBox("You do not have enough money for this item!",player,0,255,255)
			return
		else
			local x,y,z = getElementPosition(player)
			personalCar[player] = createVehicle(425,x,y,z+1.2)
			warpPedIntoVehicle(player,personalCar[player])
			setPlayerMoney(player,money - 600000)
			outputChatBox("Purchase Complete!",player,0,255,255)
			setElementData(player,"purchase",false)
			for _,p in ipairs(getElementsByType("player")) do
				outputChatBox(getPlayerName(player).." has bought a Hunter for $600,000!",p,0,255,255)
			end
		end
	elseif (getElementData(player,"purchase") == "ssparrow") then
		if ((money - 400000) < 0) then
			outputChatBox("You do not have enough money for this item!",player,0,255,255)
			return
		else
			local x,y,z = getElementPosition(player)
			personalCar[player] = createVehicle(447,x,y,z+1.2)
			warpPedIntoVehicle(player,personalCar[player])
			setPlayerMoney(player,money - 400000)
			outputChatBox("Purchase Complete!",player,0,255,255)
			setElementData(player,"purchase",false)
			for _,p in ipairs(getElementsByType("player")) do
				outputChatBox(getPlayerName(player).." has bought a Sea Sparrow for $400,000!",p,0,255,255)
			end
		end
	end
end
addCommandHandler("confirm",confirm)

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