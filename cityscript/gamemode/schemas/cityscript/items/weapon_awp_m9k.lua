ITEM.Name = "Arctic Warfare Magnum (M9K)";
ITEM.Class = "bb_awp_alt";
ITEM.Description = "Assault Rifle";
ITEM.Model = "models/weapons/3_snip_awp.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 650;
ITEM.ItemGroup = 3;

function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)
	CAKE.Response(ply, self.Name .. " placed in backpack!")
	self:Remove()
end

function ITEM:UseItem(ply)
	ply:Give("bb_awp_alt")
	self:Remove()
end
