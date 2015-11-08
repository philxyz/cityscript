ITEM.Name = "Timed C4 Belt (M9K)"
ITEM.Class = "m9k_suicide_bomb"
ITEM.Description = "Belt"
ITEM.Model = "models/weapons/w_sb.mdl"
ITEM.Purchaseable = true
ITEM.Price = 2700
ITEM.ItemGroup = 5
ITEM.IncludeAmmo = true

function ITEM:Drop(ply)
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give(self.Class)
	self:Remove()
end
