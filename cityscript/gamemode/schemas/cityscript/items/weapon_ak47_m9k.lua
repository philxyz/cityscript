ITEM.Name = "Kalashnikov AK47 (M9K)";
ITEM.Class = "bb_ak47_alt";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/3_rif_ak47.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 230;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give("bb_ak47_alt")
	self:Remove()
end
