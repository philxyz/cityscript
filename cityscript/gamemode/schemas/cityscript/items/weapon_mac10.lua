ITEM.Name = "Mac10";
ITEM.Class = "weapon_mac10";
ITEM.GiveClass = "weapon_real_cs_mac10";
ITEM.Description = "Sub Machine Gun";
ITEM.Model = "models/weapons/w_smg_mac10.mdl";
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
