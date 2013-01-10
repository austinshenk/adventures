--run Files

local file = io.open(minetest.get_worldpath().."/adventures_init", "r")
if(file == nil) then
	print("Initialize")
	io.output(minetest.get_worldpath().."/adventures_init")
	io.write("initialized")
	io.flush()
	io.close()
	io.output(minetest.get_worldpath().."/adventures_sources")
	io.write("initialized")
	io.flush()
	io.close()
	io.output(minetest.get_worldpath().."/adventures_previousmode")
	io.write("initialized")
	io.flush()
	io.close()
end

local modpath=minetest.get_modpath("adventures")
dofile(modpath.."/tables.lua")
function adventures.positionToString(pos)
	return tostring(pos.x)..tostring(pos.y)..tostring(pos.z)
end

function adventures.snapPosition(meta, pos)
	local newPos = {x=pos.x,y=pos.y,z=pos.z}
	if(meta:get_int("width")%2 == 0) then
		newPos.x = newPos.x-0.5
		newPos.z = newPos.z-0.5
	end
	if(meta:get_int("height")%2 == 0) then
		newPos.y = newPos.y+0.5
	end
	newPos.x = newPos.x+meta:get_int("x")
	newPos.y = newPos.y+meta:get_int("y")
	newPos.z = newPos.z+meta:get_int("z")
	return newPos
end

function adventures.findArea(meta, pos, delta)
	local node = minetest.env:get_node(pos)
	local areaPos = {x=pos.x+meta:get_int("x")-delta.x,y=pos.y+meta:get_int("y")-delta.y,z=pos.z+meta:get_int("z")-delta.z}
	local objects = minetest.env:get_objects_inside_radius(areaPos, 1)
	local name = node.name:sub(1,-7).."area"
	for i,_ in ipairs(objects) do
		if(objects[i]:get_entity_name() == name) then
			return objects[i]
		end
	end
end
dofile(modpath.."/decode.lua")
local creative = minetest.setting_get("creative_mode")
print("CREATIVE: "..creative)
if creative == "1" then dofile(modpath.."/creative.lua") 
else dofile(modpath.."/standard.lua")
end