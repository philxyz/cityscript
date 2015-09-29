ITEM.Name = "ACR (M9K)";
ITEM.Class = "m9k_acr";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_masada_acr.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 355;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give("m9k_acr")
	self:Remove()
end
