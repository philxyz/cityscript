ITEM.Name = "Banana bunch"
ITEM.Class = "bananabunch"
ITEM.Description = "n + 1 bananas."
ITEM.Model = "models/props/cs_italy/bananna_bunch.mdl"
ITEM.Purchaseable = true
ITEM.Price = 10
ITEM.ItemGroup = 2

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:ConCommand("say " .. TEXT.SlashMeCommand .. " eats a whole bunch of bananas. What? I was hungry!")
	ply:SetHealth(math.Clamp(ply:Health() + 15, 0, ply:MaxHealth()))
	self:Remove()
end
