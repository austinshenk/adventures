local file = io.open(minetest.get_worldpath().."/adventures_sources", "r")
if(file ~= nil) then
	local creative = minetest.setting_get("creative_mode")
	local start = 1
	for line in file:lines() do
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
		local node = data[1]
		local pos = {x=data[2],y=data[3],z=data[4]}
		if(node == "adventures:invincible_source") then
			if(creative) then
				minetest.env:add_node({name=node}, pos)
				local meta = minetest.env:get_meta(pos)
				local area = adventures.findArea(meta, pos, {x=0,y=0,z=0})
				meta:set_int("x", data[5])
				meta:set_int("y", data[6])
				meta:set_int("z", data[7])
				meta:set_int("width", data[8])
				meta:set_int("length", data[9])
				meta:set_int("height", data[10])
				area:set_properties({visual_size={x=data[8],y=data[10]}})
				area:setpos(adventures.snapPosition(meta, pos))
			else
				
			end
		end
	end
end
io.close()