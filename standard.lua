--Normal Mode

local old_node_dig = minetest.node_dig
function minetest.node_dig(pos, node, digger)
	if adventures.unbreakable[adventures.positionToString(pos)] ~= true then
		old_node_dig(pos, node, digger)
	else
		return
	end
end

local old_node_place = minetest.item_place
function minetest.item_place(itemstack, placer, pointed_thing)
	if adventures.unbuildable[adventures.positionToString(pointed_thing.above)] ~= true then
		return old_node_place(itemstack, placer, pointed_thing)
	else
		return
	end
end


local function storeUnbreakableNodes(data)
	--local pos = {x=data[2],y=data[3],z=data[4]}
	--local offset = {x=data[5],y=data[6],z=data[7]}
	--local size = {width=data[8],length=data[9],height=data[10]}
	local start = {x=data[2]+data[5]-math.floor(data[8]/2),
					y=data[3]+data[6]-math.floor(data[10]/2),
					z=data[4]+data[7]-math.floor(data[8]/2)}
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		adventures.unbreakable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
	end
	end
	end
end

local function storeUnbuildableNodes(data)
	--local pos = {x=data[2],y=data[3],z=data[4]}
	--local offset = {x=data[5],y=data[6],z=data[7]}
	--local size = {width=data[8],length=data[9],height=data[10]}
	local start = {x=data[2]+data[5]-math.floor(data[8]/2),
					y=data[3]+data[6]-math.floor(data[10]/2),
					z=data[4]+data[7]-math.floor(data[8]/2)}
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		adventures.unbuildable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
	end
	end
	end
end

local function storeFullyProtectedNodes(data)
	--local pos = {x=data[2],y=data[3],z=data[4]}
	--local offset = {x=data[5],y=data[6],z=data[7]}
	--local size = {width=data[8],length=data[9],height=data[10]}
	local start = {x=data[2]+data[5]-math.floor(data[8]/2),
					y=data[3]+data[6]-math.floor(data[10]/2),
					z=data[4]+data[7]-math.floor(data[8]/2)}
	for y=0,data[10]-1,1 do
	for z=0,data[8]-1,1 do
	for x=0,data[8]-1,1 do
		adventures.unbuildable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
		adventures.unbreakable[adventures.positionToString({x=start.x+x,y=start.y+y,z=start.z+z})] = true
	end
	end
	end
end

minetest.register_on_joinplayer(function(obj)
	if adventures.started then return end
	for pos,data in pairs(adventures.sourceData) do
		if(data[1] == "adventures:invincible_source") then
			storeUnbreakableNodes(data)
		end
	end
	local file = io.open(minetest.get_worldpath().."/adventures_previousmode", "w")
	file:write(adventures.normal)
	file:close()
	adventures.started = true
end)

minetest.register_abm({
	nodenames = {"adventures:invincible_source"},
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

minetest.register_entity("adventures:invincible_area" ,{})