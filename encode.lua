local file = io.open(minetest.get_worldpath().."/adventures_init", "w")
local str = ""
local main = minetest.get_inventory({type="detached",name="initialstuff"}):get_list("main")
for _,stack in pairs(main) do
	str = str..stack:get_name().."`"..stack:get_count().."\n"
end
file:write(str)
file:close()
	
file = io.open(minetest.get_worldpath().."/adventures_sources", "w")
local saved  = false
str = ""
for s,data in pairs(adventures.sources) do
	if data ~= nil then
		local meta = minetest.env:get_meta(data.pos)
		if(data.name == "adventures:unbreakable_source") then
			str = str..data.name.."`"..data.pos.x.."`"..data.pos.y.."`"..data.pos.z.."`"..
			meta:get_int("x").."`"..meta:get_int("y").."`"..meta:get_int("z").."`"..
			meta:get_int("width").."`"..meta:get_int("length").."`"..meta:get_int("height")
			.."\n"
		end
		if(data.name == "adventures:unbuildable_source") then
			str = str..data.name.."`"..data.pos.x.."`"..data.pos.y.."`"..data.pos.z.."`"..
			meta:get_int("x").."`"..meta:get_int("y").."`"..meta:get_int("z").."`"..
			meta:get_int("width").."`"..meta:get_int("length").."`"..meta:get_int("height")
			.."\n"
		end
		if(data.name == "adventures:fullprotect_source") then
			str = str..data.name.."`"..data.pos.x.."`"..data.pos.y.."`"..data.pos.z.."`"..
			meta:get_int("x").."`"..meta:get_int("y").."`"..meta:get_int("z").."`"..
			meta:get_int("width").."`"..meta:get_int("length").."`"..meta:get_int("height")
			.."\n"
		end
		if(data.name == "adventures:spawn_source") then
			str = str..data.name.."`"..data.pos.x.."`"..data.pos.y.."`"..data.pos.z.."`"..
			meta:get_int("x").."`"..meta:get_int("y").."`"..meta:get_int("z").."`"..
			meta:get_int("width").."`"..meta:get_int("length").."`"..meta:get_int("height")
			.."\n"
		end
		if(data.name == "adventures:respawn_source") then
			str = str..data.name.."`"..data.pos.x.."`"..data.pos.y.."`"..data.pos.z.."`"..
			meta:get_int("x").."`"..meta:get_int("y").."`"..meta:get_int("z").."`"..
			meta:get_int("width").."`"..meta:get_int("length").."`"..meta:get_int("height")..
			"`"..meta:get_int("id")
			.."\n"
		end
		if(data.name == "adventures:checkpoint_source") then
			str = str..data.name.."`"..data.pos.x.."`"..data.pos.y.."`"..data.pos.z.."`"..
			meta:get_int("x").."`"..meta:get_int("y").."`"..meta:get_int("z").."`"..
			meta:get_int("width").."`"..meta:get_int("length").."`"..meta:get_int("height")..
			"`"..meta:get_int("id")
			.."\n"
		end
		if(data.name == "adventures:initial_stuff") then
			str = str..data.name.."`"..data.pos.x.."`"..data.pos.y.."`"..data.pos.z.."\n"
		end
		if(data.name == "adventures:quest") then
			str = str..data.name.."`"..data.pos.x.."`"..data.pos.y.."`"..data.pos.z.."\n"
		end
		saved = true
	end
end
file:write(str)
file:close()

file = io.open(minetest.get_worldpath().."/adventures_books", "w")
str = ""
for name,story in pairs(adventures.registered_books) do
	str = str..name.."`\n"
	for _,line in pairs(story) do
		str = str..line.."\n"
	end
	str = str.."`\n"
end
file:write(str)
file:close()
return saved