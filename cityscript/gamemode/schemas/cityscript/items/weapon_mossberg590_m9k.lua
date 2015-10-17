ITEM.Name = "Mossberg 590 (M9K)";
ITEM.Class = "m9k_mossberg590";
ITEM.Description = "Shotgun";
ITEM.Model = "models/weapons/w_mossberg_590.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 446;
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
