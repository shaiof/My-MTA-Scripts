local airbrake = {}
local colour = {255, 255, 255, 200}

function activateBreak ( )
	local vehicle = getPedOccupiedVehicle (getLocalPlayer())
	if  ( airbrake ) then
		airbrake = false
		if vehicle then
			setElementCollisionsEnabled ( vehicle, true )
			setElementFrozen(vehicle, false)
			--toggleAllControls(true)
		end
		toggleControl("enter_exit", true)
		--setGravity ( 0.008 )
		removeEventHandler ( "onClientRender", getRootElement(), checkBreak )
		killTimer (flasher)
	else
		if vehicle then
			local driver = getVehicleOccupant ( vehicle )
			if driver == getLocalPlayer() then
				setElementCollisionsEnabled ( vehicle, false )
				setElementVelocity ( vehicle, 0, 0, 0 )
				setElementFrozen(vehicle, true)
				--toggleAllControls(false)
				toggleControl("enter_exit", false)
			else
				outputChatBox ( "You must be the driver of the vehicle.", getLocalPlayer() )
			return end
		end
		--setGravity ( 0.001 )
		addEventHandler ( "onClientRender", getRootElement(), checkBreak )
		flasher = setTimer (
			function()
				if colour["name"] == "pink" then
					colour = {255, 255, 255, 200}
					colour["name"] = "white"
				else
					colour = {250, 20, 100, 200}
					colour["name"] = "pink"
				end
			end, 
		500, 0)
		airbrake = true
	end
end
addCommandHandler ( "airbrake" , activateBreak )

function gravChange (cmd, gravv)
	local gravSet = tonumber(gravv)
	if gravSet then
		setGravity (gravSet)
		outputChatBox ( "Gravity set to " ..tostring(gravv).. ".  Default is 0.008!", player )
	else
		outputChatBox ( "You must enter a number to change!", player )
	end
end
--addCommandHandler ( "grav" , gravChange )
addCommandHandler ( "gravity" , gravChange )
addCommandHandler ( "g" , gravChange )

addEventHandler("onClientVehicleStartEnter", getRootElement(),
	function ( player, seat )
		if seat and player == getLocalPlayer() then
			if airbrake then
				airbrake = false
				--setGravity ( 0.008 )
				removeEventHandler ( "onClientRender", getRootElement(), checkBreak )
				killTimer (flasher)
			end
		end
	end
)

function checkBreak()
	if isPedInVehicle (getLocalPlayer()) then
	if isCursorShowing() == true then
	--have a wank
		else
		local vehicle = getPedOccupiedVehicle ( getLocalPlayer() )
		setElementVelocity ( vehicle, 0, 0, 0 )
		--setElementFrozen(vehicle, true)
		--setElementCollisionsEnabled (vehicle, false)
		local px, py, pz = getElementPosition ( vehicle )
		local rx, ry, rz = getElementRotation ( vehicle )
		setElementRotation ( vehicle, 0, 0, rz)
		if ( getKeyState ( "w") ) or ( getKeyState ( "num_8") ) then
			local x = (.5)*math.cos((rz+90)*math.pi/180)
			local y = (.5)*math.sin((rz+90)*math.pi/180)
			local nx = px + x
			local ny = py + y
			setElementRotation ( vehicle, 0, 0, rz)
			setElementPosition ( vehicle, nx, ny, pz )
		end
		if ( getKeyState ( "s") ) or ( getKeyState ( "num_5") ) then		
			local x = (-.5)*math.cos((rz+90)*math.pi/180)
			local y = (-.5)*math.sin((rz+90)*math.pi/180)
			local nx = px + x
			local ny = py + y
			setElementRotation ( vehicle, 0, 0, rz)
			setElementPosition ( vehicle, nx, ny, pz )
		end	
		if ( getKeyState ( "e") ) or ( getKeyState ( "num_9") ) then	
			local x = (.5)*math.cos((rz)*math.pi/180)
			local y = (.5)*math.sin((rz)*math.pi/180)
			local nx = px + x
			local ny = py + y
			setElementRotation ( vehicle, 0, 0, rz)
			setElementPosition ( vehicle, nx, ny, pz )
		end	
		if ( getKeyState ( "q") ) or ( getKeyState ( "num_7") ) then		
			local x = (-.5)*math.cos((rz)*math.pi/180)
			local y = (-.5)*math.sin((rz)*math.pi/180)
			local nx = px + x
			local ny = py + y
			setElementRotation ( vehicle, 0, 0, rz)
			setElementPosition ( vehicle, nx, ny, pz )
		end	
		if ( getKeyState ( "a") ) or ( getKeyState ( "num_4") ) then		
			setElementRotation ( vehicle, 0, 0, rz + 3)
		end	
		if ( getKeyState ( "d") ) or ( getKeyState ( "num_6") )then		
			setElementRotation ( vehicle, 0, 0, rz - 3)
		end
		if ( getKeyState ( "space") ) or ( getKeyState ( "num_add") ) then		
			setElementPosition ( vehicle, px, py, pz + 1)
		end
		if ( getKeyState ( "lshift") ) or ( getKeyState ( "num_sub") ) then		
			setElementPosition ( vehicle, px, py, pz - 1)
		end
	end
	end
end

addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), 
	function ()
		bindKey ( "b", "down", activateBreak )
		airbrake = false
	end
)

addEventHandler ("onClientRender", getRootElement(),
	function ()
		if airbrake == true then
			local x, y = guiGetScreenSize ()
			dxDrawText ("Airbrake is ON. Press 'B' to disable.", x, 0, 0, 0, tocolor(unpack(colour)), 4, "default-bold", "center", "top", false, false, false)
		end
	end
)