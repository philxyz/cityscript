ITEM.Name = "A Random Day";
ITEM.Class = "arandomday";
ITEM.Description = "A book about a random day.";
ITEM.Model = "models/props_lab/binderblue.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 4;
ITEM.ItemGroup = 2;

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("say /me reads some of the book: \"A Random Day\"");

end
