ITEM.Name = "Crossbow";
ITEM.Class = "weapon_crossbow";
ITEM.Description = "High-velocity crossbow";
ITEM.Model = "models/weapons/w_crossbow.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 600;
ITEM.ItemGroup = 5;

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
