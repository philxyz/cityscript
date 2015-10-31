PLUGIN.Name = "Permaflags" -- What is the plugin name
PLUGIN.Author = "Nori" -- Author of the plugin
PLUGIN.Description = "Allows a player to automatically spawn as a certain flag when the character is selected" -- The description or purpose of the plugin

function SetPermaflag(ply, cmd, args)
	if #args ~= 1 then
		CAKE.Response(ply, TEXT.IncorrectNumberOfArguments)
		return
	end
	
	local flagkey = args[1]
	
	for k, v in pairs(CAKE.Teams) do
		if v.flag_key == flagkey and (table.HasValue(CAKE.GetCharField(ply, "flags"), flagkey) or v.public == true) then
			CAKE.SetCharField(ply, "permaflag", flagkey)
			CAKE.Response(ply, TEXT.PermaFlagSetTo .. ": " .. flagkey)
		end
	end
end
concommand.Add("rp_permaflag", SetPermaflag)

function Permaflag_Set(ply)
	for k, v in pairs(CAKE.Teams) do
		if v.flag_key == CAKE.GetCharField(ply, "permaflag") then
			if table.HasValue(CAKE.GetCharField(ply, "flags"), CAKE.GetCharField(ply, "permaflag")) or v.public == true then
				ply:SetTeam(k)
			else
				CAKE.SetCharField(ply, "permaflag", CAKE.ConVars["DefaultPermaflag"])
			end
		end
	end
end

function PLUGIN.Init()
	CAKE.ConVars["DefaultPermaflag"] = "citizen"
	CAKE.AddDataField(2, "permaflag", CAKE.ConVars.DefaultPermaflag) -- What is the default permaflag (Citizen by default, shouldn't be changed)
	CAKE.AddHook("CharacterSelect_PostSetTeam", "permaflag", Permaflag_Set)
end
