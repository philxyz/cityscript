ITEM.Name = "Orbital Striker Marker (M9K)";
ITEM.Class = "m9k_orbital_strike";
ITEM.Description = "Star-Wars Program";
ITEM.Model = "models/weapons/w_binos.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 57390;
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
