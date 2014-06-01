ITEM.Name = "Crowbar";
ITEM.Class = "weapon_crowbar";
ITEM.Description = "Gordon Freeman Limited Edition Crowbar";
ITEM.Model = "models/weapons/w_crowbar.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 50;
ITEM.ItemGroup = 5;

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
