include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

net.Receive("C5", function(_, ply)
	local entIndex = net.ReadInt(16)
	Entity(entIndex).contents = {}
end)

net.Receive("C4", function(_, ply)
	local nEntries = net.ReadInt(16)

	for j=1, nEntries do
		local entIndex = net.ReadInt(16)
		local i = net.ReadInt(16)
		local itemClass = net.ReadString()
		local itemName = net.ReadString()
		local itemModel = net.ReadString()

		local e = Entity(entIndex)

		if not e.contents then e.contents = {} end

		e.contents[i] = {itemClass, itemName, itemModel}
	end
end)

net.Receive("C3", function(_, ply)
	-- Create a derma frame with space for 16 tiles
	local frame = vgui.Create("DFrame")
	frame:SetSize(281, 304)
	frame:SetPos(ScrW()/2 - 141, ScrH()/2 - 152)
	frame:SetTitle("Storage Box")

	local x, y = 5, 28

	-- For each item, create a spawn icon
	local entIndex = net.ReadInt(16)
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
			-- Open storage box
			net.Start("Cs")
			net.WriteInt(entIndex, 16)
			net.WriteInt(i, 16)
			net.SendToServer()
			frame:Close()
		end

		x = x + 69
	end
end)
