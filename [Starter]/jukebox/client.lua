styles = {}
styles['button'] = {
	['default'] = {
		color = tocolor(255,0,0,255),
		textColor = tocolor(0,0,0,255),
		hoverColor = tocolor(255,0,0,180),
		clickColor = tocolor(255,0,0,255),
		oldColor = tocolor(255,0,0,255),
		textAlignX = 'center',
		textAlignY = 'center',
		textSize = 1,
		textFont = 'default-bold',
	}
}

styles['window'] = {
	['default'] = {
		textColor = tocolor(0,0,0,255),
		textAlignX = 'center',
		textAlignY = 'center',
		textSize = 1,
		textFont = 'default',
		textBarColor = tocolor(255,255,255,255),
		mainColor = tocolor(0,0,0,150),
		borderWidth = 4,
		textHeight = 15
	}
}

styles['progressbar'] = {
	['default'] = {
		bgColor = tocolor(0,0,0,180),
		barColor = tocolor(255,255,255,200)
	}
}

styles['checkbox'] = {
	['default'] = {
		bgColor = tocolor(255,255,255,255),
		selectColor = tocolor(0,255,255,255),
		textColor = tocolor(0,0,0,255),
		textSize = 1,
		textFont = 'default-bold',
		textAlignX = 'left',
		textAlignY = 'center',
		selectedReduction = 3
	}
}

styles['radiobutton'] = {
	['default'] = {
		bgColor = tocolor(255,255,255,255),
		selectColor = tocolor(0,255,190,255),
		textColor = tocolor(0,0,0,255),
		textSize = 1,
		textFont = 'default-bold',
		textAlignX = 'left',
		textAlignY = 'center',
		selectedReduction = 3
	}
}

styles['textbox'] = {
	['default'] = {
		divideWidth = 50,
		bgColor = tocolor(255,255,255,255),
		textColor = tocolor(0,0,0,255),
		textSize = 1,
		textFont = 'default',
		textAlignX = 'center',
		textAlignY = 'center'
	}
}

local sx,sy = guiGetScreenSize()
local sw,sh = 1366,768
local draw = {}
local validTypes = {'window','button','gridlist','progressbar','checkbox','radiobutton','textbox'}

function dxRect(...)
	arg[1],arg[2],arg[3],arg[4] = arg[1]/sw*sx,arg[2]/sh*sy,arg[3]/sw*sx,arg[4]/sh*sy
	return dxDrawRectangle(unpack(arg))
end

function dxImage(...)
	arg[1],arg[2],arg[3],arg[4] = arg[1]/sw*sx,arg[2]/sh*sy,arg[3]/sw*sx,arg[4]/sh*sy
	return dxDrawImage(unpack(arg))
end

function dxText(...)
	arg[2],arg[3],arg[4],arg[5],arg[7] = arg[2]/sw*sx,arg[3]/sh*sy,(arg[4]+arg[2])/sw*sx,(arg[5]+arg[3])/sh*sy,(arg[7] or 1)/sw*sx
	return dxDrawText(unpack(arg))
end

function isMouseIn(x,y,w,h)
	local cx,cy = getCursorPosition()
	if cx and cy then
		cx,cy = cx*sx,cy*sy
		if cx > x/sw*sx and cx < (x/sw*sx)+(w/sw*sx) and cy > (y/sh*sy) and cy < (y/sh*sy)+(h/sh*sy) then
			return true
		end
	end
	return false
end

function getOnTop()
	local onTop = {}
	for i=1,#draw do
		local item = draw[i]
		if item.mouseOver() then
			table.insert(onTop,item)
		else
			item.onTop = false
		end
	end
	if onTop[1] then
		return onTop[1]
	end
	return false
end

function dx(type,theme,x,y,w,h,visible)
	for i=1,#validTypes do
		if type == validTypes[i] then
			local self = {}
			self.type = type
			self.x = x or 0
			self.y = y or 0
			self.w = w or 0
			self.h = h or 0
			self.style = styles[self.type][theme] or styles[self.type]['default'] 
			self.visible = visible or true
			self.children = {}
			self.parent = false
			self.onTop = false
			
			function self.setOnTop()
				for i=1,#draw do
					local item = draw[i]
					if item == self then
						table.remove(draw,i)
						table.insert(draw,1,self)
						item.onTop = true
					end
					if not item == self then
						item.onTop = false
					end
				end
			end
			
			function self.setParent(parent)
				table.insert(parent.children,self)
				self.parent = parent
			end
			
			function self.destroy()
				for i=1,#draw do
					local item = draw[i]
					if item == self then
						item.children = {}
						table.remove(draw,i)
					end
				end
			end
			
			function self.onHover()
				if self.type == 'button' then
					if self.mouseOver() then
						if getKeyState('mouse1') then
							self.color = self.clickColor
						else
							self.color = self.hoverColor
						end
					else
						self.color = self.oldColor
					end
				end
			end
			
			function self.mouseOver()
				return isMouseIn(self.x,self.y,self.w,self.h)
			end
			
			return self
		end
	end
	
	local elem = getOnTop()
	if elem then
		elem.setOnTop()
	end
	
	return false
end

function dxCreateProgressBar(x,y,w,h)
	local self = dx('progressbar','default',x,y,w,h,true)
	if self then
		self.progress = 0
		self.bgColor = self.style.bgColor
		self.barColor = self.style.barColor
		
		function self.draw()
			dxRect(self.x,self.y,self.w,self.h,self.bgColor)
			dxRect(self.x,self.y,(self.w/100)*self.progress,self.h,self.barColor)
		end
		
		table.insert(draw,self)
		return self
	end
end

function dxCreateCheckbox(text,x,y,w,h)
	local self = dx('checkbox','default',x,y,w,h,true)
	if self then
		self.text = text
		self.bgColor = self.style.bgColor
		self.selectColor = self.style.selectColor
		self.textColor = self.style.textColor
		self.textSize = self.style.textSize
		self.textFont = self.style.textFont
		self.textAlignX = self.style.textAlignX
		self.textAlignY = self.style.textAlignY
		self.selectedReduction = self.style.selectedReduction
		self.showText = true
		self.selected = false
		
		function self.draw()
			dxRect(self.x,self.y,self.h,self.h,self.bgColor)
			if self.selected then
				dxRect(self.x+self.selectedReduction,self.y+self.selectedReduction,self.h-(self.selectedReduction*2),self.h-(self.selectedReduction*2),self.selectColor)
			end
			if self.showText then
				dxText(self.text,self.x+self.h+4,self.y,self.w,self.h,self.textColor,self.textSize,self.textFont,self.textAlignX,self.textAlignY,true)
			end
		end
		
		function self.onClick()
			if isMouseIn(self.x,self.y,self.h,self.h) then
				self.selected = not self.selected
			end
		end
		
		table.insert(draw,self)
		return self
	end
end

function dxCreateRadioButton(text,x,y,w,h)
	local self = dx('radiobutton','default',x,y,w,h,true)
	if self then
		self.text = text
		self.bgColor = self.style.bgColor
		self.selectColor = self.style.selectColor
		self.textColor = self.style.textColor
		self.textSize = self.style.textSize
		self.textFont = self.style.textFont
		self.textAlignX = self.style.textAlignX
		self.textAlignY = self.style.textAlignY
		self.selectedReduction = self.style.selectedReduction
		self.showText = true
		self.selected = false
		
		function self.draw()
			dxRect(self.x,self.y,self.h,self.h,self.bgColor)
			if self.selected then
				dxRect(self.x+self.selectedReduction,self.y+self.selectedReduction,self.h-(self.selectedReduction*2),self.h-(self.selectedReduction*2),self.selectColor)
			end
			if self.showText then
				dxText(self.text,self.x+self.h+4,self.y,self.w,self.h,self.textColor,self.textSize,self.textFont,self.textAlignX,self.textAlignY,true)
			end
		end
		
		function self.onClick()
			for i=1,#draw do
				local item = draw[i]
				if item.type == 'radiobutton' then
					item.selected = false
				end
			end
			self.selected = true
		end
		
		table.insert(draw,self)
		return self
	end
end

function dxCreateTextbox(text,x,y,w,h)
	local self = dx('textbox','default',x,y,w,h,true)
	if self then
		self.text = text
		self.bgColor = self.style.bgColor
		self.textColor = self.style.textColor
		self.textSize = self.style.textSize
		self.textFont = self.style.textFont
		self.textAlignX = self.style.textAlignX
		self.textAlignY = self.style.textAlignY
		self.divideWidth = self.style.divideWidth
		self.passwordBox = false
		local Timer = nil
		
		function self.draw()
			dxRect(self.x,self.y,self.w,self.h,self.bgColor)
			if self.passwordBox then
				local newText = string.rep('*',string.len(self.text))
				dxText(newText,self.x,self.y,self.w,self.h,self.textColor,self.textSize,self.textFont,self.textAlignX,self.textAlignY,true)
			else
				dxText(self.text,self.x,self.y,self.w,self.h,self.textColor,self.textSize,self.textFont,self.textAlignX,self.textAlignY,true)
			end
		end
		
		function self.onChar(character)
			if self.onTop then
				if dxGetTextWidth(self.text..character,self.textSize,self.textFont)+self.divideWidth < self.w then
					self.text = self.text..character
				end
			end
		end
		
		function self.onKey(key,state)
			if self.onTop then
				if key == 'backspace' then
					if state then
						Timer = setTimer(function()
							if string.len(self.text) > 0 then
								self.text = string.sub(self.text,1,string.len(self.text)-1)
							end
						end,80,0)
					else
						if isTimer(Timer) then
							killTimer(Timer)
						end
					end
				end
			end
		end
		
		table.insert(draw,self)
		return self
	end
end

function dxCreateButton(text,x,y,w,h)
	local self = dx('button','default',x,y,w,h,true)
	if self then
		self.text = text
		self.color = self.style.color
		self.textColor = self.style.textColor
		self.hoverColor = self.style.hoverColor
		self.clickColor = self.style.clickColor
		self.oldColor = self.style.oldColor
		self.textSize = self.style.textSize
		self.textFont = self.style.textFont
		self.textAlignX = self.style.textAlignX
		self.textAlignY = self.style.textAlignY
		self.onClick = func or function() end
		
		function self.draw()
			self.dragArea = {self.x,self.y,self.w,self.h}
			dxRect(self.x,self.y,self.w,self.h,self.color)
			dxText(self.text,self.x,self.y,self.w,self.h,self.textColor,self.textSize,self.textFont,self.textAlignX,self.textAlignY,true)
			if self.onTop then
				self.onHover()
			end
		end
		
		table.insert(draw,self)
		return self
	end
end

function dxCreateGridlist(x,y,w,h)
	local self = dx('gridlist','default',x,y,w,h)
	if self then
		self.itemHeight = 15
		self.maxItems = math.floor(self.h/self.itemHeight)
		self.bgColor = tocolor(0,0,0,180)
		self.textColor = tocolor(255,255,255,200)
		self.startPos = 1
		self.endPos = 20
		self.itemSpacing = 8
		self.selected = 1
		self.items = {}
		
		function self.draw()
			self.dragArea = {self.x,self.y,self.w,self.h}
			self.endPos = self.startPos+self.maxItems
			local yOff = 0
			for i=self.startPos,self.endPos do
				if self.items[i] then
					dxRect(self.x,self.y+yOff,self.w,self.itemHeight-self.itemSpacing,self.bgColor)
					dxText(self.items[i].text,self.x,self.y+yOff,self.w,self.itemHeight-self.itemSpacing,self.textColor)
					yOff = yOff+((self.itemHeight))+self.itemSpacing
				end
			end
		end
		
		function self.addItem(text)
			local item = {}
			item.text = text
			table.insert(self.items,item)
		end
		
		function self.itemsClear()
			for k=1,#self.items do
				table.remove(self.items,k)
			end
		end
		
		function self.onKey(key,state)
			if state then
				if key == 'arrow_u' then
					self.selected = self.selected-1
					if self.selected < 1 then
						self.selected = #self.items
					end
				elseif key == 'arrow_d' then
					self.selected = self.selected+1
					if self.selected > #self.items then
						self.selected = 1
					end
				end
			end
		end
		
		table.insert(draw,self)
		return self
	end
end

addEventHandler('onClientKey',root,function(key,state)
	for i=1,#draw do
		local item = draw[i]
		if item.onTop then
			if key == 'enter' and state then
				if (item.onKeyReturn and type(item.onKeyReturn) == 'function') then
					item.onKeyReturn()
				end
			end
			if (item.onKey and type(item.onKey) == 'function') then
				item.onKey(key,state)
			end
		end
	end
end)

addEventHandler('onClientCharacter',root,function(character)
	for i=1,#draw do
		local item = draw[i]
		if item.onTop then
			if (item.onChar and type(item.onChar) == 'function') then
				item.onChar(character)
			end
		end
	end
end)

addEventHandler('onClientClick',root,function(btn,state)
	if btn == 'left' then
		if state == 'down' then
			local elem = getOnTop()
			if elem then
				elem.setOnTop()
			end
			for i=1,#draw do
				local item = draw[i]
				if item.mouseOver() then
					if (item.onClick and type(item.onClick) == 'function' and item.onTop) then
						item.onClick()
					end
				end
			end
		end
	end
end)

addEventHandler('onClientRender',root,function()
	for i=#draw,1,-1 do
		local parent = draw[i]
		if parent.visible and not parent.parent then
			parent.draw()
			
			if parent.type == 'textbox' and parent.onTop then
				toggleAllControls(false)
			else
				toggleAllControls(true)
			end
			
			for j=1,#parent.children do
				local child = parent.children[j]
				if child.visible then
					child.draw()
					child.onTop = child.parent.onTop
				end
			end
		end
	end
end)


function createJukeboxAlert(text)
	local self = {}
	self.text = text
	self.visible = true
	self.children = {}
	self.parent = false
	self.onTop = false
	self.x = 0
	self.y = 0
	self.w = 0
	self.h = 0
	
	self.button1 = dxCreateButton('Yes',self.x+6,self.y+(self.h-20),(self.w/2)-8,self.h-(self.h-16))
	self.button1.setParent(self)
	function self.button1.onClick()
		self.visible = false
	end
	
	self.button2 = dxCreateButton('No',(self.x+(self.w/2))+2,self.y+(self.h-20),(self.w/2)-8,self.h-(self.h-16))
	self.button2.setParent(self)
	function self.button2.onClick()
		self.visible = false
	end
	
	function self.setOnTop()
		for i=1,#draw do
			local item = draw[i]
			if item == self then
				table.remove(draw,i)
				table.insert(draw,1,self)
				item.onTop = true
			end
			if not item == self then
				item.onTop = false
			end
		end
	end
	
	function self.destroy()
		for i=1,#draw do
			local item = draw[i]
			if item == self then
				item.children = {}
				table.remove(draw,i)
			end
		end
	end
	
	function self.draw()
		self.textWidth = dxGetTextWidth(self.text,1,'default')
		self.textWidth = self.textWidth+8
		if self.textWidth > sx then
			self.textWidth = sx-20
		end
		
		self.x = (sx/2)-(self.textWidth/2)
		self.y = (sy/2)/2
		self.w = self.textWidth
		self.h = sy/2
		self.button1.x,self.button1.y,self.button1.w,self.button1.h = self.x+6,self.y+(self.h-20),(self.w/2)-8,self.h-(self.h-16)
		self.button2.x,self.button2.y,self.button2.w,self.button2.h = (self.x+(self.w/2))+2,self.y+(self.h-20),(self.w/2)-8,self.h-(self.h-16)
		
		dxRect(self.x,self.y,self.w,self.h,tocolor(0,0,0,180))
		dxText(self.text,self.x+4,self.y+4,self.w-8,self.h-10,tocolor(255,255,255,200),1,'default','left','top',true,true)
	end
	
	table.insert(draw,self)
	return self
end

local update = createJukeboxAlert('This text is some example text to verify that the width and shit is working correctly on the resizing of the dx element shown on screen here.')
showCursor(true)

addCommandHandler('settext',function(cmd,...)
	update.text = table.concat(arg,' ')
end)