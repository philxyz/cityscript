ITEM.Name = "G3SG1 (M9K)";
ITEM.Class = "bb_g3sg1_alt";
ITEM.Description = "360 Noscope";
ITEM.Model = "models/weapons/3_snip_g3sg1.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 450;
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
