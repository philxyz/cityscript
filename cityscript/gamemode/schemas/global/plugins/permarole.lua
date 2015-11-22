PLUGIN.Name = "Permaroles" -- What is the plugin name
PLUGIN.Author = "Nori" -- Author of the plugin
PLUGIN.Description = "Allows a player to automatically spawn as a certain role when the character is selected" -- The description or purpose of the plugin

function SetPermarole(ply, cmd, args)
	if #args ~= 1 then
		CAKE.Response(ply, TEXT.IncorrectNumberOfArguments)
		return
	end
	
	local rolekey = args[1]
	
	for k, v in pairs(CAKE.Teams) do
		if v.role_key == rolekey and (table.HasValue(CAKE.GetCharField(ply, "roles"), rolekey) or v.public == true) then
			CAKE.SetCharField(ply, "permarole", rolekey)
			CAKE.Response(ply, TEXT.PermaRoleSetTo .. ": " .. rolekey)
		end
	end
end
concommand.Add("rp_permarole", SetPermarole)

function Permarole_Set(ply)
	for k, v in pairs(CAKE.Teams) do
		if v.role_key == CAKE.GetCharField(ply, "permarole") then
			if table.HasValue(CAKE.GetCharField(ply, "roles"), CAKE.GetCharField(ply, "permarole")) or v.public == true then
				ply:SetTeam(k)
			else
				CAKE.SetCharField(ply, "permarole", CAKE.ConVars["DefaultPermarole"])
			end
		end
	end
end

function PLUGIN.Init()
	CAKE.ConVars["DefaultPermarole"] = "citizen"
	CAKE.AddDataField(2, "permarole", CAKE.ConVars.DefaultPermarole) -- What is the default permarole (Citizen by default, shouldn't be changed)
	CAKE.AddHook("CharacterSelect_PostSetTeam", "permarole", Permarole_Set)
end
