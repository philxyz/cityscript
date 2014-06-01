ITEM.Name = "Arctic Warfare Magnum";
ITEM.Class = "weapon_awp";
ITEM.GiveClass = "weapon_real_cs_awp";
ITEM.Description = "Sniper Rifle";
ITEM.Model = "models/weapons/w_snip_awp.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 0;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give(self.GiveClass)
	self:Remove()
end
