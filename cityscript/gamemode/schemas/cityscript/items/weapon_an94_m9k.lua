ITEM.Name = "AN94 (M9K)";
ITEM.Class = "m9k_an94";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_rif_an_94.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 245;
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
