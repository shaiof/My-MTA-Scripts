local command = 'hpanel'
local showing = false
local alpha = 0
local text = ''

main = guiCreateWindow(0.28,0.14,0.41,0.58,"Hpanel - Fencsk's Freeroam",true)
guiWindowSetSizable(main,false)
x1edit = guiCreateEdit(0.58,0.06,0.40,0.06,"x1",true,main)
y1edit = guiCreateEdit(0.58,0.14,0.40,0.06,"y1",true,main)
z1edit = guiCreateEdit(0.58,0.23,0.40,0.06,"z1",true,main)
x2edit = guiCreateEdit(0.58,0.32,0.40,0.06,"x2",true,main)
y2edit = guiCreateEdit(0.58,0.40,0.40,0.06,"y2",true,main)
z2edit = guiCreateEdit(0.58,0.49,0.40,0.06,"z2",true,main)
getPos1Button = guiCreateButton(0.40,0.14,0.16,0.06,"Get Pos",true,main)
guiSetProperty(getPos1Button,"NormalTextColour","FFAAAAAA")
getPos2Button = guiCreateButton(0.41,0.40,0.16,0.06,"Get Pos",true,main)
guiSetProperty(getPos2Button,"NormalTextColour","FFAAAAAA")
memo = guiCreateMemo(0.02,0.07,0.37,0.48,"This is the new house system made by Shaio Fencski, use the Get Pos buttons to get the position of your player. The first 3 boxes are for your enter and the second 3 box's are for your exit. The rest is self explainitory\n\nPress RightClick to enable/disable mouse.",true,main)
guiMemoSetReadOnly(memo,true)
priceEdit = guiCreateEdit(0.02,0.66,0.37,0.07,"price",true,main)
priceLabel = guiCreateLabel(0.02,0.61,0.37,0.05,"Price",true,main)
guiLabelSetHorizontalAlign(priceLabel,"center",false)
guiLabelSetVerticalAlign(priceLabel,"center")
houseIdEdit = guiCreateEdit(0.02,0.81,0.37,0.07,"houseid",true,main)
houseIdLabel = guiCreateLabel(0.02,0.76,0.37,0.05,"House ID",true,main)
guiLabelSetHorizontalAlign(houseIdLabel,"center",false)
guiLabelSetVerticalAlign(houseIdLabel,"center")
dimensionEdit = guiCreateEdit(0.40,0.66,0.37,0.07,"dimension",true,main)
dimensionLabel = guiCreateLabel(0.40,0.61,0.37,0.05,"Dimension",true,main)
guiLabelSetHorizontalAlign(dimensionLabel,"center",false)
guiLabelSetVerticalAlign(dimensionLabel,"center")
createHouseButton = guiCreateButton(0.02,0.90,0.16,0.06,"Create",true,main)
guiSetProperty(createHouseButton,"NormalTextColour","FFAAAAAA")
closeButton = guiCreateButton(0.78,0.58,0.21,0.39,"Close",true,main)
guiSetProperty(closeButton, "NormalTextColour","FFAAAAAA")
houseRadio = guiCreateRadioButton(0.41,0.81,0.32,0.03,"House",true,main)
guiRadioButtonSetSelected(houseRadio,true)
garageRadio = guiCreateRadioButton(0.41,0.87,0.32,0.03,"Garage",true,main)

local sx,sy = guiGetScreenSize()
addEventHandler("onClientRender",root,function()
    dxDrawRectangle(sx*0.1971,sy*0,sx*0.5610,sy*0.0560,tocolor(0,0,0,alpha),false)
    dxDrawText(text,sx*0.1971,sy*0,sx*0.7581,sy*0.0560,tocolor(254,0,0,254),1.00,"bankgothic","center","center",false,false,false,false,false)
	if guiRadioButtonGetSelected(houseRadio) then
		guiSetText(priceLabel,'Price')
		guiSetText(houseIdLabel,'House ID')
		guiSetEnabled(dimensionEdit,true)
	elseif guiRadioButtonGetSelected(garageRadio) then
		guiSetText(priceLabel,'Made House ID')
		guiSetText(houseIdLabel,'Garage ID')
		guiSetEnabled(dimensionEdit,false)
	end
	if getElementData(localPlayer,'onHouse') == true then
		if getElementData(localPlayer,'ownerHouse') == 'none' then
			dxDrawText("House Info\nOwner: "..getElementData(localPlayer,'ownerHouse').."\nPrice: "..getElementData(localPlayer,'priceHouse').."\nGarage: "..getElementData(localPlayer,'garage').."\nType /buy to buy this house.",sx*0.6890,sy*0.3424,sx*0.9809,sy*0.5729,tocolor(255,255,255,255),1.00,"default","left","top",false,false,false,false,false)
		else
			dxDrawText("House Info\nOwner: "..getElementData(localPlayer,'ownerHouse').."\nPrice: "..getElementData(localPlayer,'priceHouse').."\nGarage: "..getElementData(localPlayer,'garage').."\nType /enter to enter this house\n(this will only work for permitted players!)",sx*0.6890,sy*0.3424,sx*0.9809,sy*0.5729,tocolor(255,255,255,255),1.00,"default","left","top",false,false,false,false,false)
		end
	end
end)

addEventHandler('onClientResourceStart',resourceRoot,function()
	guiSetVisible(main,false)
end)

function toggleCursor()
	if isCursorShowing() then
		showCursor(false)
		toggleAllControls(true)
	else
		showCursor(true)
		toggleAllControls(false)
	end
end

function showGui(cmd)
	local isOpen = guiGetVisible(main)
	if isOpen == true then
		unbindKey('mouse2','down',toggleCursor)
		guiSetVisible(main,false)
		showCursor(false)
		toggleAllControls(true)
	elseif isOpen == false then
		bindKey('mouse2','down',toggleCursor)
		guiSetVisible(main,true)
		showCursor(true)
		toggleAllControls(false)
	end
end
addCommandHandler(command,showGui)

function checkAllFeildsHouse()
	if tonumber(guiGetText(x1edit)) and tonumber(guiGetText(y1edit)) and tonumber(guiGetText(z1edit)) and tonumber(guiGetText(x2edit)) and tonumber(guiGetText(y2edit)) and tonumber(guiGetText(z2edit)) and tonumber(guiGetText(priceEdit)) and tonumber(guiGetText(houseIdEdit)) and tonumber(guiGetText(dimensionEdit)) then
		if tonumber(guiGetText(dimensionEdit)) < 65536 and tonumber(guiGetText(dimensionEdit)) > 0 then
			if tonumber(guiGetText(houseIdEdit)) < 19 and tonumber(guiGetText(houseIdEdit)) > -1 then
				return true
			else
				if showing == false then
					alpha = 100
					text = 'Invalid Information'
					showing = true
					setTimer(function()
						alpha = 0
						text = ''
						showing = false
					end,3000,1)
				end
				return false
			end
		else
			if showing == false then
				alpha = 100
				text = 'Invalid Information'
				showing = true
				setTimer(function()
					alpha = 0
					text = ''
					showing = false
				end,3000,1)
			end
			return false
		end
	else
		if showing == false then
			alpha = 100
			text = 'Invalid Information'
			showing = true
			setTimer(function()
				alpha = 0
				text = ''
				showing = false
			end,3000,1)
		end
		return false
	end
end

function checkAllFeildsHouse()
	if tonumber(guiGetText(x1edit)) and tonumber(guiGetText(y1edit)) and tonumber(guiGetText(z1edit)) and tonumber(guiGetText(x2edit)) and tonumber(guiGetText(y2edit)) and tonumber(guiGetText(z2edit)) and tonumber(guiGetText(priceEdit)) and tonumber(guiGetText(houseIdEdit)) then
		return true
	else
		if showing == false then
			alpha = 100
			text = 'Invalid Information'
			showing = true
			setTimer(function()
				alpha = 0
				text = ''
				showing = false
			end,3000,1)
		end
		return false
	end
end

addEventHandler('onClientGUIClick',root,function()
	if source == getPos1Button then
		local x,y,z = getElementPosition(localPlayer)
		guiSetText(x1edit,x)
		guiSetText(y1edit,y)
		guiSetText(z1edit,z)
	elseif source == getPos2Button then
		local x,y,z = getElementPosition(localPlayer)
		guiSetText(x2edit,x)
		guiSetText(y2edit,y)
		guiSetText(z2edit,z)
	elseif source == createHouseButton then
		if guiRadioButtonGetSelected(houseRadio) then
			if checkAllFeildsHouse() == true then
				triggerServerEvent('createHouse',root,guiGetText(x1edit),guiGetText(y1edit),guiGetText(z1edit),guiGetText(x2edit),guiGetText(y2edit),guiGetText(z2edit),guiGetText(priceEdit),guiGetText(houseIdEdit),guiGetText(dimensionEdit))
			end
		elseif guiRadioButtonGetSelected(garageRadio) then
			if checkAllFeildsGarage() == true then	
				triggerServerEvent('createGarage',root,guiGetText(x1edit),guiGetText(y1edit),guiGetText(z1edit),guiGetText(x2edit),guiGetText(y2edit),guiGetText(z2edit),guiGetText(priceEdit),guiGetText(houseIdEdit))
			end
		end
	elseif source == closeButton then
		unbindKey('mouse2','down',toggleCursor)
		guiSetVisible(main,false)
		showCursor(false)
		toggleAllControls(true)
	end
end)