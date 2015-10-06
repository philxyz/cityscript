ITEM.Name = "Browning Auto 5 (M9K)";
ITEM.Class = "m9k_browningauto5";
ITEM.Description = "Shotgun";
ITEM.Model = "models/weapons/w_browning_auto.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 415;
ITEM.ItemGroup = 6;

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
