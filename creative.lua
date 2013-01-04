--Creative Mode

function adventures.snapPosition(meta, pos)
	local newPos = {x=pos.x,y=pos.y,z=pos.z}
	if(meta:get_int("width")%2 == 0) then
		newPos.x = newPos.x-0.5
		newPos.z = newPos.z-0.5
	end
	if(meta:get_int("height")%2 == 0) then
		newPos.y = newPos.y+0.5
	end
	newPos.x = newPos.x+meta:get_int("x")
	newPos.y = newPos.y+meta:get_int("y")
	newPos.z = newPos.z+meta:get_int("z")
	return newPos
end

function adventures.findArea(meta, pos, delta)
	local node = minetest.env:get_node(pos)
	local areaPos = {x=pos.x+meta:get_int("x")-delta.x,y=pos.y+meta:get_int("y")-delta.y,z=pos.z+meta:get_int("z")-delta.z}
	local objects = minetest.env:get_objects_inside_radius(areaPos, 1)
	local name = node.name:sub(1,-7).."area"
	for i,_ in ipairs(objects) do
		if(objects[i]:get_entity_name() == name) then
			return objects[i]
		end
	end
end

local function updateInvincibleSourceFormspec(meta)
	local formspec = "size[6.25,3]"..
		"label[1,0;Position]"..
		"button[0,1;.75,.5;xminusten;-10]button[.5,1;.75,.5;xminusone;-1]label[1.125,.825;X("..meta:get_int("x")..")]button[1.5,1;.75,.5;xplusone;+1]button[2,1;.75,.5;xplusten;+10]"..
		"button[0,1.5;.75,.5;yminusten;-10]button[.5,1.5;.75,.5;yminusone;-1]label[1.125,1.325;Y("..meta:get_int("y")..")]button[1.5,1.5;.75,.5;yplusone;+1]button[2,1.5;.75,.5;yplusten;+10]"..
		"button[0,2;.75,.5;zminusten;-10]button[.5,2;.75,.5;zminusone;-1]label[1.125,1.825;Z("..meta:get_int("z")..")]button[1.5,2;.75,.5;zplusone;+1]button[2,2;.75,.5;zplusten;+10]"..
		"label[4.5,0;Dimension]"..
		"button[3.5,1;.75,.5;widthminusten;-10]button[4,1;.75,.5;widthminusone;-1]label[4.625,.825;W("..meta:get_int("width")..")]button[5,1;.75,.5;widthplusone;+1]button[5.5,1;.75,.5;widthplusten;+10]"..
		"button[3.5,1.5;.75,.5;lengthminusten;-10]button[4,1.5;.75,.5;lengthminusone;-1]label[4.625,1.325;L("..meta:get_int("length")..")]button[5,1.5;.75,.5;lengthplusone;+1]button[5.5,1.5;.75,.5;lengthplusten;+10]"..
		"button[3.5,2;.75,.5;heightminusten;-10]button[4,2;.75,.5;heightminusone;-1]label[4.625,1.825;H("..meta:get_int("height")..")]button[5,2;.75,.5;heightplusone;+1]button[5.5,2;.75,.5;heightplusten;+10]"
	return formspec
end

minetest.register_entity("adventures:invincible_area" ,{
	physical = true,
	visual = "cube",
	visual_size = {x=2,y=1},
	collisionbox = {0,0,0,0,0,0},
	textures = {"adventures_invinArea.png","adventures_invinArea.png","adventures_invinArea.png","adventures_invinArea.png","adventures_invinArea.png","adventures_invinArea.png"},
})

minetest.register_node("adventures:invincible_source" ,{
	description = "Invincible Area",
	walkable = false,
	groups = {crumbly=3},
	tiles = {"adventures_invinSource.png"},
	on_construct = function(pos)
		adventures.sources[pos] = minetest.env:get_node(pos).name
		local meta = minetest.env:get_meta(pos)
		meta:set_int("x", 0)
		meta:set_int("y", 0)
		meta:set_int("z", 0)
		meta:set_int("width", 2)
		meta:set_int("length", 2)
		meta:set_int("height", 1)
		meta:set_string("formspec", updateInvincibleSourceFormspec(meta))
		local area = minetest.env:add_entity(pos, "adventures:invincible_area")
		area:setpos(adventures.snapPosition(meta, pos))
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
		meta:set_string("formspec", updateInvincibleSourceFormspec(meta))
	end,
	on_destruct = function(pos)
		adventures.findArea(minetest.env:get_meta(pos), pos, {x=0,y=0,z=0}):remove()
	end,
})

minetest.register_chatcommand("saveAdventure", {
	description = "saveAdventure : Save all node data to files",
	func = function(name, param)
		dofile(minetest.get_modpath("adventures").."/encode.lua")
		print(name)
	end,
})