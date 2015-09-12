-- CityScript - fire_extinguisher_powder.lua
-- by philxyz 2015
-- MIT License

PLUGIN.Name = "Fire Extinguisher"; -- What is the plugin name
PLUGIN.Author = "philxyz"; -- Author of the plugin
PLUGIN.Description = "Extinguisher Resources"; -- The description or purpose of the plugin

function PLUGIN.Init()
end

if SERVER then
	resource.AddFile("sound/spray_start.wav")
	resource.AddFile("sound/spray_hold.wav")
	resource.AddFile("sound/spray_end.wav")
	resource.AddFile("materials/fire_extinguisher_powder/powderspray.vmt")
	resource.AddFile("materials/fire_extinguisher_powder/w_fire_extinguisher_powder.vmt")
	resource.AddFile("models/fire_extinguisher_powder/w_fire_extinguisher_powder.mdl")
	resource.AddFile("models/weapons/v_fire_extinguisher_powder.mdl")
	AddCSLuaFile("effects/fire_extinguisher_powder.lua")
end
