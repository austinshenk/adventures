--Creative Mode
local modpath=minetest.get_modpath("adventures")
dofile(modpath.."/creativeGeneral.lua")
dofile(modpath.."/creativeInitialStuff.lua")
dofile(modpath.."/creativeQuest.lua")

minetest.register_on_joinplayer(function(obj)
	if adventures.started then return end
	local file = io.open(minetest.get_worldpath().."/adventures_previousmode", "r")
	if(file:read("*l") ~= adventures.creative) then
		file:close()
		for pos,data in pairs(adventures.sourceData) do
			minetest.env:set_node({x=data[2],y=data[3],z=data[4]}, {name=data[1]})
		end
		file = io.open(minetest.get_worldpath().."/adventures_previousmode", "w")
		file:write(adventures.creative)
		file:close()
	else
		file:close()
		for pos,data in pairs(adventures.sourceData) do
			adventures.sources[adventures.positionToString(pos)] = {name=data[1],pos={x=data[2],y=data[3],z=data[4]}}
		end
	end
	adventures.started = true
end)
	
minetest.register_chatcommand("save", {
	description = "saveAdventure : Save all node data to files",
	func = function(name, param)
		local saved = dofile(minetest.get_modpath("adventures").."/encode.lua")
		if saved then
			minetest.chat_send_player(name, "ADVENTURE SAVED")
		else
			minetest.chat_send_player(name, "ADVENTURE NOT SAVED")
		end
	end,
})