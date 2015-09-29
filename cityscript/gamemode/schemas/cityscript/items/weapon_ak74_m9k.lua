ITEM.Name = "AK74 (M9K)";
ITEM.Class = "m9k_ak74";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_tct_ak47.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 300;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give("m9k_ak74")
	self:Remove()
end
