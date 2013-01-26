local file = io.open(minetest.get_worldpath().."/adventures_init", "r")
if(file ~= nil) then
	local i = 1
	local inv = minetest.get_inventory({type="detached",name="initialstuff"})
	for line in file:lines() do
		if line ~= "initialized" and line ~= "`0" then
			local values = line:split("`")
			inv:set_stack("main", i, values[1].." "..values[2])
		end
		i = i+1
	end
end
file:close()

file = io.open(minetest.get_worldpath().."/adventures_sources", "r")
if(file ~= nil) then
	for line in file:lines() do
		if line ~= "initialized" and line ~= "" then
			local subdata = line:split("`")
			local data = {}
			data[1] = subdata[1]
			for i=2,table.getn(subdata),1 do
				local num = tonumber(subdata[i])
				if(num == 0 and subdata[i] ~= "0") then
					data[i] = subdata[i]
				else
					data[i] = num
				end
			end
			adventures.sourceData[adventures.positionToString({x=data[2],y=data[3],z=data[4]})] = data
		end
	end
end
file:close()

file = io.open(minetest.get_worldpath().."/adventures_books", "r")
if(file ~= nil) then
	for line in file:lines() do
		local story = {}
		if line ~= "initialized" and line ~= "" then
			local name = line:sub(1,#line-1)
			line = file:read("*l")
			while line ~= nil and line ~= "`" do
				table.insert(story, line)
				line = file:read("*l")
			end
			adventures.registered_books[name] = story
		end
	end
end
file:close()

file = io.open(minetest.get_worldpath().."/adventures_checkpoints", "r")
if(file ~= nil) then
	for line in file:lines() do
		if line ~= "initialized" and line ~= "" then
			local data = line:split("`")
			adventures.playerCheckPoints[data[1]] = tonumber(data[2])
		end
	end
end
file:close()