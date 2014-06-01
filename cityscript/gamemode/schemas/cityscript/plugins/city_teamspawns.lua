PLUGIN.Name = "CityScript Team Spawns"; -- What is the pugin name
PLUGIN.Author = "philxyz"; -- Author of the plugin
PLUGIN.Description = "Bits of team spawn Functionality"; -- The description or purpose of the plugin

function PLUGIN.Init( )
	
end

-- Add this place as a spawn position for the current team
CAKE.ChatCommand(TEXT.AddSpawnCommand, function(ply, args)
	if not ply:IsAdmin() and not ply:IsSuperAdmin() then return "" end
	if not ply:Team() then
		CAKE.Response(ply, TEXT.ChooseATeamBeforeCreatingSpawns)
		return ""
	end
	DB.AddTeamSpawnPos(ply:Team(), string.Explode(" ", tostring(ply:GetPos())))
	CAKE.Response(ply, TEXT.NewSpawnPointCreated(ply:Team()))
	return ""
end)

CAKE.ChatCommand(TEXT.RemoveSpawnsCommand, function(ply, args)
	if not ply:Team() or (not ply:IsAdmin() and not ply:IsSuperAdmin()) then return "" end
	DB.RemoveTeamSpawns(tostring(ply:Team()))
	CAKE.Response(ply, TEXT.RemovedAllSpawns(ply:Team()))
	return ""
end)
