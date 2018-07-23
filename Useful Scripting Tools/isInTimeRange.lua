[[
function isInTimeRange(start,ending)
	local hour = getTime()
	if start > ending then
		return (hour < start and hour > ending)
	else
		return (not (hour < ending and hour > start))
	end
end
]]