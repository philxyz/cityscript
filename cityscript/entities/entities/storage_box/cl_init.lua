include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

usermessage.Hook("_storage_box_reset", function(m)
	local entIndex = m:ReadShort()
	Entity(entIndex).contents = {}
end)

usermessage.Hook("_storage_box_icon", function(m)
	local entIndex = m:ReadShort()
	local i = m:ReadShort()
	local itemClass = m:ReadString()
	local itemName = m:ReadString()
	local itemModel = m:ReadString()

	local e = Entity(entIndex)
	if not e.contents then e.contents = {} end
	e.contents[i] = {itemClass, itemName, itemModel}
end)

usermessage.Hook("_storage_box_open", function(m)
	-- Create a derma frame with space for 16 tiles
	local frame = vgui.Create("DFrame")
	frame:SetSize(281, 304)
	frame:SetPos(ScrW()/2 - 141, ScrH()/2 - 152)
	frame:SetTitle("Storage Box")

	local x, y = 5, 28

	-- For each item, create a spawn icon
	local entIndex = m:ReadShort()
	local en = Entity(entIndex)
	if not en.contents then en.contents = {} end
	local size = #en.contents
	for i=1, size do
		if x > 212 then x = 5; y = y + 69 end

		local itemclass = en.contents[i][1]
		local itemname = en.contents[i][2]
		local itemmodel = en.contents[i][3]

		local si = vgui.Create("SpawnIcon", frame)
		si:SetSize(64, 64)
		si:SetPos(x, y)
		si:SetModel(itemmodel)
		si:SetToolTip(itemname)
		si.DoClick = function(e)
			RunConsoleCommand("drrp_storage_box_spawn", tostring(entIndex), tostring(i))
			frame:Close()
		end

		x = x + 69
	end
end)
