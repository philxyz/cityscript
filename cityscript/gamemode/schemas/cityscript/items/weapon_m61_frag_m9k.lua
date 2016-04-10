ITEM.Name = "Frag Grenade (M9K)";
ITEM.Class = "m9k_m61_frag";
ITEM.Description = "Grenade";
ITEM.Model = "models/weapons/w_grenade.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 279;
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
