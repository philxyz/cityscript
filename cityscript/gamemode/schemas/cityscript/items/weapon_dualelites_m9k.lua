ITEM.Name = "Dual Elites (M9K)";
ITEM.Class = "bb_dualelites_alt";
ITEM.Description = "Pistol";
ITEM.Model = "models/weapons/w_pist_elite.mdl";
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
	ply:Give("bb_dualelites_alt")
	self:Remove()
end
