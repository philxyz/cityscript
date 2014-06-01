ITEM.Name = "Unarrest Stick";
ITEM.Class = "unarrest_stick";
ITEM.Description = "Police Issue";
ITEM.Model = "models/weapons/w_stunbaton.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 580;
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
