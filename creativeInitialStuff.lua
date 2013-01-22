minetest.register_node("adventures:initial_stuff", {
	description = "Initial Stuff",
	walkable = false,
	groups = {crumbly=3},
	tiles = {"adventures_initialStuff.png"},
	on_construct = function(pos)
		adventures.sources[adventures.positionToString(pos)] = {name="adventures:initial_stuff",pos=pos}
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", "size[8,9]"..
			"list[detached:initialstuff;main;0,0;8,4;]"..
			"list[current_player;main;0,5;8,4;]")
		meta:get_inventory():set_size("main", 32)
	end,
	on_destruct = function(pos)
		adventures.sources[adventures.positionToString(pos)] = nil
	end,
})