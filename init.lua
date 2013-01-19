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
	io.output(minetest.get_worldpath().."/adventures_checkpoints")
	io.write("initialized")
	io.flush()
	io.close()
	io.output(minetest.get_worldpath().."/adventures_previousmode")
	io.write("initialized")
	io.flush()
	io.close()
end

local modpath=minetest.get_modpath("adventures")
dofile(modpath.."/global.lua")

local inv = minetest.create_detached_inventory("initialstuff", {
	allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
		return count
	end,
	allow_put = function(inv, listname, index, stack, player)
		return stack:get_count()
	end,
	allow_take = function(inv, listname, index, stack, player)
		return stack:get_count()
	end,
	})
inv:set_size("main", 32)

dofile(modpath.."/decode.lua")
local creative = minetest.setting_get("creative_mode")
if creative == "1" then dofile(modpath.."/creative.lua") 
else dofile(modpath.."/standard.lua")
end