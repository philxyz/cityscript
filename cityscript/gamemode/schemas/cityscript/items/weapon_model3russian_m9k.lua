ITEM.Name = "S&W Model 3 Russian PDR (M9K)";
ITEM.Class = "m9k_model3russian";
ITEM.Description = "Pistol";
ITEM.Model = "models/weapons/w_model_3_rus.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 210;
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
