ITEM.Name = "Vehicle Driving Guide";
ITEM.Class = "driving";
ITEM.Description = "Rules of the Road";
ITEM.Model = "models/props_lab/binderblue.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 8;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("say /me refers to the book \"Rules of the Road\".");

end
