--Normal Mode

local old_node_dig = minetest.node_dig
function minetest.node_dig(pos, node, digger)
	if adventures.unbreakable[pos] == nil then
		old_node_dig(pos, node, digger)
	else
		return
	end
end

local function storeInvincibleNodes(data)
	local pos = {x=data[2],y=data[3],z=data[4]}
	local offset = {x=data[5],y=data[6],z=data[7]}
	local size = {x=data[8],y=data[9],z=data[10]}
	local shift = {x=0,y=0,z=0}
	if(width%2 == 0) then
		shift.x = 0.5
		shift.z = 0.5
	end
	if(height%2 == 0) then
		shift.y = -0.5
	end
	for y=0,size.y-1,1 do
	for z=0,size.z-1,1 do
	for x=0,size.x-1,1 do
		local nodePos = {x=(pos.x+offset.x-(size.x/2))+shift.x+x,
						y=(pos.y+offset.y-(size.y/2))+shift.y+y,
						z=(pos.z+offset.z-(size.x/2))+shift.z+z}
		print(tostring(nodePos))
		adventures.unbreakable[nodePos] = true
	end
	end
	end
end

minetest.register_on_joinplayer(function(obj)
	if adventures.started then return end
	for _,data in ipairs(adventures.sourceData) do
		if(data[1] == "adventures:invincible_source") then
			storeInvincibleNodes(data)
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