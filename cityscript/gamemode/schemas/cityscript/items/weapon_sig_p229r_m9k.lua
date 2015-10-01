ITEM.Name = "SIG Sauer P229R (M9K)";
ITEM.Class = "m9k_sig_p229r";
ITEM.Description = "Pistol";
ITEM.Model = "models/weapons/w_sig_229r.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 190;
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
