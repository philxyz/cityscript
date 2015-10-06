ITEM.Name = "SPAS 12 (M9K)";
ITEM.Class = "m9k_spas12";
ITEM.Description = "12-bore Shotgun";
ITEM.Model = "models/weapons/w_spas_12.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 545;
ITEM.ItemGroup = 6;

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
