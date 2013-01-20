--Normal Mode

local old_node_dig = minetest.node_dig
function minetest.node_dig(pos, node, digger)
	if (not adventures.canBreak) then return end
	if adventures.unbreakable[adventures.positionToString(pos)] ~= true then
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

local function getStartNode(data)
	--local pos = {x=data[2],y=data[3],z=data[4]}
	--local offset = {x=data[5],y=data[6],z=data[7]}
	--local size = {width=data[8],length=data[9],height=data[10]}
	local start = {x=data[2]+data[5]-math.floor(data[8]/2),
					y=data[3]+data[6]-math.floor(data[10]/2),
					z=data[4]+data[7]-math.floor(data[8]/2)}
	if data[10]%2 == 0 then
		start.y = start.y+1
	end
	return start
end

local function storeUnbreakableNodes(data)
	local start = getStartNode(data)
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		adventures.unbreakable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
	end
	end
	end
end

local function storeUnbuildableNodes(data)
	local start = getStartNode(data)
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		adventures.unbuildable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
	end
	end
	end
end

local function storeFullyProtectedNodes(data)
	local start = getStartNode(data)
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		adventures.unbuildable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
		adventures.unbreakable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
	end
	end
	end
end

local function storeSpawnPositions(data)
	local start = getStartNode(data)
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		table.insert(adventures.spawnPoints, {x=start.x+x,y=start.y+y,z=start.z+z})
		adventures.unbuildable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
	end
	end
	end
end

local function storeRespawnPositions(data)
	local start = getStartNode(data)
	local points = {}
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		table.insert(points, {x=start.x+x,y=start.y+y,z=start.z+z})
		adventures.unbuildable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
	end
	end
	end
	adventures.respawnPoints[data[11]] = points
end

local function storeCheckpointPositions(data)
	local start = getStartNode(data)
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		adventures.checkPoints[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = data[11]
	end
	end
	end
end

local function giveInitialStuff(player)
	player:get_inventory():set_list("main", minetest.get_inventory({type="detached",name="initialstuff"}):get_list("main"))
end
minetest.register_on_newplayer(function(obj)
	adventures.playerCheckPoints[obj:get_player_name()] = 0
	adventures.requestSpawnPosition(obj)
	giveInitialStuff(obj)
end)

minetest.register_on_joinplayer(function(obj)
	if adventures.started then return end
	for pos,data in pairs(adventures.sourceData) do
		if(data[1] == "adventures:unbreakable_source") then
			storeUnbreakableNodes(data)
		end
		if(data[1] == "adventures:unbuildable_source") then
			storeUnbuildableNodes(data)
		end
		if(data[1] == "adventures:fullprotect_source") then
			storeFullyProtectedNodes(data)
		end
		if(data[1] == "adventures:spawn_source") then
			storeSpawnPositions(data)
		end
		if(data[1] == "adventures:respawn_source") then
			storeRespawnPositions(data)
		end
		if(data[1] == "adventures:checkpoint_source") then
			storeCheckpointPositions(data)
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
		str = str..player..","..id.."\n"
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