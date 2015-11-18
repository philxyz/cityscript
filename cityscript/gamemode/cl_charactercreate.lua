-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_charactercreate.lua
-- Houses some functions for the character creation.
-------------------------------

TeamTable = {}

net.Receive("Ct", function(len, ply)
	local count = net.ReadInt(32)
	for i=1, count do
		local newteam = {}
		newteam.id = net.ReadInt(32)
		newteam.name = net.ReadString()
		newteam.r = net.ReadInt(16)
		newteam.g = net.ReadInt(16)
		newteam.b = net.ReadInt(16)
		newteam.a = net.ReadInt(16)
		newteam.public = net.ReadBool()
		newteam.salary = net.ReadInt(32)
		newteam.flagkey = net.ReadString()
		newteam.business = net.ReadBool()
	
		team.SetUp(newteam.id, newteam.name, Color(newteam.r, newteam.g, newteam.b, newteam.a))
		TeamTable[newteam.id] = newteam
	end
end)

ChosenModel = ""
ValidCakeModels = {}

function AddModel(data)
	table.insert(ValidCakeModels, data:ReadString())
end
usermessage.Hook("addmodel", AddModel)

function SetChosenModel(mdl)
	if table.HasValue(ValidCakeModels, mdl) then
		ChosenModel = mdl
	else
		LocalPlayer():PrintMessage(3, CAKE.ChosenModel .. TEXT.XisNotAValidModel)
	end
end

ExistingChars = {}

function ReceiveChar(data)
	local n = data:ReadLong()
	ExistingChars[n] = {}
	ExistingChars[n].name = data:ReadString()
	ExistingChars[n].model = data:ReadString()
	
end
usermessage.Hook("ReceiveChar", ReceiveChar)

local function CharacterCreatePanel(msg)
	CreatePlayerMenu()
	PlayerMenu:ShowCloseButton(false)
	PropertySheet:SetActiveTab(PropertySheet.Items[2].Tab)
	PropertySheet.SetActiveTab = function() end

	InitHUDMenu()

	-- If we should show the help info screen, do so.
	if msg:ReadBool() then
		ShowHelpPopup()
	end
end
usermessage.Hook("_cC", CharacterCreatePanel)
