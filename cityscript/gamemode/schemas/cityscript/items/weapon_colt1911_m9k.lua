ITEM.Name = "Colt 1911 (M9K)";
ITEM.Class = "m9k_colt1911";
ITEM.Description = "Pistol";
ITEM.Model = "models/weapons/s_dmgf_co1911.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 160;
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
