ITEM.Name = "PKM (M9K)";
ITEM.Class = "m9k_pkm";
ITEM.Description = "Machine Gun";
ITEM.Model = "models/weapons/w_mach_russ_pkm.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 295;
ITEM.ItemGroup = 6;

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
