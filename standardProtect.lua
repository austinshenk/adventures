function adventures.storeUnbreakableNodes(data)
	local start = adventures.getStartNode(data)
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		adventures.unbreakable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
	end
	end
	end
end

function adventures.storeUnbuildableNodes(data)
	local start = adventures.getStartNode(data)
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		adventures.unbuildable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
	end
	end
	end
end

function adventures.storeFullyProtectedNodes(data)
	local start = adventures.getStartNode(data)
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		adventures.unbuildable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
		adventures.unbreakable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
	end
	end
	end
end