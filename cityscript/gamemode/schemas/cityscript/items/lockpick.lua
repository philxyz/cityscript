ITEM.Name = "Lock Pick";
ITEM.Class = "lockpick";
ITEM.Description = "Locked out? Try this...";
ITEM.Model = "models/weapons/w_crowbar.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 55;
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
