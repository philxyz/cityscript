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

net.Receive("Cy", function(_, ply)
	local n = net.ReadInt(32)

	for i=1, n do
		table.insert(ValidCakeModels, net.ReadString())
	end
end)

function SetChosenModel(mdl)
	if table.HasValue(ValidCakeModels, mdl) then
		ChosenModel = mdl
	else
		LocalPlayer():PrintMessage(3, CAKE.ChosenModel .. TEXT.XisNotAValidModel)
	end
end

ExistingChars = {}

net.Receive("Cz", function(_, ply)
	local numChars = net.ReadInt(32)
	for i=1, numChars do
		local n = net.ReadInt(32)
		ExistingChars[n] = {}
		ExistingChars[n].name = net.ReadString()
		ExistingChars[n].model = net.ReadString()
	end
end)

net.Receive("C2", function(_, ply)
	CreatePlayerMenu()
	PlayerMenu:ShowCloseButton(false)
	PropertySheet:SetActiveTab(PropertySheet.Items[2].Tab)
	PropertySheet.SetActiveTab = function() end

	InitHUDMenu()

	-- If we should show the help info screen, do so.
	if net.ReadBool() then
		ShowHelpPopup()
	end
end)
