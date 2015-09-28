ITEM.Name = "Scout (M9K)";
ITEM.Class = "bb_scout_alt";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/3_snip_scout.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 490;
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
