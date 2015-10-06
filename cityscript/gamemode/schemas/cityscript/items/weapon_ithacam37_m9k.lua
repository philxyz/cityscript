ITEM.Name = "Ithaca M37 (M9K)";
ITEM.Class = "m9k_ithacam37";
ITEM.Description = "Shotgun";
ITEM.Model = "models/weapons/w_ithaca_m37.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 330;
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
