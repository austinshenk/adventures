adventures = {}
adventures.started = false
adventures.creative = "creative"
adventures.normal = "normal"
adventures.initialStuff = {}
adventures.sources = {}
adventures.sourceData = {}
adventures.canBreak = true
adventures.unbreakable = {}
adventures.canBuild = true
adventures.unbuildable = {}
adventures.spawnPoints = {}
adventures.respawnPoints = {}
adventures.checkPoints = {}
adventures.playerCheckPoints = {}
adventures.autoSave = true
adventures.saveTime = 60
adventures.currentTime = 0
adventures.quests = {}

adventures.generalSources = {}
adventures.generalSources["adventures:unbreakable_source"] = {
							description="Unbreakable Area",
							tiles = {"adventures_unbreakableSource.png"},
							area={name="adventures:unbreakable_area",
									texture = "adventures_unbreakableArea.png"}}
adventures.generalSources["adventures:unbuildable_source"] = {
							description="Unbuildable Area",
							tiles = {"adventures_unbuildableSource.png"},
							area={name="adventures:unbuildable_area",
									texture = "adventures_unbuildableArea.png"}}
adventures.generalSources["adventures:fullprotect_source"] = {
							description="Fully Protected Area",
							tiles = {"adventures_fullprotectSource.png"},
							area={name="adventures:fullprotect_area",
									texture = "adventures_fullprotectArea.png"}}
adventures.generalSources["adventures:spawn_source"] = {
							description="Spawn Area",
							tiles = {"adventures_spawnSource.png"},
							area={name="adventures:spawn_area",
									texture = "adventures_spawnArea.png"}}
									
adventures.generalIDSources = {}
adventures.generalIDSources["adventures:respawn_source"] = {
							description="Respawn Area",
							tiles = {"adventures_respawnSource.png"},
							area={name="adventures:respawn_area",
									texture = "adventures_respawnArea.png"}}
adventures.generalIDSources["adventures:checkpoint_source"] = {
							description="Checkpoint",
							tiles = {"adventures_checkpointSource.png"},
							area={name="adventures:checkpoint_area",
									texture = "adventures_checkpointArea.png"}}
									
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

function adventures.snapPlayerPosition(pos)
	local new = {x=0,y=0,z=0}
	local rem = pos.x%1.0
	new.x = pos.x-rem
	rem = pos.y%1.0
	new.y = pos.y+(1.0-rem)
	rem = pos.z%1.0
	new.z = pos.z-rem
	return new
end

function adventures.requestSpawnPosition(player)
	if adventures.spawnPoints == nil then
		return false
	end
	local i = math.random(table.getn(adventures.spawnPoints))
	player:setpos(adventures.spawnPoints[i])
	return true
end

function adventures.requestRespawnPosition(player)
	local id = adventures.playerCheckPoints[player:get_player_name()]
	local points = adventures.respawnPoints[id]
	local adjusted = false
	local startID = id
	while points == nil and id > 0 do
		adjusted = true
		id = id-1
		points = adventures.respawnPoints[id]
	end
	if id == 0 then
		return adventures.requestSpawnPosition(player)
	end
	if adjusted then
		print("Adventures Message: Respawn area #"..startID.." does not exist adjusted to respawn area #"..id)
	end
	local i = math.random(table.getn(points))
	player:setpos(points[i])
	return true
end

function adventures.saveInitialStuff()
	local file = io.open(minetest.get_worldpath().."/adventures_init", "w")
	local str = ""
	local main = minetest.get_inventory({type="detached",name="initialstuff"}):get_list("main")
	for _,stack in pairs(main) do
		str = str..stack:get_name()..","..stack:get_count().."\n"
	end
	file:write(str)
	file:close()
end