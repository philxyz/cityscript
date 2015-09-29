ITEM.Name = "Remington 1858 (M9K)";
ITEM.Class = "m9k_remington1858";
ITEM.Description = "Pistol";
ITEM.Model = "models/weapons/w_remington_1858.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 250;
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
