local function subdivideObjective(str, desc)
	local subdata = str:split(" ")
	if subdata[1] == "Return" then
		return {type=subdata[1], description=desc, count=subdata[2],content=subdata[3]}
	elseif subdata[1] == "Collect" then
		return {type=subdata[1], description=desc, count=subdata[2],content=subdata[3]}
	elseif subdata[1] == "Kill" then
		return {type=subdata[1], description=desc, count=subdata[2],content=subdata[3]}
	end
end
local function convertObjectiveString(str, desc)
	local objs = {}
	if str:find("|") == nil then
		objs[1] = subdivideObjective(str, desc)
	else
		local data = str:split("|")
		local descdata = desc:split("|")
		for i,o in ipairs(data) do
			if o ~= nil then
				objs[i] = subdivideObjective(o, descdata[i])
			end
		end
	end
	return objs
end
function adventures.storeQuestData(data)
	local pos = {x=data[2],y=data[3],z=data[4]}
	local meta = minetest.env:get_meta(pos)
	local objs = convertObjectiveString(meta:get_string("objective"), meta:get_string("description"))
	local y = 3+table.getn(objs)
	local str = "label[0,0;"..meta:get_string("name").."]"..
				"list[context;reward;4,"..(y-3)..";2,2;]"..
				"list[context;items;0,"..(y-3)..";2,2;]"..
				"button[1.5,"..(y-1)..";1.5,0.75;accept;Accept]"..
				"button_exit[3,"..(y-1)..";1.5,0.75;decline;Decline]"
	for i,obj in pairs(objs) do
		str = str.."label[0.125,"..(i/2)..";"..obj.description.."]"
	end
	str = "size[6,"..y.."]"..str
	meta:set_string("formspec", str)
	adventures.quests[meta:get_string("name")] = {objectives = objs, id = meta:get_int("id")}
end

minetest.register_node("adventures:quest", {
	description = "Quest",
	walkable = true,
	groups = {immortal=1},
	tiles = {"adventures_quest.png"},
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.accept then
			local meta = minetest.env:get_meta(pos)
			local quests = adventures.playerQuests[sender]
			quests[meta:get_string("name")] = adventures.quests[meta:get_string("name")]
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
	return 0 end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
	return 0 end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
	return 0 end
})