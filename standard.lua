--Normal Mode
local modpath=minetest.get_modpath("adventures")
dofile(modpath.."/standardInitialStuff.lua")
dofile(modpath.."/standardProtect.lua")
dofile(modpath.."/standardQuest.lua")
dofile(modpath.."/standardSpawning.lua")
dofile(modpath.."/Book.lua")

local old_node_dig = minetest.node_dig
function minetest.node_dig(pos, node, digger)
	if (not adventures.canBreak) then return end
	if adventures.unbreakable[adventures.positionToString(pos)] ~= true then
		for _,obj in pairs(adventures.currentObjectives["Collect"]) do
			local o = adventures.quests[obj.quest].objectives[obj.index]
			if not o.completed then
				if o.content == node.name then
					local count = o.count+1
					if count >= o.total then
						adventures.quests[obj.quest].objectives[obj.index].completed = true
						minetest.chat_send_all("QUEST: "..obj.quest.." completed")
						adventures.checkQuestComplete(obj.quest)
					end
					adventures.quests[obj.quest].objectives[obj.index].count = count
				end
			end
		end
		old_node_dig(pos, node, digger)
	else
		return
	end
end

local old_node_place = minetest.item_place
function minetest.item_place(itemstack, placer, pointed_thing)
	if (not adventures.canBuild) then return end
	if adventures.unbuildable[adventures.positionToString(pointed_thing.above)] ~= true then
		return old_node_place(itemstack, placer, pointed_thing)
	else
		return
	end
end

minetest.register_on_newplayer(function(obj)
	adventures.playerCheckPoints[obj:get_player_name()] = 0
	adventures.requestSpawnPosition(obj)
	adventures.giveInitialStuff(obj)
end)

minetest.register_on_joinplayer(function(obj)
	if adventures.started then return end
	for pos,data in pairs(adventures.sourceData) do
		if(data[1] == "adventures:unbreakable_source") then
			adventures.storeUnbreakableNodes(data)
		elseif(data[1] == "adventures:unbuildable_source") then
			adventures.storeUnbuildableNodes(data)
		elseif(data[1] == "adventures:fullprotect_source") then
			adventures.storeFullyProtectedNodes(data)
		elseif(data[1] == "adventures:spawn_source") then
			adventures.storeSpawnPositions(data)
		elseif(data[1] == "adventures:respawn_source") then
			adventures.storeRespawnPositions(data)
		elseif(data[1] == "adventures:checkpoint_source") then
			adventures.storeCheckpointPositions(data)
		elseif(data[1] == "adventures:quest") then
			adventures.storeQuestData(data)
		end
	end
	local file = io.open(minetest.get_worldpath().."/adventures_previousmode", "w")
	file:write(adventures.normal)
	file:close()
	adventures.started = true
end)

minetest.register_abm({
	nodenames = {"adventures:unbreakable_source",
				"adventures:unbuildable_source",
				"adventures:fullprotect_source",
				"adventures:spawn_source",
				"adventures:respawn_source",
				"adventures:checkpoint_source"},
	interval = 0.5,
    chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local area = adventures.findArea(minetest.env:get_meta(pos), pos, {x=0,y=0,z=0})
		if area ~= nil then
			area:remove()
		end
		minetest.env:remove_node(pos)
	end
})

minetest.register_entity("adventures:unbreakable_area" ,{})
minetest.register_entity("adventures:unbuildable_area" ,{})
minetest.register_entity("adventures:fullprotect_area" ,{})
minetest.register_entity("adventures:spawn_area" ,{})
minetest.register_entity("adventures:respawn_area" ,{})
minetest.register_entity("adventures:checkpoint_area" ,{})

minetest.register_on_respawnplayer(function(obj)
	local id = adventures.playerCheckPoints[obj:get_player_name()]
	if id == 0 then
		return adventures.requestSpawnPosition(obj)
	else
		return adventures.requestRespawnPosition(obj)
	end
end)

local function savePlayerID()
	local file = io.open(minetest.get_worldpath().."/adventures_checkpoints", "w")
	local str = ""
	for player, id in pairs(adventures.playerCheckPoints) do
		str = str..player.."`"..id.."\n"
	end
	file:write(str)
	file:close()
end
minetest.register_globalstep(function(dtime)
	for _,player in pairs(minetest.get_connected_players()) do
		local id = adventures.checkPoints[adventures.positionToString(adventures.snapPlayerPosition(player:getpos()))]
		if(id ~= nil) then
			adventures.playerCheckPoints[player:get_player_name()] = id
		end
	end
	if(not adventures.autoSave) then return end
	if(adventures.currentTime >= adventures.saveTime) then
		savePlayerID()
	end
	adventures.currentTime = adventures.currentTime+dtime
end)

minetest.register_on_shutdown(function()
	savePlayerID()
end)