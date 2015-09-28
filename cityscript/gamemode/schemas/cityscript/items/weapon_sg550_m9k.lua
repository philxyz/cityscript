ITEM.Name = "SG550 (M9K)";
ITEM.Class = "bb_sg550_alt";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/3_snip_sg550.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 515;
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
