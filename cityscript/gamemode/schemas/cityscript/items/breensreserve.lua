ITEM.Name = "Breens Reserve"
ITEM.Class = "breensreserve"
ITEM.Description = "Breens 'special' water"
ITEM.Model = "models/props_junk/popcan01a.mdl"
ITEM.Purchaseable = true
ITEM.Price = 4
ITEM.ItemGroup = 2

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:ConCommand("say " .. TEXT.SlashMeCommand .. " drinks some water")
	ply:SetHealth(math.Clamp(ply:Health() + 10, 0, ply:MaxHealth()))
	self:Remove()
end
