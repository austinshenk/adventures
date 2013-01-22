function adventures.storeSpawnPositions(data)
	local start = adventures.getStartNode(data)
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		table.insert(adventures.spawnPoints, {x=start.x+x,y=start.y+y,z=start.z+z})
		adventures.unbuildable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
	end
	end
	end
end

function adventures.storeRespawnPositions(data)
	local start = adventures.getStartNode(data)
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

function adventures.storeCheckpointPositions(data)
	local start = adventures.getStartNode(data)
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		adventures.checkPoints[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = data[11]
	end
	end
	end
end