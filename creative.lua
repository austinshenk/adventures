--Creative Mode

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

local function updateGeneralSourceFormspec(meta)
	local formspec = "size[6.25,3]"..
		"label[1,0;Position]"..
		"button[0,1;.75,.5;xminusten;<<]button[.6,1;.75,.5;xminusone;<]label[1.25,.875;"..meta:get_int("x").."]button[1.75,1;.75,.5;xplusone;>]button[2.35,1;.75,.5;xplusten;>>]"..
		"button[0,1.75;.75,.5;yminusten;<<]button[.6,1.75;.75,.5;yminusone;<]label[1.25,1.625;"..meta:get_int("y").."]button[1.75,1.75;.75,.5;yplusone;>]button[2.35,1.75;.75,.5;yplusten;>>]"..
		"button[0,2.5;.75,.5;zminusten;<<]button[.6,2.5;.75,.5;zminusone;<]label[1.25,2.4;"..meta:get_int("z").."]button[1.75,2.5;.75,.5;zplusone;>]button[2.35,2.5;.75,.5;zplusten;>>]"..
		"label[4,0;Dimension]"..
		"button[3.15,1;.75,.5;widthminusten;<<]button[3.75,1;.75,.5;widthminusone;<]label[4.375,.875;"..meta:get_int("width").."]button[4.9,1;.75,.5;widthplusone;>]button[5.5,1;.75,.5;widthplusten;>>]"..
		"button[3.15,1.75;.75,.5;lengthminusten;<<]button[3.75,1.75;.75,.5;lengthminusone;<]label[4.375,1.625;"..meta:get_int("length").."]button[4.9,1.75;.75,.5;lengthplusone;>]button[5.5,1.75;.75,.5;lengthplusten;>>]"..
		"button[3.15,2.5;.75,.5;heightminusten;<<]button[3.75,2.5;.75,.5;heightminusone;<]label[4.375,2.4;"..meta:get_int("height").."]button[4.9,2.5;.75,.5;heightplusone;>]button[5.5,2.5;.75,.5;heightplusten;>>]"
	return formspec
end

for name,source in pairs(adventures.generalSources) do
	minetest.register_entity(source.area.name ,{
		physical = true,
		visual = "cube",
		visual_size = {x=2,y=1},
		collisionbox = {0,0,0,0,0,0},
		textures = {source.area.texture,source.area.texture,source.area.texture,source.area.texture,source.area.texture,source.area.texture},
	})

	minetest.register_node(name ,{
		description = source.description,
		walkable = false,
		groups = {crumbly=3},
		tiles = source.tiles,
		on_construct = function(pos)
			adventures.sources[adventures.positionToString(pos)] = {name=name,pos=pos}
			local meta = minetest.env:get_meta(pos)
			local x = 0
			local y = 0
			local z = 0
			local width = 2
			local length = 2
			local height = 1
			local data = adventures.sourceData[adventures.positionToString(pos)]
			if(data ~= nil) then
				x = data[5]
				y = data[6]
				z = data[7]
				width = data[8]
				length = data[9]
				height = data[10]
			end
			meta:set_int("x", x)
			meta:set_int("y", y)
			meta:set_int("z", z)
			meta:set_int("width", width)
			meta:set_int("length", length)
			meta:set_int("height", height)
			meta:set_string("formspec", updateGeneralSourceFormspec(meta))
			local area = minetest.env:add_entity(pos, source.area.name)
			area:setpos(adventures.snapPosition(meta, pos))
			area:set_properties({visual_size={x=width,y=height}})
		end,
		on_receive_fields = function(pos, formname, fields, sender)
			local meta = minetest.env:get_meta(pos)
			local delta = {x=0,y=0,z=0}
			local updateDimension = false
			if fields.xminusten then delta.x = -10
			meta:set_int("x", meta:get_int("x")-10) end
			if fields.xminusone then delta.x = -1
			meta:set_int("x", meta:get_int("x")-1) end
			if fields.xplusone then delta.x = 1
			meta:set_int("x", meta:get_int("x")+1) end
			if fields.xplusten then delta.x = 10
			meta:set_int("x", meta:get_int("x")+10) end
			
			if fields.yminusten then delta.y = -10
			meta:set_int("y", meta:get_int("y")-10) end
			if fields.yminusone then delta.y = -1
			meta:set_int("y", meta:get_int("y")-1) end
			if fields.yplusone then delta.y = 1
			meta:set_int("y", meta:get_int("y")+1) end
			if fields.yplusten then delta.y = 10
			meta:set_int("y", meta:get_int("y")+10) end
			
			if fields.zminusten then delta.z = -10
			meta:set_int("z", meta:get_int("z")-10) end
			if fields.zminusone then delta.z = -1
			meta:set_int("z", meta:get_int("z")-1) end
			if fields.zplusone then delta.z = 1
			meta:set_int("z", meta:get_int("z")+1) end
			if fields.zplusten then delta.z = 10
			meta:set_int("z", meta:get_int("z")+10) end
			
			if fields.widthminusten then updateDimension = true
			meta:set_int("width", meta:get_int("width")-10) end
			if fields.widthminusone then updateDimension = true
			meta:set_int("width", meta:get_int("width")-1) end
			if fields.widthplusone then updateDimension = true
			meta:set_int("width", meta:get_int("width")+1) end
			if fields.widthplusten then updateDimension = true
			meta:set_int("width", meta:get_int("width")+10) end
			
			if fields.lengthminusten then updateDimension = true
			meta:set_int("length", meta:get_int("length")-10) end
			if fields.lengthminusone then updateDimension = true
			meta:set_int("length", meta:get_int("length")-1) end
			if fields.lengthplusone then updateDimension = true
			meta:set_int("length", meta:get_int("length")+1) end
			if fields.lengthplusten then updateDimension = true
			meta:set_int("length", meta:get_int("length")+10) end
			
			if fields.heightminusten then updateDimension = true
			meta:set_int("height", meta:get_int("height")-10) end
			if fields.heightminusone then updateDimension = true
			meta:set_int("height", meta:get_int("height")-1) end
			if fields.heightplusone then updateDimension = true
			meta:set_int("height", meta:get_int("height")+1) end
			if fields.heightplusten then updateDimension = true
			meta:set_int("height", meta:get_int("height")+10) end
			
			local area = adventures.findArea(meta, pos, delta)
			if updateDimension then
				area:set_properties({visual_size={x=meta:get_int("width"),y=meta:get_int("height")}})
			end
			area:setpos(adventures.snapPosition(meta, pos))
			meta:set_string("formspec", updateGeneralSourceFormspec(meta))
		end,
		on_destruct = function(pos)
			adventures.sources[adventures.positionToString(pos)] = nil
			local area = adventures.findArea(minetest.env:get_meta(pos), pos, {x=0,y=0,z=0})
			if(area ~= nil) then area:remove() end
		end,
	})
end

local function updateIDSourceFormspec(meta)
	local formspec = "size[6.25,4.5]"..
		"label[1,0;Position]"..
		"button[0,1;.75,.5;xminusten;<<]button[.6,1;.75,.5;xminusone;<]label[1.25,.875;"..meta:get_int("x").."]button[1.75,1;.75,.5;xplusone;>]button[2.35,1;.75,.5;xplusten;>>]"..
		"button[0,1.75;.75,.5;yminusten;<<]button[.6,1.75;.75,.5;yminusone;<]label[1.25,1.625;"..meta:get_int("y").."]button[1.75,1.75;.75,.5;yplusone;>]button[2.35,1.75;.75,.5;yplusten;>>]"..
		"button[0,2.5;.75,.5;zminusten;<<]button[.6,2.5;.75,.5;zminusone;<]label[1.25,2.4;"..meta:get_int("z").."]button[1.75,2.5;.75,.5;zplusone;>]button[2.35,2.5;.75,.5;zplusten;>>]"..
		"label[4,0;Dimension]"..
		"button[3.15,1;.75,.5;widthminusten;<<]button[3.75,1;.75,.5;widthminusone;<]label[4.375,.875;"..meta:get_int("width").."]button[4.9,1;.75,.5;widthplusone;>]button[5.5,1;.75,.5;widthplusten;>>]"..
		"button[3.15,1.75;.75,.5;lengthminusten;<<]button[3.75,1.75;.75,.5;lengthminusone;<]label[4.375,1.625;"..meta:get_int("length").."]button[4.9,1.75;.75,.5;lengthplusone;>]button[5.5,1.75;.75,.5;lengthplusten;>>]"..
		"button[3.15,2.5;.75,.5;heightminusten;<<]button[3.75,2.5;.75,.5;heightminusone;<]label[4.375,2.4;"..meta:get_int("height").."]button[4.9,2.5;.75,.5;heightplusone;>]button[5.5,2.5;.75,.5;heightplusten;>>]"..
		"label[2.875,3.125;ID]"..
		"button[1.5,4;.75,.5;idminusten;<<]button[2.1,4;.75,.5;idminusone;<]label[2.75,3.875;"..meta:get_int("id").."]button[3.325,4;.75,.5;idplusone;>]button[3.925,4;.75,.5;idplusten;>>]"
	return formspec
end
local function updateIDSourceInfotext(meta)
	return "ID is "..meta:get_int("id")
end

for name,source in pairs(adventures.generalIDSources) do
	minetest.register_entity(source.area.name ,{
		physical = true,
		visual = "cube",
		visual_size = {x=2,y=1},
		collisionbox = {0,0,0,0,0,0},
		textures = {source.area.texture,source.area.texture,source.area.texture,source.area.texture,source.area.texture,source.area.texture},
	})

	minetest.register_node(name ,{
		description = source.description,
		walkable = false,
		groups = {crumbly=3},
		tiles = source.tiles,
		on_construct = function(pos)
			adventures.sources[adventures.positionToString(pos)] = {name=name,pos=pos}
			local meta = minetest.env:get_meta(pos)
			local x = 0
			local y = 0
			local z = 0
			local width = 2
			local length = 2
			local height = 1
			local id = 0
			local data = adventures.sourceData[adventures.positionToString(pos)]
			if(data ~= nil) then
				x = data[5]
				y = data[6]
				z = data[7]
				width = data[8]
				length = data[9]
				height = data[10]
				id = data[11]
			end
			meta:set_int("x", x)
			meta:set_int("y", y)
			meta:set_int("z", z)
			meta:set_int("width", width)
			meta:set_int("length", length)
			meta:set_int("height", height)
			meta:set_int("id", id)
			meta:set_string("formspec", updateIDSourceFormspec(meta))
			meta:set_string("infotext", updateIDSourceInfotext(meta))
			local area = minetest.env:add_entity(pos, source.area.name)
			area:setpos(adventures.snapPosition(meta, pos))
			area:set_properties({visual_size={x=width,y=height}})
		end,
		on_receive_fields = function(pos, formname, fields, sender)
			local meta = minetest.env:get_meta(pos)
			local delta = {x=0,y=0,z=0}
			local updateDimension = false
			if fields.xminusten then delta.x = -10
			meta:set_int("x", meta:get_int("x")-10) end
			if fields.xminusone then delta.x = -1
			meta:set_int("x", meta:get_int("x")-1) end
			if fields.xplusone then delta.x = 1
			meta:set_int("x", meta:get_int("x")+1) end
			if fields.xplusten then delta.x = 10
			meta:set_int("x", meta:get_int("x")+10) end
			
			if fields.yminusten then delta.y = -10
			meta:set_int("y", meta:get_int("y")-10) end
			if fields.yminusone then delta.y = -1
			meta:set_int("y", meta:get_int("y")-1) end
			if fields.yplusone then delta.y = 1
			meta:set_int("y", meta:get_int("y")+1) end
			if fields.yplusten then delta.y = 10
			meta:set_int("y", meta:get_int("y")+10) end
			
			if fields.zminusten then delta.z = -10
			meta:set_int("z", meta:get_int("z")-10) end
			if fields.zminusone then delta.z = -1
			meta:set_int("z", meta:get_int("z")-1) end
			if fields.zplusone then delta.z = 1
			meta:set_int("z", meta:get_int("z")+1) end
			if fields.zplusten then delta.z = 10
			meta:set_int("z", meta:get_int("z")+10) end
			
			if fields.widthminusten then updateDimension = true
			meta:set_int("width", meta:get_int("width")-10) end
			if fields.widthminusone then updateDimension = true
			meta:set_int("width", meta:get_int("width")-1) end
			if fields.widthplusone then updateDimension = true
			meta:set_int("width", meta:get_int("width")+1) end
			if fields.widthplusten then updateDimension = true
			meta:set_int("width", meta:get_int("width")+10) end
			
			if fields.lengthminusten then updateDimension = true
			meta:set_int("length", meta:get_int("length")-10) end
			if fields.lengthminusone then updateDimension = true
			meta:set_int("length", meta:get_int("length")-1) end
			if fields.lengthplusone then updateDimension = true
			meta:set_int("length", meta:get_int("length")+1) end
			if fields.lengthplusten then updateDimension = true
			meta:set_int("length", meta:get_int("length")+10) end
			
			if fields.heightminusten then updateDimension = true
			meta:set_int("height", meta:get_int("height")-10) end
			if fields.heightminusone then updateDimension = true
			meta:set_int("height", meta:get_int("height")-1) end
			if fields.heightplusone then updateDimension = true
			meta:set_int("height", meta:get_int("height")+1) end
			if fields.heightplusten then updateDimension = true
			meta:set_int("height", meta:get_int("height")+10) end
			
			if fields.idminusten then meta:set_int("id", meta:get_int("id")-10) end
			if fields.idminusone then meta:set_int("id", meta:get_int("id")-1) end
			if fields.idplusone then meta:set_int("id", meta:get_int("id")+1) end
			if fields.idplusten then meta:set_int("id", meta:get_int("id")+10) end
			
			local area = adventures.findArea(meta, pos, delta)
			if updateDimension then
				area:set_properties({visual_size={x=meta:get_int("width"),y=meta:get_int("height")}})
			end
			area:setpos(adventures.snapPosition(meta, pos))
			meta:set_string("formspec", updateIDSourceFormspec(meta))
			meta:set_string("infotext", updateIDSourceInfotext(meta))
		end,
		on_destruct = function(pos)
			adventures.sources[adventures.positionToString(pos)] = nil
			local area = adventures.findArea(minetest.env:get_meta(pos), pos, {x=0,y=0,z=0})
			if(area ~= nil) then area:remove() end
		end,
	})
end

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
		local data = adventures.sourceData[adventures.positionToString(pos)]
		if(data ~= nil) then
		end
	end,
	on_destruct = function(pos)
		adventures.sources[adventures.positionToString(pos)] = nil
	end,
})
	
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