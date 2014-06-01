ITEM.Name = "Overwatch Standard-Issue AR2";
ITEM.Class = "weapon_ar2";
ITEM.Description = "Pulse Rifle Technology";
ITEM.Model = "models/weapons/w_irifle.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 1500;
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
