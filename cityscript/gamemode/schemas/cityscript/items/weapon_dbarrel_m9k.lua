ITEM.Name = "Double Barrel Shotgun (M9K)";
ITEM.Class = "m9k_dbarrel";
ITEM.Description = "Shotgun";
ITEM.Model = "models/weapons/w_double_barrel_shotgun.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 180;
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
