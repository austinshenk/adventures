local file = io.open(minetest.get_worldpath().."/adventures_sources", "w")
local saved  = false
local str = ""
for s,data in pairs(adventures.sources) do
	if data ~= nil then
		local meta = minetest.env:get_meta(data.pos)
		if(data.name == "adventures:invincible_source") then
			str = str..data.name..","..data.pos.x..","..data.pos.y..","..data.pos.z..","..
			meta:get_int("x")..","..meta:get_int("y")..","..meta:get_int("z")..","..
			meta:get_int("width")..","..meta:get_int("length")..","..meta:get_int("height")
			.."\n"
		end
		saved = true
	end
end
file:write(str)
file:close()
return saved