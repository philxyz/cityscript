ITEM.Name = "Flashbang";
ITEM.Class = "weapon_flash";
ITEM.GiveClass = "weapon_real_cs_flash";
ITEM.Description = "Provide some momentary cover!";
ITEM.Model = "models/weapons/w_eq_flashbang.mdl";
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
