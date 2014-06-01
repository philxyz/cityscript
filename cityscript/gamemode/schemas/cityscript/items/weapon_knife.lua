ITEM.Name = "Knife";
ITEM.Class = "weapon_knife";
ITEM.GiveClass = "weapon_real_cs_knife";
ITEM.Description = "Close-combat";
ITEM.Model = "models/weapons/w_knife_t.mdl";
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
