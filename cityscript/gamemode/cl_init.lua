-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_init.lua
-- This file calls the rest of the script
-- As you can see, the clientside of CakeScript is pretty simple compared to the serverside.
-------------------------------

-- Set up the gamemode
DeriveGamemode("sandbox")
GM.Name = "CakeScript G2 1.0.0"

-- Define global variables
CAKE = {}
CAKE.Running = false
CAKE.Loaded = false

CAKE.models = {}
readysent = false

surface.CreateFont("ScoreboardText", {
        font = "Tahoma",
        size = 16,
        weight = 1000,
        antialias = true
})

-- Client Includes
include("shared.lua")
include("cl_upp.lua") -- Unobtrusive Prop Protection
include("player_shared.lua")
include("cl_hud.lua")
include("cl_charactercreate.lua")
include("cl_playermenu.lua")
include("cl_binds.lua")

CAKE.Loaded = true

-- Initialize the gamemode
function GM:Initialize()
	CAKE.Running = true
	self.BaseClass:Initialize()
end

function GM:Think()
	if vgui and readysent == false then -- VGUI is initalized, tell the server we're ready for character creation.
		net.Start("Cp")
		net.SendToServer()
		readysent = true
	end
end
