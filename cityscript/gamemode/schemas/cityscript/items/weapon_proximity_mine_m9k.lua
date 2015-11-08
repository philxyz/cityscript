ITEM.Name = "Proximity Mine (M9K)";
ITEM.Class = "m9k_proxy_mine";
ITEM.Description = "Mine";
ITEM.Model = "models/weapons/w_px.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 788;
ITEM.ItemGroup = 5;
ITEM.IncludeAmmo = true

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
