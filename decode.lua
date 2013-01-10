local file = io.open(minetest.get_worldpath().."/adventures_sources", "r")
if(file ~= nil) then
	local start = 1
	for line in file:lines() do
		if line == "initialized" or line == "" then
			return
		end
		local subdata = line:split(",")
		local data = {}
		data[1] = subdata[1]
		for i=2,table.getn(subdata),1 do
			data[i] = subdata[i]
		end
		adventures.sourceData[adventures.positionToString({x=data[2],y=data[3],z=data[4]})] = data
	end
end
file:close()