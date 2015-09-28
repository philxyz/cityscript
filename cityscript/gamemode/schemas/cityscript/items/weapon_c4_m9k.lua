ITEM.Name = "C4 (M9K)";
ITEM.Class = "bb_planted_alt_c4";
ITEM.Description = "Take the doors off!";
ITEM.Model = "models/weapons/2_c4_planted.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 60;
ITEM.ItemGroup = 1;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give("bb_css_c4_alt")
	self:Remove()
end
