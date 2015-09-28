ITEM.Name = "Glock 18 (M9K)";
ITEM.Class = "bb_glock_alt";
ITEM.Description = "Pistol";
ITEM.Model = "models/weapons/3_pist_glock18.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 100;
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
