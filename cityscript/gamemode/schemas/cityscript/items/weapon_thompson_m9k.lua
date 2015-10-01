ITEM.Name = "Tommy Gun (M9K)";
ITEM.Class = "m9k_thompson";
ITEM.Description = "Sub-Machine Gun";
ITEM.Model = "models/weapons/w_tommy_gun.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 400;
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
