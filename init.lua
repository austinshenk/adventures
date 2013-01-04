--run Files
local init = io.open(minetest.get_worldpath().."/adventures_init", "w")
if(init == nil) then
	init:write("init")
	init:close()
	local file = io.open(minetest.get_worldpath().."/adventures_sources", "w")
	file:write(" ")
	file:close()
end

local modpath=minetest.get_modpath("adventures")
dofile(modpath.."/decode.lua")
dofile(modpath.."/tables.lua")
local creative = minetest.setting_get("creative_mode")
if creative then dofile(modpath.."/creative.lua") 
else dofile(modpath.."/standard.lua")
end