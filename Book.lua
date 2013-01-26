local function showBookFormspec(name, story)
	local str =  "size[5,9]label[0,0;"..name.."]"
	for i,line in ipairs(story) do
		str = str.."label[0,"..((i*0.5)+0.5)..";"..line.."]"
	end
	return str
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