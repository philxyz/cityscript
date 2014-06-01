ITEM.Name = ".357 Magnum";
ITEM.Class = "weapon_357";
ITEM.Description = "Not for the rookies.";
ITEM.Model = "models/weapons/w_357.mdl";
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
