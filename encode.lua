local file = io.open(minetest.get_worldpath().."/adventures_sources", "w")
local saved  = false
local str = ""
for pos,name in pairs(adventures.sources) do
	local meta = minetest.env:get_meta(pos)
	if(name == "adventures:invincible_source") then
		str = str..name..","..pos.x..","..pos.y..","..pos.z..","..
		meta:get_int("x")..","..meta:get_int("y")..","..meta:get_int("z")..","..
		meta:get_int("width")..","..meta:get_int("length")..","..meta:get_int("height")..","
		.."\n"
	end
	saved = true
end
file:write(str)
file:close()
return saved