-------------------------- Configuration --------------------------
key = "O"
-------------------------------------------------------------------
local root = getRootElement()
local localPlayer = getLocalPlayer()

GUIEditor = {
    tab = {},
    label = {},
    tabpanel = {},
    edit = {},
    gridlist = {},
    column = {},
    window = {},
    button = {},
    memo = {}
}

GUIEditor.window[1] = guiCreateWindow(1041, 235, 309, 501, "Phone", false)
guiWindowSetSizable(GUIEditor.window[1], false)
GUIEditor.tabpanel[1] = guiCreateTabPanel(9, 10, 291, 482, false, GUIEditor.window[1])
GUIEditor.tab[1] = guiCreateTab("Contacts", GUIEditor.tabpanel[1])
GUIEditor.gridlist[1] = guiCreateGridList(0, 0, 291, 401, false, GUIEditor.tab[1])
GUIEditor.column[1] = guiGridListAddColumn(GUIEditor.gridlist[1], "Players", 0.9)
GUIEditor.button[1] = guiCreateButton(0, 411, 145, 37, "Call", false, GUIEditor.tab[1])
guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[2] = guiCreateButton(145, 411, 145, 37, "Message", false, GUIEditor.tab[1])
guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFAAAAAA")
GUIEditor.tab[2] = guiCreateTab("Messages", GUIEditor.tabpanel[1])
GUIEditor.gridlist[2] = guiCreateGridList(0, 0, 291, 365, false, GUIEditor.tab[2])
guiGridListAddColumn(GUIEditor.gridlist[2], "Messages", 0.9)
GUIEditor.button[3] = guiCreateButton(0, 419, 291, 34, "Delete", false, GUIEditor.tab[2])
guiSetProperty(GUIEditor.button[3], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[4] = guiCreateButton(0, 375, 145, 34, "Reply", false, GUIEditor.tab[2])
guiSetProperty(GUIEditor.button[4], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[5] = guiCreateButton(145, 375, 145, 34, "Forward", false, GUIEditor.tab[2])
guiSetProperty(GUIEditor.button[5], "NormalTextColour", "FFAAAAAA")
GUIEditor.tab[3] = guiCreateTab("Calls", GUIEditor.tabpanel[1])
GUIEditor.button[6] = guiCreateButton(0, 420, 142, 34, "Call Back", false, GUIEditor.tab[3])
guiSetProperty(GUIEditor.button[6], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[7] = guiCreateButton(142, 420, 149, 34, "Message", false, GUIEditor.tab[3])
guiSetProperty(GUIEditor.button[7], "NormalTextColour", "FFAAAAAA")
GUIEditor.gridlist[3] = guiCreateGridList(0, 0, 291, 410, false, GUIEditor.tab[3])
guiGridListAddColumn(GUIEditor.gridlist[3], "Calls", 0.9)

GUIEditor.window[2] = guiCreateWindow(432, 235, 496, 430, "Messaging - Reply", false)
guiWindowSetSizable(GUIEditor.window[2], false)
GUIEditor.label[1] = guiCreateLabel(10, 20, 476, 29, "Messaging:", false, GUIEditor.window[2])
guiSetFont(GUIEditor.label[1], "default-bold-small")
guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
GUIEditor.memo[1] = guiCreateMemo(9, 49, 477, 152, "", false, GUIEditor.window[2])
guiMemoSetReadOnly(GUIEditor.memo[1], true)
GUIEditor.memo[2] = guiCreateMemo(9, 211, 477, 152, "", false, GUIEditor.window[2])
guiMemoSetReadOnly(GUIEditor.memo[2], true)
GUIEditor.button[8] = guiCreateButton(10, 375, 238, 45, "Send", false, GUIEditor.window[2])
guiSetProperty(GUIEditor.button[8], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[9] = guiCreateButton(248, 375, 238, 45, "Close", false, GUIEditor.window[2])
guiSetProperty(GUIEditor.button[9], "NormalTextColour", "FFAAAAAA")

GUIEditor.window[3] = guiCreateWindow(432, 235, 496, 430, "Messaging - New", false)
guiWindowSetSizable(GUIEditor.window[3], false)
GUIEditor.label[2] = guiCreateLabel(10, 19, 66, 28, "Send To: ", false, GUIEditor.window[3])
guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
GUIEditor.edit[1] = guiCreateEdit(76, 19, 410, 28, "", false, GUIEditor.window[3])
GUIEditor.memo[3] = guiCreateMemo(9, 47, 477, 323, "", false, GUIEditor.window[3])
GUIEditor.button[10] = guiCreateButton(9, 380, 239, 40, "Send", false, GUIEditor.window[3])
guiSetProperty(GUIEditor.button[10], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[11] = guiCreateButton(247, 380, 239, 40, "Discard", false, GUIEditor.window[3])
guiSetProperty(GUIEditor.button[11], "NormalTextColour", "FFAAAAAA")

GUIEditor.window[4] = guiCreateWindow(784, 14, 257, 122, "Call", false)
guiWindowSetSizable(GUIEditor.window[4], false)
GUIEditor.label[3] = guiCreateLabel(0, 19, 257, 26, "Active", false, GUIEditor.window[4])
guiSetFont(GUIEditor.label[3], "default-bold-small")
guiLabelSetColor(GUIEditor.label[3], 55, 227, 15)
guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", false)
guiLabelSetVerticalAlign(GUIEditor.label[3], "bottom")
GUIEditor.button[12] = guiCreateButton(9, 54, 120, 57, "Mute", false, GUIEditor.window[4])
guiSetProperty(GUIEditor.button[12], "NormalTextColour", "FFAAAAAA")
GUIEditor.button[13] = guiCreateButton(129, 54, 118, 57, "End Call", false, GUIEditor.window[4])
guiSetProperty(GUIEditor.button[13], "NormalTextColour", "FFAAAAAA")

addEventHandler("onClientResourceStart",root,function()
        guiSetVisible(GUIEditor.window[1],false)
        guiSetVisible(GUIEditor.window[2],false)
        guiSetVisible(GUIEditor.window[3],false)
        guiSetVisible(GUIEditor.window[4],false)
        showCursor(false)
end)

function showGui()
        if guiGetVisible(GUIEditor.window[1]) == false then
                guiSetVisible(GUIEditor.window[1],true)
                for i,plr in pairs(getElementsByType("player")) do
                        local row = guiGridListAddRow(GUIEditor.gridlist[1])
                        guiGridListSetItemText(GUIEditor.gridlist[1],row,GUIEditor.column[1],getPlayerName(plr),false,false)
                end
                showCursor(true)
        else
                guiSetVisible(GUIEditor.window[1],false)
                showCursor(false)
                guiGridListClear(GUIEditor.gridlist[1])
        end
end

bindKey(key,"down",showGui)

addEvent("showCall",true)
addEventHandler("showCall",root,function(callType,r,g,b)
        guiSetVisible(GUIEditor.window[4],true)
        guiSetText(GUIEditor.label[3],callType)
        guiLabelSetColor(GUIEditor.label[3],r,g,b)
end)

addEvent("endCall",true)
addEventHandler("endCall",root,function()
        setTimer(function()
                guiSetVisible(GUIEditor.window[4],false)
        end,3000,1)
end)

addEventHandler("onClientGUIClick",root,function()
        if source == GUIEditor.button[1] then
                local player = getPlayerFromName(guiGridListGetItemText(GUIEditor.gridlist[1],guiGridListGetSelectedItem(GUIEditor.gridlist[1]),1))
                triggerEvent("showCall",player,"Answer...",0,255,0)
                triggerEvent("showCall",localPlayer,"Calling...",0,255,255)
                setElementData(localPlayer,"call",getPlayerName(player))
        elseif souce == GUIEditor.button[2] then
                
        elseif souce == GUIEditor.button[3] then
                
        elseif souce == GUIEditor.button[4] then
                
        elseif souce == GUIEditor.button[5] then
                
        elseif souce == GUIEditor.button[6] then
                
        elseif souce == GUIEditor.button[7] then
                
        elseif souce == GUIEditor.button[8] then
                
        elseif souce == GUIEditor.button[9] then
                
        elseif souce == GUIEditor.button[10] then
                
        elseif souce == GUIEditor.button[11] then
                
        elseif souce == GUIEditor.button[12] then
                
        elseif source == GUIEditor.button[13] then
                local player = getPlayerFromName(getElementData(localPlayer,"call"))
                triggerEvent("showCall",player,"Call Ended...",255,0,0)
                triggerEvent("showCall",localPlayer,"Call Ended...",255,0,0)
                triggerEvent("endCall",player)
                triggerEvent("endCall",localPlayer)
        end
end)