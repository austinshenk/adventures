--Normal Mode
minetest.register_on_joinplayer(function(obj)
	local file = io.open(minetest.get_worldpath().."/adventures_previousmode", "r")
	if(file:read("*l") == adventures.creative) then
		file:close()
		local node = nil
		local pos = nil
		for _,data in ipairs(adventures.sourceData) do
			pos = {x=data[2],y=data[3],z=data[4]}
			node = minetest.env:get_node(pos)
		end
	else
		file:close()
	end
end)