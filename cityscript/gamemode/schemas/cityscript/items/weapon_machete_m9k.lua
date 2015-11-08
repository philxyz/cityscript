ITEM.Name = "Machete (M9K)";
ITEM.Class = "m9k_machete";
ITEM.Description = "Machete";
ITEM.Model = "models/weapons/w_fc2_machete.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 450;
ITEM.ItemGroup = 5;
ITEM.IncludeAmmo = true

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
