ITEM.Name = "Harpoon (M9K)";
ITEM.Class = "m9k_harpoon";
ITEM.Description = "Harpoon";
ITEM.Model = "models/weapons/w_harpooner.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 850;
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
