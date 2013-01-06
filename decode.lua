local file = io.open(minetest.get_worldpath().."/adventures_sources", "r")
if(file ~= nil) then
	local start = 1
	for line in file:lines() do
		if line == "initialized" or line == "" then
			return
		end
		local comma = line:find(",")
		local data = {}
		data[1] = line:sub(start,comma-1)
		start = comma+1
		comma = line:find(",", start)
		while(comma ~= nil) do
			table.insert(data, tonumber(line:sub(start,comma-1)))
			start = comma+1
			comma = line:find(",", start)
		end
		adventures.sourceData[{x=data[2],y=data[3],z=data[4]}] = data
	end
end
file:close()