ITEM.Name = "Fire Extinguisher";
ITEM.Class = "fire_extinguisher";
ITEM.Description = "Pull tag hard, aim and squeeze trigger";
ITEM.Model = "models/weapons/w_fire_extinguisher.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 120;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)
	self:Remove();
end

function ITEM:UseItem(ply)
	ply:Give(self.Class)
	self:Remove()
end
