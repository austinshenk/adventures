function adventures.giveInitialStuff(player)
	player:get_inventory():set_list("main", minetest.get_inventory({type="detached",name="initialstuff"}):get_list("main"))
end