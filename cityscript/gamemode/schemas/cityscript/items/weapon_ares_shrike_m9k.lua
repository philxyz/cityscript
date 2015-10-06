ITEM.Name = "Ares Shrike (M9K)";
ITEM.Class = "m9k_ares_shrike";
ITEM.Description = "Machine Gun";
ITEM.Model = "models/weapons/w_ares_shrike.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 460;
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
