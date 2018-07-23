[[
function getElementSpeed(element,unit)
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == 'm/s') and 50 or ((unit == 1 or unit == 'km/h') and 180 or 111.84681456)
    return (Vector3(getElementVelocity(element))*mult).length
end
]]