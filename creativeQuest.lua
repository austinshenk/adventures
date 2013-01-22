local function updateQuest(meta)
	return "size[8,9]"..
				"field[0.25,0.25;5,1;name;Quest Name;"..meta:get_string("name").."]"..
				"field[0.25,1.25;5,1;objective;Objective;"..meta:get_string("objective").."]"..
				"field[0.25,2.25;5,1;description;Description;"..meta:get_string("description").."]button[5.5,0;2,0.75;save;Save]"..
				"label[0,2.5;Quest Items]list[context;items;0,3;2,2;]"..
				"label[6,2.5;Quest Reward]list[context;reward;6,3;2,2;]"..
				"button[2.325,4;.75,.5;idminusten;<<]button[2.925,4;.75,.5;idminusone;<]label[3.75,3.875;"..meta:get_int("id").."]button[4.325,4;.75,.5;idplusone;>]button[4.925,4;.75,.5;idplusten;>>]"..
				"list[current_player;main;0,5;8,4]"
end

minetest.register_node("adventures:quest", {
	description = "Quest",
	walkable = false,
	groups = {crumbly=3},
	tiles = {"adventures_quest.png"},
	on_construct = function(pos)
		adventures.sources[adventures.positionToString(pos)] = {name="adventures:quest",pos=pos}
		local meta = minetest.env:get_meta(pos)
		local data = adventures.sourceData[adventures.positionToString(pos)]
		if data ~= nil then
			meta:set_string("name", data[5])
			meta:set_string("objective", data[6])
			meta:set_string("description", data[7])
			meta:set_int("id", data[8])
		else
			meta:set_string("name", "")
			meta:set_string("objective", "")
			meta:set_string("description", "")
			meta:set_int("id", 0)
		end
		meta:set_string("formspec", updateQuest(meta))
		local inv = meta:get_inventory()
		inv:set_size("items", 4)
		inv:set_size("reward", 4)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		if fields.save then
			meta:set_string("name", fields.name)
			meta:set_string("objective", fields.objective)
			meta:set_string("description", fields.description)
		end
		if fields.idminusten then meta:set_int("id", meta:get_int("id")-10) end
		if fields.idminusone then meta:set_int("id", meta:get_int("id")-1) end
		if fields.idplusone then meta:set_int("id", meta:get_int("id")+1) end
		if fields.idplusten then meta:set_int("id", meta:get_int("id")+10) end
		meta:set_string("formspec", updateQuest(meta))
	end,
	on_destruct = function(pos)
		adventures.sources[adventures.positionToString(pos)] = nil
	end,
})

minetest.register_node("adventures:quest_destination", {
	description = "Quest Destination",
	walkable = false,
	groups = {crumbly=3},
	tiles = {"adventures_questDestination.png"},
	on_construct = function(pos)
		adventures.sources[adventures.positionToString(pos)] = {name="adventures:quest",pos=pos}
		local meta = minetest.env:get_meta(pos)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
	end,
	on_destruct = function(pos)
		adventures.sources[adventures.positionToString(pos)] = nil
	end,
})