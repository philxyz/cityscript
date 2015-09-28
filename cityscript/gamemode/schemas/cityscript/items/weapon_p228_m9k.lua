ITEM.Name = "P228 (M9K)";
ITEM.Class = "bb_p228_alt";
ITEM.Description = "Pistol";
ITEM.Model = "models/weapons/3_pist_p228.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 92;
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
