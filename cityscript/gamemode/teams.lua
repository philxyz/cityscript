-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- teams.lua
-- Holds the team functions.
-------------------------------

CAKE.Teams = {}

function CAKE.AddTeam(team)
	local n = #CAKE.Teams + 1
	
	CAKE.CallHook("AddTeam", team)
	CAKE.Teams[n] = team
	CAKE.DayLog("script.txt", TEXT.AddedTeam .. " " .. team.name)
end

function CAKE.InitTeams()
	local nteams = #CAKE.Teams

	for _, ply in pairs(player.GetAll()) do
		net.Start("Ct")
		net.WriteInt(nteams, 32)
		for k, v in pairs(CAKE.Teams) do
			net.WriteInt(k, 32)
			net.WriteString(v.name)
			net.WriteInt(v.color.r, 16)
			net.WriteInt(v.color.g, 16)
			net.WriteInt(v.color.b, 16)
			net.WriteInt(v.color.a, 16)
			net.WriteBool(v.public)
			net.WriteInt(v.salary, 32) -- Limits the salary to 2 billion or something but whatever...
			net.WriteString(v.flag_key)
			net.WriteBool(v.business)
		end

		net.Send(ply)

		for k, v in pairs(CAKE.Teams) do
			CAKE.CallHook("SendTeamData", ply, v)
		end
	end
end

function CAKE.TeamObject()
	local team = {}
	
	-- Basic team configuration
	team.name = ""
	team.color = Color(0, 0, 0, 255)
	
	-- Model configuration
	team.model_path = ""
	team.default_model = false -- Does the team have a model to use
	team.partial_model = false -- Is the regular citizen model's suffix added onto the end of our modelpath ( Ex. male_07.mdl )
	
	-- Weapons Configuration
	team.weapons = {}
	
	-- Flag Configuration
	team.flag_key = "" -- What is used with rp_flag
	team.door_groups = {} -- What groups of doors can the team open
	team.radio_groups = {} -- What radios can the team talk on
	team.sound_groups = {} -- What voices can the team use
	team.item_groups = {} -- What items can the team purchase
	
	-- Salaries
	team.salary = 0 -- How many tokens does this flag earn every paycheck?

	team.public = true
	team.business = false
	team.broadcast = false
	
	CAKE.CallHook("CreateTeamObject", team) -- Hooray, plugins get to throw in their own variables! :3
	
	return team
end
