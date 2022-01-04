addEventHandler('onClientResourceStart',resourceRoot,function()
	if main then
		guiSetVisible(main,false)
	end
end)

main = guiCreateWindow(0.62, 0.41, 0.35, 0.52, "FlowerAttach By: JohnFlower & Woovie, Panel by ShaioF", true)
guiWindowSetSizable(main, false)
scrollbar1 = guiCreateScrollBar(0.37, 0.11, 0.30, 0.04, true, true, main)
guiScrollBarSetScrollPosition(scrollbar1, 50.0)
label1 = guiCreateLabel(0.37, 0.07, 0.29, 0.04, "Position X", true, main)
guiLabelSetHorizontalAlign(label1, "center", false)
guiLabelSetVerticalAlign(label1, "center")
label2 = guiCreateLabel(0.37, 0.16, 0.29, 0.04, "Position Y", true, main)
guiLabelSetHorizontalAlign(label2, "center", false)
guiLabelSetVerticalAlign(label2, "center")
scrollbar2 = guiCreateScrollBar(0.37, 0.20, 0.30, 0.04, true, true, main)
guiScrollBarSetScrollPosition(scrollbar2, 50.0)
label3 = guiCreateLabel(0.37, 0.25, 0.29, 0.04, "Position Z", true, main)
guiLabelSetHorizontalAlign(label3, "center", false)
guiLabelSetVerticalAlign(label3, "center")
scrollbar3 = guiCreateScrollBar(0.37, 0.29, 0.30, 0.04, true, true, main)
guiScrollBarSetScrollPosition(scrollbar3, 50.0)
gridlist1 = guiCreateGridList(0.02, 0.07, 0.33, 0.61, true, main)
column1 = guiGridListAddColumn(gridlist1, "Objects", 0.9)
label4 = guiCreateLabel(0.69, 0.07, 0.29, 0.04, "Rotation X", true, main)
guiLabelSetHorizontalAlign(label4, "center", false)
guiLabelSetVerticalAlign(label4, "center")
scrollbar4 = guiCreateScrollBar(0.69, 0.11, 0.29, 0.04, true, true, main)
guiScrollBarSetScrollPosition(scrollbar4, 50.0)
label5 = guiCreateLabel(0.69, 0.16, 0.29, 0.04, "Rotation Y", true, main)
guiLabelSetHorizontalAlign(label5, "center", false)
guiLabelSetVerticalAlign(label5, "center")
scrollbar5 = guiCreateScrollBar(0.69, 0.20, 0.29, 0.04, true, true, main)
guiScrollBarSetScrollPosition(scrollbar5, 50.0)
scrollbar6 = guiCreateScrollBar(0.69, 0.29, 0.29, 0.04, true, true, main)
guiScrollBarSetScrollPosition(scrollbar6, 50.0)
label6 = guiCreateLabel(0.69, 0.25, 0.29, 0.04, "Rotation Z", true, main)
guiLabelSetHorizontalAlign(label6, "center", false)
guiLabelSetVerticalAlign(label6, "center")
button1 = guiCreateButton(0.37, 0.42, 0.30, 0.07, "Save Object Position", true, main)
guiSetProperty(button1, "NormalTextColour", "FFAAAAAA")
button2 = guiCreateButton(0.68, 0.42, 0.30, 0.07, "Delete Object", true, main)
guiSetProperty(button2, "NormalTextColour", "FFAAAAAA")
button3 = guiCreateButton(0.02, 0.73, 0.33, 0.04, "+1", true, main)
guiSetProperty(button3, "NormalTextColour", "FFAAAAAA")
edit1 = guiCreateEdit(0.02, 0.77, 0.33, 0.07, "1", true, main)
button4 = guiCreateButton(0.02, 0.85, 0.33, 0.04, "-1", true, main)
guiSetProperty(button4, "NormalTextColour", "FFAAAAAA")
edit2 = guiCreateEdit(0.60, 0.73, 0.37, 0.07, "", true, main)
button5 = guiCreateButton(0.60, 0.81, 0.37, 0.07, "Save Attach", true, main)
guiSetProperty(button5, "NormalTextColour", "FFAAAAAA")
button6 = guiCreateButton(0.60, 0.90, 0.37, 0.07, "Load Attach", true, main)
guiSetProperty(button6, "NormalTextColour", "FFAAAAAA")
radiobutton1 = guiCreateRadioButton(0.42, 0.88, 0.16, 0.04, "Enabled", true, main)
radiobutton2 = guiCreateRadioButton(0.42, 0.93, 0.16, 0.04, "Disabled", true, main)
guiRadioButtonSetSelected(radiobutton2, true)
edit3 = guiCreateEdit(0.37, 0.52, 0.30, 0.06, "", true, main)
button8 = guiCreateButton(0.37, 0.61, 0.30, 0.07, "Attach Object", true, main)
guiSetProperty(button8, "NormalTextColour", "FFAAAAAA")
button9 = guiCreateButton(0.68, 0.61, 0.30, 0.07, "Select Object", true, main)
guiSetProperty(button9, "NormalTextColour", "FFAAAAAA")
button10 = guiCreateButton(0.02, 0.89, 0.33, 0.08, "Set", true, main)
guiSetProperty(button10, "NormalTextColour", "FFAAAAAA")
label7 = guiCreateLabel(0.37, 0.33, 0.61, 0.04, "Sensitivity", true, main)
guiLabelSetHorizontalAlign(label7, "center", false)
scrollbar7 = guiCreateScrollBar(0.37, 0.37, 0.61, 0.04, true, true, main)
button11 = guiCreateButton(0.68, 0.51, 0.30, 0.07, "Clear Objects", true, main)
guiSetProperty(button11, "NormalTextColour", "FFAAAAAA")
label18 = guiCreateLabel(0.02, 0.68, 0.33, 0.04, "Scale", true, main)
guiLabelSetHorizontalAlign(label18, "center", false)
guiLabelSetVerticalAlign(label18, "center")
label19 = guiCreateLabel(0.35, 0.84, 0.25, 0.04, "Collisions", true, main)
guiLabelSetHorizontalAlign(label19, "center", false)
guiLabelSetVerticalAlign(label19, "center")

addEvent('toggleAttachPanel',true)
addEventHandler('toggleAttachPanel',root,function()
	if main then
		if guiGetVisible(main) then
			guiSetVisible(main,false)
			showCursor(false)
			unbindKey('mouse2','down',checkCursor)
			if timer1 then
				killTimer(timer1)
			end
		else
			guiSetVisible(main,true)
			showCursor(true)
			showObjects()
			bindKey('mouse2','down',checkCursor)
			timer1 = setTimer(function()
				if getKeyState('mouse1') == false then
					guiScrollBarSetScrollPosition(scrollbar1,50)
					guiScrollBarSetScrollPosition(scrollbar2,50)
					guiScrollBarSetScrollPosition(scrollbar3,50)
					guiScrollBarSetScrollPosition(scrollbar4,50)
					guiScrollBarSetScrollPosition(scrollbar5,50)
					guiScrollBarSetScrollPosition(scrollbar6,50)
				end
			end,50,0)
		end
	end
end)

addEventHandler('onClientGUIScroll',root,function()
	if source == scrollbar1 then
		sendMove('ox','gen')
	elseif source == scrollbar2 then
		sendMove('oy','gen')
	elseif source == scrollbar3 then
		sendMove('oz','gen')
	elseif source == scrollbar4 then
		sendMove('rx','rotate')
	elseif source == scrollbar5 then
		sendMove('ry','rotate')
	elseif source == scrollbar6 then
		sendMove('rz','rotate')
	end
end)

function sendMove(move,type)
	local progress = tonumber(guiScrollBarGetScrollPosition(source))
	if tonumber(guiScrollBarGetScrollPosition(scrollbar7)) < 1 then
		sensitivity = tonumber(guiScrollBarGetScrollPosition(scrollbar7))+1
	else
		sensitivity = tonumber(guiScrollBarGetScrollPosition(scrollbar7))
	end
	if type == 'rotate' then
		if progress < 50 then
			triggerServerEvent('moveObject',root,localPlayer,move,((sensitivity/18)*-1))	
		elseif progress > 50 then
			triggerServerEvent('moveObject',root,localPlayer,move,(sensitivity/18))
		end
	elseif type == 'gen' then
		if progress < 50 then
			triggerServerEvent('moveObject',root,localPlayer,move,((sensitivity/1000)*-1))
			
		elseif progress > 50 then
			triggerServerEvent('moveObject',root,localPlayer,move,(sensitivity/1000))
		end
	end
end

addEventHandler('onClientGUIClick',root,function()
	if source == button1 then
		triggerServerEvent('save',root,localPlayer)
		showObjects()
		guiRadioButtonSetSelected(radiobutton2,true)
		guiRadioButtonSetSelected(radiobutton1,false)
	elseif source == button2 then
		triggerServerEvent('destroy',root,localPlayer)
		setTimer(showObjects,2000,1)
		guiRadioButtonSetSelected(radiobutton2,true)
		guiRadioButtonSetSelected(radiobutton1,false)
	elseif source == button3 then
		local scale = tonumber(guiGetText(edit1))+1
		if scale then
			guiSetText(edit1,tostring(scale))
		end
	elseif source == button4 then
		local scale = tonumber(guiGetText(edit1))-1
		if scale then
			guiSetText(edit1,tostring(scale))
		end
	elseif source == button5 then
		triggerServerEvent('saveAttach',root,localPlayer,_,guiGetText(edit2))
		showObjects()
	elseif source == button6 then
		triggerServerEvent('loadAttach',root,localPlayer,_,guiGetText(edit2),_,localPlayer)
		showObjects()
		guiRadioButtonSetSelected(radiobutton2,true)
		guiRadioButtonSetSelected(radiobutton1,false)
	elseif source == button8 then
		local objectid = tonumber(guiGetText(edit3))
		if objectid then
			triggerServerEvent('attachObject',root,localPlayer,_,objectid)
		end
		guiRadioButtonSetSelected(radiobutton2,true)
		guiRadioButtonSetSelected(radiobutton1,false)
		setTimer(showObjects,2000,1)
	elseif source == button9 then
		local item = guiGridListGetSelectedItem(gridlist1)
		if item then
			triggerServerEvent('asel',root,localPlayer,_,tonumber(item))
		end
		guiRadioButtonSetSelected(radiobutton2,true)
		guiRadioButtonSetSelected(radiobutton1,false)
	elseif source == button10 then
		local scale = tonumber(guiGetText(edit1))
		if scale then
			triggerServerEvent('scale',root,localPlayer,_,scale)
		end
	elseif source == button11 then
		triggerServerEvent('dee',root,localPlayer)
		setTimer(showObjects,2000,1)
		guiRadioButtonSetSelected(radiobutton2,true)
		guiRadioButtonSetSelected(radiobutton1,false)
	elseif source == radiobutton1 then
		triggerServerEvent('col',root,localPlayer,_,"1")
	elseif source == radiobutton2 then
		triggerServerEvent('col',root,localPlayer,_,"0")
	end
end)

function checkCursor()
	if isCursorShowing() then
		showCursor(false)
	else
		showCursor(true)
	end
end

function showObjects()
	guiGridListClear(gridlist1)
	for i,v in pairs(getAttachedElements(getPedOccupiedVehicle(localPlayer))) do
		local id = getElementModel(v)
		local row = guiGridListAddRow(gridlist1)
		guiGridListSetItemText(gridlist1,row,column1,tostring(i-1).."-"..tostring(id),false,false)
	end
end