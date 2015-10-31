-- CityScript - token_banknote.lua
-- by philxyz 2015
-- MIT License

PLUGIN.Name = "Token Banknote" -- What is the plugin name
PLUGIN.Author = "philxyz" -- Author of the plugin
PLUGIN.Description = "Token banknote" -- The description or purpose of the plugin

function PLUGIN.Init()
end

if SERVER then
	resource.AddFile("materials/token_banknote.vmt")
	resource.AddFile("models/token_banknote.mdl")
end
