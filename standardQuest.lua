local function subdivideObjective(str, desc)
	local subdata = str:split(" ")
	if subdata[1] == "Return" then
		return {command=subdata[1], description=desc, total=tonumber(subdata[2]),content=subdata[3], completed=false, count=0}
	elseif subdata[1] == "Collect" then
		return {command=subdata[1], description=desc, total=tonumber(subdata[2]),content=subdata[3], completed=false, count=0}
	elseif subdata[1] == "Kill" then
		return {command=subdata[1], description=desc, total=tonumber(subdata[2]),content=subdata[3], completed=false, count=0}
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
function adventures.updateQuestFormspec(meta, objs)
	local y = 3+table.getn(objs)
	local str = "label[3.5,0;"..meta:get_string("name").."]"..
				"list[context;reward;5,"..(y-3)..";2,2;]"..
				"list[context;items;1,"..(y-3)..";2,2;]"
	local quest = adventures.quests[meta:get_string("name")]
	if quest ~= nil then
		if not quest.accepted then
			str = str.."button[3.25,"..(y-2)..";1.5,1;accept;Accept]"
		elseif quest.completed then
			str = str.."label[3.25,"..(y-2)..";Completed!]"
		end
	end
	for i,obj in ipairs(objs) do
		str = str.."label[1,"..(i/2)..";"..obj.description.."]"
	end
	y = y+4
	str = str.."list[current_player;main;0,"..(y-4)..";8,4;]"
	str = "size[8,"..y.."]"..str
	return str
end
function adventures.storeQuestData(data)
	local pos = {x=data[2],y=data[3],z=data[4]}
	local meta = minetest.env:get_meta(pos)
	local objs = convertObjectiveString(meta:get_string("objective"), meta:get_string("description"))
	adventures.quests[meta:get_string("name")] = {source=pos, objectives = objs, accepted=false, completed=false, active=false}
	meta:set_string("formspec", adventures.updateQuestFormspec(meta, objs))
end

minetest.register_node("adventures:quest", {
	description = "Quest",
	walkable = true,
	groups = {immortal=1},
	tiles = {"adventures_quest.png"},
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		if fields.accept then
			adventures.quests[meta:get_string("name")].accepted = true
			local objs = adventures.quests[meta:get_string("name")].objectives
			for i,obj in ipairs(objs) do
				if obj.command == "Return" then
					table.insert(adventures.currentObjectives["Return"], {quest=meta:get_string("name"), index=i})
				elseif obj.command == "Collect" then
					table.insert(adventures.currentObjectives["Collect"], {quest=meta:get_string("name"), index=i})
				elseif obj.command == "Kill" then
					table.insert(adventures.currentObjectives["Kill"], {quest=meta:get_string("name"), index=i})
				end
			end
			meta:set_string("formspec", adventures.updateQuestFormspec(meta, objs))
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
	return 0 end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
	return 0 end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
	if listname == "reward" then
		local meta = minetest.env:get_meta(pos)
		local quest = adventures.quests[meta:get_string("name")]
		if quest == nil then
			return 0
		elseif not quest.completed then
			return 0
		end
	end
	return stack:get_count() end
})