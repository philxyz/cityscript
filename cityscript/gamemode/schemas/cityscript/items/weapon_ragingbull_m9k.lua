ITEM.Name = "Raging Bull (M9K)";
ITEM.Class = "m9k_ragingbull";
ITEM.Description = "Pistol";
ITEM.Model = "models/weapons/w_taurus_raging_bull.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 205;
ITEM.ItemGroup = 3;

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
