ITEM.Name = "Stun Baton";
ITEM.Class = "weapon_stunstick";
ITEM.Description = "Police Issue";
ITEM.Model = "models/weapons/w_stunbaton.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 280;
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
