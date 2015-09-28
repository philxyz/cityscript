ITEM.Name = "Frag Grenade (M9K)";
ITEM.Class = "bb_cssfrag_alt";
ITEM.Description = "Take out a group of enemies.";
ITEM.Model = "models/weapons/w_eq_fraggrenade_thrown.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 250;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give("bb_cssfrag_alt")
	self:Remove()
end
