ITEM.Name = "Remington 870 (M9K)";
ITEM.Class = "m9k_remington870";
ITEM.Description = "Shotgun";
ITEM.Model = "models/weapons/w_remington_870_tact.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 496;
ITEM.ItemGroup = 5;

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
