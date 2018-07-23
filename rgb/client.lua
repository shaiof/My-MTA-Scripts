local function wavelengthToRGBA(length)
    local r, g, b, factor
    if (length >= 380 and length < 440) then
        r, g, b = -(length - 440)/(440 - 380), 0, 1
    elseif (length < 489) then
        r, g, b = 0, (length - 440)/(490 - 440), 1
    elseif (length < 510) then
        r, g, b = 0, 1, -(length - 510)/(510 - 490)
    elseif (length < 580) then
        r, g, b = (length - 510)/(580 - 510), 1, 0
    elseif (length < 645) then
        r, g, b = 1, -(length - 645)/(645 - 580), 0
    elseif (length < 780) then
        r, g, b = 1, 0, 0
    else
        r, g, b = 0, 0, 0
    end
    if (length >= 380 and length < 420) then
        factor = 0.3 + 0.7*(length - 380)/(420 - 380)
    elseif (length < 701) then
        factor = 1
    elseif (length < 780) then
        factor = 0.3 + 0.7*(780 - length)/(780 - 700)
    else
        factor = 0
    end
    return r*255, g*255, b*255, factor*255
end
     
local startTime = getTickCount()
local lastProgress = 0
local alternateOrder = false
local function rainbowColorVehicle()
    local progress = math.fmod(getTickCount() - startTime, 3000) / 3000
    if lastProgress > progress then
        -- Flip interpolation targets after each "restart"
        alternateOrder = not alternateOrder
    end
    -- Save last progress to calculate the above
    lastProgress = progress
    -- Take alternateOrder into account to invert the progress
    progress = alternateOrder and 1 - progress or progress
    local length = interpolateBetween(550, 0, 0, 650 --[[ Reduced 50 nm here to make the apparent red color be visible less time ]], 0, 0, progress, "Linear")
    local r, g, b = wavelengthToRGBA(length)
    for _,v in pairs(getElementsByType("vehicle", root, true)) do
        if isElementOnScreen(v) and (getElementData(v,"rgb") == true) then
            setVehicleColor(v, r, g, b, r, g, b, r, g, b, r, g, b)
        end
    end
end
addEventHandler("onClientPreRender", getRootElement(), rainbowColorVehicle)