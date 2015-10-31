PLUGIN.Name = "Meteor" -- What is the plugin name
PLUGIN.Author = "philxyz" -- Author of the plugin
PLUGIN.Description = "Meteor script" -- The description or purpose of the plugin

local stormOn = false
local timeLeft = 10

/*---------------------------------------------------------
 Meteor storm
 ---------------------------------------------------------*/
local function StormStart()
	for k, v in pairs(player.GetAll()) do
		if v:Alive() then
			v:PrintMessage(HUD_PRINTCENTER, TEXT.MeteorStormApproaching)
			v:PrintMessage(HUD_PRINTTALK, TEXT.MeteorStormApproaching)
		end
	end
end

local function StormEnd()
	for k, v in pairs(player.GetAll()) do
		if v:Alive() then
			v:PrintMessage(HUD_PRINTCENTER, TEXT.MeteorStormPassing)
			v:PrintMessage(HUD_PRINTTALK, TEXT.MeteorStormPassing)
		end
	end
end

local function ControlStorm()
	timeLeft = timeLeft - 1

	if timeLeft < 1 then
		if stormOn then
			timeLeft = math.random(300,500)
			stormOn = false
			timer.Stop("start")
			StormEnd()
		else
			timeLeft = math.random(60,90)
			stormOn = true
			timer.Start("start")
			StormStart()
		end
	end
end

local function AttackEnt(ent)
	meteor = ents.Create("meteor")
	meteor:Spawn()
	meteor:SetTarget(ent)
end

local function StartShower()
	timer.Adjust("start", math.random(.1,1), 0, StartShower)
	for k, v in pairs(player.GetAll()) do
		if math.random(0, 2) == 0 and v:Alive() then
			AttackEnt(v)
		end
	end
end

local function StartStorm(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		timer.Start("stormControl")
		CAKE.Response(ply, TEXT.MeteorStormEnabled)
	end
	return ""
end

local function StopStorm(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		timer.Stop("stormControl")
		stormOn = false
		timer.Stop("start")
		StormEnd()
		CAKE.Response(ply, TEXT.MeteorStormDisabled)
		return ""
	end
end

timer.Create("start", 1, 0, StartShower)
timer.Create("stormControl", 1, 0, ControlStorm)

timer.Stop("start")
timer.Stop("stormControl")

-- New for CityScript: Randomly hit someone with a meteor out of the blue (chance is 1 in 10000)
local next_update_time
local function LOLRandomAttack()
	if CurTime() > (next_update_time or 0) then
		if math.random(0, 10000) < 1 then
			local PotentialMeteorTargets = {}
			for k, v in pairs(player.GetAll()) do
				table.insert(PotentialMeteorTargets, v)
			end

			for a, b in pairs(player.GetAll()) do
				b:PrintMessage(HUD_PRINTCENTER, TEXT.INCOMING .. "!")
				b:PrintMessage(HUD_PRINTTALK, TEXT.INCOMING .. "!")
			end

			local target = PotentialMeteorTargets[math.random(1, #PotentialMeteorTargets)]

			if IsValid(target) and target:Alive() then
				AttackEnt(target)
			end
		end
		next_update_time = CurTime() + 1
	end
end
hook.Add("Think", "MeteorThink", LOLRandomAttack)

function PLUGIN.Init()
	CAKE.ChatCommand(TEXT.EnableMeteorCommand, StartStorm)
	CAKE.ChatCommand(TEXT.DisableMeteorCommand, StopStorm)
end
