ITEM.Name = "SR-3M Vikhr (M9K)";
ITEM.Class = "m9k_vikhr";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_dmg_vally.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 330;
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
