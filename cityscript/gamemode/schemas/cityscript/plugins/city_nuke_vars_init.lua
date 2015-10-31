PLUGIN.Name = "CityScript Nuke Setup Plugin" -- What is the pugin name
PLUGIN.Author = "T.Bonita + philxyz" -- Author of the plugin
PLUGIN.Description = "Nuke Convars" -- The description or purpose of the plugin

function PLUGIN.Init( )
	
end

if GetConVarString("nuke_yield") == "" then --if one of them doesn't exists, then they all probably don't exist
	CreateConVar("nuke_yield", 200, false)
	CreateConVar("nuke_waveresolution", 0.2, false)
	CreateConVar("nuke_ignoreragdoll", 1, false)
	CreateConVar("nuke_breakconstraints", 1, false)
	CreateConVar("nuke_disintegration", 1, false)
	CreateConVar("nuke_damage", 100, false)
	CreateConVar("nuke_epic_blastwave", 1, false)
	CreateConVar("nuke_radiation_duration", 0, false)
	CreateConVar("nuke_radiation_damage", 0, false)
end
