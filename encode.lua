local file = io.open(minetest.get_worldpath().."/adventures_sources", "w")
local saved  = false
for pos,name in pairs(adventures.sources) do
	local meta = minetest.env:get_meta(pos)
	local str = ""
	if(name == "adventures:invincible_source") then
		str = name..","..pos.x..","..pos.y..","..pos.z..","..
		meta:get_int("x")..","..meta:get_int("y")..","..meta:get_int("z")..","..
		meta:get_int("width")..","..meta:get_int("length")..","..meta:get_int("height")..","
		.."\n"
	end
	file:write(str)
	saved = true
end
if(saved) then
	print("ADVENTURE SAVED")
else
	print("ERROR IN ADVENTURE")
end
file:close()