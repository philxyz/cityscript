ITEM.Name = "M92 Beretta (M9K)";
ITEM.Class = "m9k_m92beretta";
ITEM.Description = "Pistols";
ITEM.Model = "models/weapons/w_beretta_m92.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 150;
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
