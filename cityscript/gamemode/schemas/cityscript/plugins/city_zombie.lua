PLUGIN.Name = "Zombie"; -- What is the plugin name
PLUGIN.Author = "philxyz"; -- Author of the plugin
PLUGIN.Description = "Zombie script"; -- The description or purpose of the plugin

local timeLeft2 = 10
local zombieOn = false
local maxZombie = 10

local function ZombieStart()
	for k, v in pairs(player.GetAll()) do
		if v:Alive() then
			v:PrintMessage(HUD_PRINTCENTER, TEXT.WARNING .. ": " .. TEXT.ZombiesApproaching)
			v:PrintMessage(HUD_PRINTTALK, TEXT.WARNING .. ": " .. TEXT.ZombiesApproaching)
		end
	end
end

local function ZombieEnd()
	for k, v in pairs(player.GetAll()) do
		if v:Alive() then
			v:PrintMessage(HUD_PRINTCENTER, TEXT.ZombiesLeaving)
			v:PrintMessage(HUD_PRINTTALK, TEXT.ZombiesLeaving)
		end
	end
end

local function ControlZombie()
	timeLeft2 = timeLeft2 - 1

	if timeLeft2 < 1 then
		if zombieOn then
			timeLeft2 = math.random(300,500)
			zombieOn = false
			timer.Stop("start2")
			ZombieEnd()
		else
			timeLeft2 = math.random(150,300)
			zombieOn = true
			timer.Start("start2")
			DB.RetrieveZombies()
			ZombieStart()
		end
	end
end

local function PlayerDist(npcPos)
	local playDis
	local currPlayer
	for k, v in pairs(player.GetAll()) do
		local tempPlayDis = v:GetPos():Distance(npcPos:GetPos())

		if playDis == nil then
			playDis = tempPlayDis
			currPlayer = v
		end

		if tempPlayDis < playDis then
			playDis = tempPlayDis
			currPlayer = v
		end
	end

	return currPlayer
end

local function LoadTable(ply)
	ply:SetNWInt("numPoints", table.getn(zombieSpawns))

	for k, v in pairs(zombieSpawns) do
		local Sep = (string.Explode(" ", v))
		ply:SetNWVector("zPoints" .. k, Vector(tonumber(Sep[1]), tonumber(Sep[2]), tonumber(Sep[3])))
	end
end

local function DropZombies(ply, index)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		DB.DropZombies()
		CAKE.Response(ply, TEXT.ClearedAllZombiePositions)
		if ply:GetNWBool("zombieToggle") then
			LoadTable(ply)
		end
	else
		CAKE.Response(ply, TEXT.AdminOnly)
	end
	return ""
end

local function AddZombie(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		DB.RetrieveZombies()
		table.insert(zombieSpawns, tostring(ply:GetPos()))
		DB.StoreZombies()
		if ply:GetNWBool("zombieToggle") then LoadTable(ply) end
		CAKE.Response(ply, TEXT.ZombieSpawnPosAdded)
	else
		CAKE.Response(ply, TEXT.AdminOnly)
	end
	return ""
end

local function ToggleZombie(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		if not ply:GetNWBool("zombieToggle") then
			DB.RetrieveZombies()
			ply:SetNWBool("zombieToggle", true)
			LoadTable(ply)
		else
			ply:SetNWBool("zombieToggle", false)
		end
	else
		CAKE.Response(ply, TEXT.AdminOnly)
	end
	return ""
end

local function GetAliveZombie()
	local zombieCount = 0

	for k, v in pairs(ents.FindByClass("npc_zombie")) do
		zombieCount = zombieCount + 1
	end

	for k, v in pairs(ents.FindByClass("npc_fastzombie")) do
		zombieCount = zombieCount + 1
	end

	for k, v in pairs(ents.FindByClass("npc_antlion")) do
		zombieCount = zombieCount + 1
	end

	for k, v in pairs(ents.FindByClass("npc_headcrab_fast")) do
		zombieCount = zombieCount + 1
	end

	return zombieCount
end

local function SpawnZombie()
	timer.Start("move")
	if GetAliveZombie() < maxZombie then
		if table.getn(zombieSpawns) > 0 then
			local zombieType = math.random(1, 4)
			if zombieType == 1 then
				local zombie1 = ents.Create("npc_zombie")
				zombie1:SetPos(DB.RetrieveRandomZombieSpawnPos())
				zombie1:Spawn()
				zombie1:Activate()
			elseif zombieType == 2 then
				local zombie2 = ents.Create("npc_fastzombie")
				zombie2:SetPos(DB.RetrieveRandomZombieSpawnPos())
				zombie2:Spawn()
				zombie2:Activate()
			elseif zombieType == 3 then
				local zombie3 = ents.Create("npc_antlion")
				zombie3:SetPos(DB.RetrieveRandomZombieSpawnPos())
				zombie3:Spawn()
				zombie3:Activate()
			elseif zombieType == 4 then
				local zombie4 = ents.Create("npc_headcrab_fast")
				zombie4:SetPos(DB.RetrieveRandomZombieSpawnPos())
				zombie4:Spawn()
				zombie4:Activate()
			end
		end
	end
end

local function MaxZombies(ply, args)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		if not tonumber(args) or tonumber(args) < 0 then
			CAKE.Response(ply, TEXT.InvalidMaxZombies)
			return ""
		end
		maxZombie = tonumber(args)
		CAKE.Response(ply, TEXT.SetMaxZombiesTo .. ": " .. args)
	end

	return ""
end

local function StartZombie(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		timer.Start("zombieControl")
		CAKE.Response(ply, TEXT.ZombiesNowEnabled)
	end
	return ""
end

local function StopZombie(ply)
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		timer.Stop("zombieControl")
		zombieOn = false
		timer.Stop("start2")
		ZombieEnd()
		CAKE.Response(ply, TEXT.ZombiesNowDisabled)
		return ""
	end
end

timer.Create("start2", 1, 0, SpawnZombie)
timer.Create("zombieControl", 1, 0, ControlZombie)
timer.Stop("start2")
timer.Stop("zombieControl")

function PLUGIN.Init()
	CAKE.ChatCommand(TEXT.EnableZombiesCommand, StartZombie)
	CAKE.ChatCommand(TEXT.DisableZombiesCommand, StopZombie)
	CAKE.ChatCommand(TEXT.MaxZombiesCommand, MaxZombies)
	CAKE.ChatCommand(TEXT.ShowZombieCommand, ToggleZombie)
	CAKE.ChatCommand(TEXT.AddZombieCommand, AddZombie)
	CAKE.ChatCommand(TEXT.DropZombiesCommand, DropZombies)
end
