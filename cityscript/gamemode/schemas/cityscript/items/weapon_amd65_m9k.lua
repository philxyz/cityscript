ITEM.Name = "AMD65 (M9K)";
ITEM.Class = "m9k_amd65";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_amd_65.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 255;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give("m9k_amd65")
	self:Remove()
end
