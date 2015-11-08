ITEM.Name = "Nitroglycerin (M9K)";
ITEM.Class = "m9k_nitro";
ITEM.Description = "Explosives";
ITEM.Model = "models/weapons/w_nitro.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 2310;
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
