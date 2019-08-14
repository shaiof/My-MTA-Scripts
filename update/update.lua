local r = getThisResource()
fetchRemote('https://raw.githubusercontent.com/shaiof/My-Scripts/master/'..r.name..'/meta.xml', function(data, err)
	if data and err == 0 then
		local file = File('meta.xml')
		file:write(data)
		file:close()
	end
end)

local files = {}
local meta = XML.load('meta.xml')
for i, v in pairs(meta.children) do
	if v.name == 'script' then
		local f = v:getAttribute('src')
		if f then
			files[#files+1] = f
		end
	end
end
meta:unload()

for i=1, #files do
	fetchRemote('https://raw.githubusercontent.com/shaiof/My-Scripts/master/'..r.name..'/'..files[i], function(data, err)
		if data and err == 0 then
			local file = File(files[i])
			file:write(data)
			file:close()
		end
	end)
end			file:close()
		end
	end)
end