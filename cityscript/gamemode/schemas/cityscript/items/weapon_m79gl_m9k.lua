ITEM.Name = "M79 GL (M9K)";
ITEM.Class = "m9k_m79gl";
ITEM.Description = "Grenade Launcher";
ITEM.Model = "models/weapons/w_m79_grenadelauncher.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 595;
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
