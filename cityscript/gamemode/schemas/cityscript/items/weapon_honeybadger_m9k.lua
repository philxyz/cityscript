ITEM.Name = "Honey Badger (M9K)";
ITEM.Class = "m9k_honeybadger";
ITEM.Description = "Sub-Machine Gun";
ITEM.Model = "models/weapons/w_aac_honeybadger.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 252;
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
