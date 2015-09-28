ITEM.Name = "TMP (M9K)";
ITEM.Class = "bb_tmp_alt";
ITEM.Description = "Machine Pistol";
ITEM.Model = "models/weapons/3_smg_tmp.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 235;
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
