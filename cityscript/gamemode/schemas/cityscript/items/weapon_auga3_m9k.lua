ITEM.Name = "AUG A3 (M9K)";
ITEM.Class = "m9k_auga3";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/w_auga3.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 260;
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
