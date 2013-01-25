local function showBookFormspec(name, story)
	return "size[5,9]label[0,0;"..name.."]label[0,1;"..story.."]"
end
for name,story in pairs(adventures.registered_books) do
	local nam = "adventures:book_"..name
	minetest.register_tool(nam, {
		description = name,
		inventory_image = "default_book.png",
		stack_max = 1,
		on_use = function(itemstack, user, pointed_thing)
			minetest.show_formspec(user:get_player_name(), nam, showBookFormspec(name, story))
		end,
	})
end