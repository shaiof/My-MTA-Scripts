local sx,sy = guiGetScreenSize()

addEventHandler('onClientRenter',root,function()
	dxDrawImage(0,0,sx,sy,'mainMenu.png')
end)