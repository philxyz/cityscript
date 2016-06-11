ITEM.Name = "Mega Energy Drink"
ITEM.Class = "energy_drink"
ITEM.Description = "Go hiper!"
ITEM.Model = "models/props_junk/garbage_plasticbottle001a.mdl"
ITEM.Purchaseable = true
ITEM.Price = 10
ITEM.ItemGroup = 2

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:ConCommand("say " .. TEXT.SlashMeCommand .. " downs an energy drink.")
	ply:SetHealth(math.Clamp(ply:Health() + 8, 0, ply:MaxHealth()))
	self:Remove()
end
