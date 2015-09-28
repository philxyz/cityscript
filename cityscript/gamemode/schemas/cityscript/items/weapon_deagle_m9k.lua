ITEM.Name = "D.Eagle (M9K)";
ITEM.Class = "bb_deagle_alt";
ITEM.Description = "Pistol";
ITEM.Model = "models/weapons/3_pist_deagle.mdl";
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
	ply:Give("bb_deagle_alt")
	self:Remove()
end
