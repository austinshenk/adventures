--Creative Mode
local modpath=minetest.get_modpath("adventures")
dofile(modpath.."/creativeGeneral.lua")
dofile(modpath.."/creativeInitialStuff.lua")
dofile(modpath.."/creativeQuest.lua")
dofile(modpath.."/Book.lua")

minetest.register_on_joinplayer(function(obj)
	if adventures.started then return end
	local file = io.open(minetest.get_worldpath().."/adventures_previousmode", "r")
	if(file:read("*l") ~= adventures.creative) then
		file:close()
		for pos,data in pairs(adventures.sourceData) do
			minetest.env:set_node({x=data[2],y=data[3],z=data[4]}, {name=data[1]})
		end
		file = io.open(minetest.get_worldpath().."/adventures_previousmode", "w")
		file:write(adventures.creative)
		file:close()
	else
		file:close()
		for pos,data in pairs(adventures.sourceData) do
			adventures.sources[adventures.positionToString(pos)] = {name=data[1],pos={x=data[2],y=data[3],z=data[4]}}
		end
	end
	adventures.started = true
end)
	
minetest.register_chatcommand("save", {
	description = "saveAdventure : Save all node data to files",
	func = function(name, param)
		local saved = dofile(minetest.get_modpath("adventures").."/encode.lua")
		if saved then
			minetest.chat_send_player(name, "ADVENTURE SAVED")
		else
			minetest.chat_send_player(name, "ADVENTURE NOT SAVED")
		end
	end,
})


local function showBookData(name)
	local lines = adventures.registered_books[name]
	local story = ""
	for _,line in pairs(lines) do
		story = story..line.."\n"
	end
	return "size[5,5]field[0.25,0.25;3,1;bookname;;"..name.."]textarea[0.25,1;5,4;bookstory;;"..story.."]"..
			"button[2.75,0;1,0.75;bookreturn;<-]button[3.5,0;1,0.75;booksave;Save]button[4.5,0;.75,.75;bookdelete;X]"
end
local function showBookList()
	local str = "field[0.25,0.25;4,1;bookname;;]button[4,0;1.5,0.75;bookcreate;Create]"
	local x = 0
	local y = 1
	for name,story in pairs(adventures.registered_books) do
		if story ~= nil then
			str = str.."button["..x..","..y..";1.25,0.75;"..name..";"..name.."]"
			x = x+1
			if x == 5 then
				x = 0
				y = y+1
			end
		end
	end
	str = "size[5.5,"..(y+3).."]"..str
	return str
end
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields.bookreturn then
		minetest.show_formspec(player:get_player_name(), "adventures:books", showBookList())
	end
	if fields.bookcreate then
		adventures.registered_books[fields.bookname] = {}
		print("NAME: "..fields.bookname)
		minetest.show_formspec(player:get_player_name(), "adventures:books", showBookList())
	end
	if fields.bookdelete then
		adventures.registered_books[fields.bookname] = nil
		minetest.show_formspec(player:get_player_name(), "adventures:books", showBookList())
	end
	if fields.booksave then
		local lines = fields.bookstory:split("\n")
		local story = {}
		for _,line in pairs(lines) do
			table.insert(story, line)
		end
		adventures.registered_books[fields.bookname] = story
		minetest.show_formspec(player:get_player_name(), "adventures:book("..fields.bookname..")", showBookData(fields.bookname))
	end
	for name,story in pairs(adventures.registered_books) do
		if fields[name] then
			minetest.show_formspec(player:get_player_name(), "adventures:book("..name..")", showBookData(name))
		end
	end
end)
minetest.register_chatcommand("books", {
	description = "saveAdventure : Save all node data to files",
	func = function(name, param)
		minetest.show_formspec(name, "adventures:books", showBookList())
	end,
})