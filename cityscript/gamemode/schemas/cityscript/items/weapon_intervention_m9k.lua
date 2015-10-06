ITEM.Name = "Intervention (M9K)";
ITEM.Class = "m9k_intervention";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/w_snip_int.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 695;
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
