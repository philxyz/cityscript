-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- init.lua
-- This file calls the rest of the script
-------------------------------

-- Set up the gamemode
DeriveGamemode( "sandbox" );
GM.Name = "CityScript";

-- Define global variables
CAKE = {  };
CAKE.Running = false;
CAKE.Loaded = false;

DB = {}

-- String Tables
util.AddNetworkString( "show_help" );

-- Server Includes
include( "shared.lua" ); -- Shared Functions
include( "log.lua" ); -- Logging functions
include( "error_handling.lua" ); -- Error handling functions
include( "util.lua" ); -- Functions
include( "hooks.lua" ); -- CakeScript Hook System
include( "configuration.lua" ); -- Configuration data
include( "player_data.lua" ); -- Player data functions
include( "data.lua" ); -- SQLite functionality (police-related bits from DarkRP - uses DarkRP jail positions)
include( "player_shared.lua" ); -- Shared player functions
include( "player_util.lua" ); -- Player functions
include( "admin.lua" ); -- Admin functions
include( "admin_cc.lua" ); -- Admin commands
include( "chat.lua" ); -- Chat Commands
include( "daynight.lua" ); -- Day/Night and Cloc
include( "concmd.lua" ); -- Concommands
include( "charactercreate.lua" ); -- Character Creation functions
include( "items.lua" ); -- Items system
include( "schema.lua" ); -- Schema system
include( "plugins.lua" ); -- Plugin system
include( "teams.lua" ); -- Teams system
include( "client_resources.lua" ); -- Sends files to the client
include( "doors.lua" ); -- Doors

-- Required Workshop Addons
-- CSS Realistic Weapons (originally by Worshipper, fixed for GM13 by "S o h")
resource.AddWorkshop("104479034")

-- CSS Weapons on M9K Base
resource.AddWorkshop("108720350")

-- M9K Assault Rifles
resource.AddWorkshop("128089118")

-- M9K Small Arms Pack
resource.AddWorkshop("128093075")

-- Mad Cow's FOF Weapons
resource.AddWorkshop("165696777")

-- M9K Heavy Weapons
resource.AddWorkshop("128091208")

-- M9K Specialities
resource.AddWorkshop("144982052")

-- Shuriken SWEP
resource.AddWorkshop("124609721")


AntiCopy = {"atm", "storage_box", "sent_nuke_detpack", "sent_nuke_radiation", "item_prop", "token_bundle", "token_printer", "spawned_shipment", "toxic_lab", "toxic", "sent_nuke_part", "sent_nuke", "door_ram", "lockpick", "med_kit", "gmod_tool"}
NotAllowedToPickup = {}

DB.Init()

CAKE.LoadSchema( CAKE.ConVars[ "Schema" ] ); -- Load the schema and plugins, this is NOT initializing.

CAKE.Loaded = true; -- Tell the server that we're loaded up

-- Each time a player connects, they get a new ID
sessionid = 0

function GM:Initialize( ) -- Initialize the gamemode
	
	-- My reasoning for this certain order is due to the fact that plugins are meant to modify the gamemode sometimes.
	-- Plugins need to be initialized before gamemode and schema so it can modify the way that the plugins and schema actually work.
	-- AKA, hooks.
	
	CAKE.DayLog( "script.txt", TEXT.PluginsInit );
	CAKE.InitPlugins( );
	
	CAKE.DayLog( "script.txt", TEXT.SchemasInit );
	CAKE.InitSchemas( );
	
	CAKE.DayLog( "script.txt", TEXT.GamemodeInit );
	
	-- game.ConsoleCommand( "exec cakevars.cfg\n" ) -- Put any configuration variables in cfg/cakevars.cfg, set it using rp_admin setconvar varname value
	-- DEPRECATED

	GAMEMODE.Name = "CityScript"
	
	CAKE.InitTime();
	CAKE.LoadDoors();
	
	timer.Create( "timesave", 120, 0, CAKE.SaveTime );
	timer.Create( "sendtime", 1, 0, CAKE.SendTime );
	
	-- SALAARIIEEESS?!?!?!?!?!?! :O
	timer.Create( "givemoney", CAKE.ConVars[ "SalaryInterval" ] * 60, 0, function( )
		if( CAKE.ConVars[ "SalaryEnabled" ] == "1" ) then
		
			for k, v in pairs( player.GetAll( ) ) do
			
				if( CAKE.Teams[ v:Team( ) ] != nil and CAKE.Teams[ v:Team( ) ][ "salary" ] > 0 ) then
				
					if not v:GetTable().Arrested then
						CAKE.ChangeBankMoney( v, CAKE.Teams[ v:Team( ) ][ "salary" ] );
						CAKE.Response( v, TEXT.PayAnnouncement(CAKE.Teams[ v:Team( ) ][ "salary" ]) );
					else
						CAKE.Response(ply, TEXT.PayDayMissedBecauseArrested)
					end
					
				end
				
			end 
			
		end

	end )
	
	CAKE.CallHook("GamemodeInitialize");
	
	CAKE.Running = true;
	
end

-- Player Initial Spawn
function GM:PlayerInitialSpawn( ply )

	-- Call the hook before we start initializing the player
	CAKE.CallHook( "Player_Preload", ply );
	
	-- Send them valid models
	for k, v in pairs( CAKE.ValidModels ) do
		umsg.Start( "addmodel", ply );
		
			umsg.String( v );
			
		umsg.End( );
	end
	
	-- Set some default variables
	ply.LastHax = os.time()-20
	ply.Ready = false;
	ply:SetNWInt( "chatopen", 0 );
	ply:ChangeMaxHealth(CAKE.ConVars[ "DefaultHealth" ]);
	ply:ChangeMaxArmor(0);
	ply:ChangeMaxWalkSpeed(CAKE.ConVars[ "WalkSpeed" ]);
	ply:ChangeMaxRunSpeed(CAKE.ConVars[ "RunSpeed" ]);

	sessionid = sessionid + 1
	ply.SID = sessionid
	
	-- Check if they are admins
	if( table.HasValue( SuperAdmins, ply:SteamID( ) ) ) then ply:SetUserGroup( "superadmin" ); end
	if( table.HasValue( Admins, ply:SteamID( ) ) ) then ply:SetUserGroup( "admin" ); end
	
	-- Send them all the teams
	CAKE.InitTeams( ply );
	
	-- Load their data, or create a new datafile for them.
	CAKE.LoadPlayerDataFile( ply );

	-- Call the hook after we have finished initializing the player
	CAKE.CallHook( "Player_Postload", ply );
	
	self.BaseClass:PlayerInitialSpawn( ply )

end

function GM:PlayerSetHandsModel( ply, ent )
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel( ) );
	local info = player_manager.TranslatePlayerHands( simplemodel );
	if ( info ) then
		ent:SetModel( info.model );
		ent:SetSkin( info.skin );
		ent:SetBodyGroups( info.body );
	end
end

function GM:CanTool(ply, trace, mode)
	if not self.BaseClass:CanTool(ply, trace, mode) then return false end

	if IsValid(trace.Entity) then
		if trace.Entity.onlyremover then
			if mode == "remover" then
				return (ply:IsAdmin() or ply:IsSuperAdmin())
			else
				return false
			end
		end

		if trace.Entity:IsVehicle() and mode == "nocollide" then
			return false
		end
	end
	return true
end

function GM:PlayerLoadout(ply)

	CAKE.CallHook( "PlayerLoadout", ply );
	if(ply:GetNWInt( "charactercreate" ) != 1) then
	
		-- if(ply:IsAdmin() or ply:IsSuperAdmin()) then ply:Give("gmod_tool"); end
		
		if(CAKE.Teams[ply:Team()] != nil) then
		
			for k, v in pairs(CAKE.Teams[ply:Team()]["weapons"]) do
			
				ply:Give(v);
				
			end
			
		end

		ply:Give("hands")
		ply:Give("hl2_combo_fists");
		
		ply:SelectWeapon("hands");
		
	end
	
end

function GM:PlayerSpawn( ply )
	
	if (CAKE.PlayerData[CAKE.FormatSteamID(ply:SteamID())] == nil) then
		return; -- Player data isn't loaded. This is an initial spawn.
	end

	ply:SetupHands( );
	
	ply:StripWeapons( );

	self.BaseClass:PlayerSpawn( ply )
	
	GAMEMODE:SetPlayerSpeed( ply, CAKE.ConVars[ "WalkSpeed" ], CAKE.ConVars[ "RunSpeed" ] );
	
	if ( ply:GetNWInt("deathmode") == 1 ) then
	
		ply:SetNWInt("deathmode" , 0);
		ply:SetViewEntity( ply );
		
	end
	
	if ply.FlagChangeHealth then
		ply:SetHealth(ply.FlagChangeHealth);
		ply.FlagChangeHealth = nil;
	end

	-- Reset all the variables
	ply:ChangeMaxHealth(CAKE.ConVars[ "DefaultHealth" ] - ply:MaxHealth());
	ply:ChangeMaxArmor(0 - ply:MaxArmor());
	ply:ChangeMaxWalkSpeed(CAKE.ConVars[ "WalkSpeed" ] - ply:MaxWalkSpeed());
	ply:ChangeMaxRunSpeed(CAKE.ConVars[ "RunSpeed" ] - ply:MaxRunSpeed());

	local CustomSpawnPos = DB.RetrieveTeamSpawnPos(ply)
	if CustomSpawnPos then
		print(tostring(#CustomSpawnPos) .. " custom spawns positions found for team: " .. tostring(ply:Team()))
		local selected = math.random(1, #CustomSpawnPos)
		print("Placing player in at spawn #" .. tostring(selected))
		ply:SetPos(CustomSpawnPos[selected])
	end
	
	CAKE.CallHook( "PlayerSpawn", ply )
	CAKE.CallTeamHook( "PlayerSpawn", ply ); -- Change player speeds perhaps?
	
end

function GM:PlayerSetModel(ply)
	
	if(CAKE.Teams[ply:Team()] != nil) then
	
		if(CAKE.Teams[ply:Team()].default_model == true) then
		
			if(CAKE.Teams[ply:Team()].partial_model == true) then
			
				local m = CAKE.Teams[ply:Team()]["model_path"] .. string.sub(ply:GetNWString("model"), 23, string.len(ply:GetNWString("model")));
				ply:SetModel(m);
				CAKE.CallHook( "PlayerSetModel", ply, m);
				
			elseif(CAKE.Teams[ply:Team()].partial_model == false) then
			
				local m = CAKE.Teams[ply:Team()]["model_path"];
				ply:SetModel(m);
				CAKE.CallHook( "PlayerSetModel", ply, m);
				
			end
			
		else
		
			local m = ply:GetNWString("model")
			ply:SetModel(m);
			CAKE.CallHook( "PlayerSetModel", ply, m);

		end
		
	else
		
		local m = "models/kleiner.mdl";
		ply:SetModel("models/kleiner.mdl");
		CAKE.CallHook( "PlayerSetModel", ply, m);
		
	end
	
	CAKE.CallTeamHook( "PlayerSetModel", ply, m); -- Hrm. Looks like the teamhook will take priority over the regular hook.. PREPARE FOR HELLFIRE (puts on helmet)

end

function SpewMoney(amount, pos)
	if amount <= 0 then return end

	local mod500 = math.floor(amount / 500)
	if mod500 >= 1 then
		--spawn mod500 500 notes
		for i=1, mod500 do
			local moneybag = ents.Create("token_bundle")
			moneybag:SetPos(pos)
			moneybag:Spawn()
			moneybag:SetValue(500)
		end
	end
	amount = amount - (mod500 * 500)

	local mod100 = math.floor(amount / 100)
	if mod100 >= 1 then
		--spawn mod100 100 notes
		for i=1, mod100 do
			local moneybag = ents.Create("token_bundle")
			moneybag:SetPos(pos)
			moneybag:Spawn()
			moneybag:SetValue(100)
		end
	end
	amount = amount - (mod100 * 100)

	local mod50 = math.floor(amount / 50)
	if mod50 >= 1 then
		--spawn mod50 50 notes
		for i=1, mod50 do
			local moneybag = ents.Create("token_bundle")
			moneybag:SetPos(pos)
			moneybag:Spawn()
			moneybag:SetValue(50)
		end
	end
	amount = amount - (mod50 * 50)

	local mod20 = math.floor(amount / 20)
	if mod20 >= 1 then
		--spawn mod20 20 notes
		for i=1, mod20 do
			local moneybag = ents.Create("token_bundle")
			moneybag:SetPos(pos)
			moneybag:Spawn()
			moneybag:SetValue(20)
		end
	end
	amount = amount - (mod20 * 20)

	local mod10 = math.floor(amount / 10)
	if mod10 >= 1 then
		--spawn mod10 10 notes
		for i=1, mod10 do
			local moneybag = ents.Create("token_bundle")
			moneybag:SetPos(pos)
			moneybag:Spawn()
			moneybag:SetValue(10)
		end
	end
	amount = amount - (mod10 * 10)

	local mod5 = math.floor(amount / 5)
	if mod5 >= 1 then
		--spawn mod5 5 notes
		for i=1, mod5 do
			local moneybag = ents.Create("token_bundle")
			moneybag:SetPos(pos)
			moneybag:Spawn()
			moneybag:SetValue(5)
		end
	end
	amount = amount - (mod5 * 5)

	--spawn amount 1 notes
	if amount ~= 0 then
		for i=1, amount do
			local moneybag = ents.Create("token_bundle")
			moneybag:SetPos(pos)
			moneybag:Spawn()
			moneybag:SetValue(1)
		end
	end
end

function GM:PlayerDeath(ply, weapon, killer)

	if ply:HasWeapon("weapon_physcannon") then
		ply:DropWeapon(ply:GetWeapon("weapon_physcannon"))
	end

	if weapon:IsVehicle() and weapon:GetDriver():IsPlayer() then killer = weapon:GetDriver() end

	if ply:InVehicle() then ply:ExitVehicle() end

	if ply:GetTable().Arrested then
		-- If the player died in jail, make sure they can't respawn until their jail sentance is over
		ply.NextSpawnTime = CurTime() + math.ceil(120 - (CurTime() - ply.LastJailed)) + 1
		for a, b in pairs(player.GetAll()) do
			b:PrintMessage(HUD_PRINTCENTER, TEXT.PlayerHasDiedInJail(ply:Nick()))
		end
		CAKE.Response(ply, TEXT.DeadUntilSentenceComplete)
	else
		-- Normal death, respawn allowed in 4 seconds
		ply.NextSpawnTime = CurTime() + 4
	end

	if CAKE.ConVars[ "Allow_Cash_Looting" ] then
		-- Money
		math.randomseed(CAKE.GetCharField( ply, "money" ))
		local amt = math.floor(tonumber(CAKE.GetCharField( ply, "money" )) * math.random())
		if amt > CAKE.ConVars[ "Max_Cash_Drop_On_Death" ] then amt = CAKE.ConVars[ "Max_Cash_Drop_On_Death" ] end
		-- Drop the cash on the floor
		CAKE.ChangeMoney(ply, -amt)
		SpewMoney(amt, ply:GetPos())
	end

	ply:GetTable().DeathPos = ply:GetPos()
	
	CAKE.DeathMode(ply);
	CAKE.CallHook("PlayerDeath", ply);
	CAKE.CallTeamHook("PlayerDeath", ply);
	
end

function GM:PlayerDeathThink(ply)

	ply.nextsecond = CAKE.NilFix(ply.nextsecond, CurTime())
	ply.deathtime = CAKE.NilFix(ply.deathtime, 120);
	
	if(CurTime() > ply.nextsecond) then
	
		if(ply.deathtime < 120) then
		
			ply.deathtime = ply.deathtime + 1;
			ply.nextsecond = CurTime() + 1;
			ply:SetNWInt("deathmoderemaining", 120 - ply.deathtime);
			
		else
		
			ply.deathtime = nil;
			ply.nextsecond = nil;
			ply:Spawn();
			ply:SetNWInt("deathmode", 0);
			ply:SetNWInt("deathmoderemaining", 0);
			
		end
		
	end
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	-- We don't want kills, deaths, nor ragdolls being made. Kthx. -- O RLY? (philxyz)
	
end

function GM:PlayerUse(ply, entity)
	if(CAKE.IsDoor(entity)) then
		local doorgroups = CAKE.GetDoorGroup(entity)
		for k, v in pairs(doorgroups) do
			if(table.HasValue(CAKE.Teams[ply:Team()]["door_groups"], v)) then
				return false;
			end
		end
	end
	return self.BaseClass:PlayerUse(ply, entity);
end

function GM:PlayerCanPickupWeapon(ply, class)
	if ply:GetTable().Arrested then return false end

	return true
end

function GM:GravGunPunt(ply, ent)
	if ent:IsVehicle() then return false end

	local entphys = ent:GetPhysicsObject()

	if ply:KeyDown(IN_ATTACK) then
		-- it was launched
		entphys:EnableMotion(false)
		local curpos = ent:GetPos()
		timer.Simple(.01, function() entphys:EnableMotion(true) end)
		timer.Simple(.01, function() entphys:Wake() end)
		timer.Simple(.01, function() ent:SetPos(curpos) end)
	else
		return true
	end
end

function GM:GravGunOnDropped(ply, ent)
	local entphys = ent:GetPhysicsObject()
	if ply:KeyDown(IN_ATTACK) then
		-- it was launched
		entphys:EnableMotion(false)
		local curpos = ent:GetPos()
		timer.Simple(.01, function() entphys:EnableMotion(true) end)
		timer.Simple(.01, function() entphys:Wake() end)
		timer.Simple(.01, function() ent:SetPos(curpos) end)
	else
		return true
	end
end

function GM:PlayerDisconnected(ply)
	self.BaseClass:PlayerDisconnected(ply)
	for k, v in pairs(ents.FindByClass("item_prop")) do
		if v.SID == ply.SID then v:Remove() end
	end
	for k, v in pairs(ents.FindByClass("toxic")) do
		if v.SID == ply.SID then v:Remove() end
	end
	for k, v in pairs(ents.FindByClass("toxic_lab")) do
		if v.SID == ply.SID then v:Remove() end
	end
	for k, v in pairs(ents.FindByClass("token_printer")) do
		if v.SID == ply.SID then v:Remove() end
	end
	-- If you're arrested when you disconnect, you will serve your time again when you reconnect!
	if ply:GetTable().Arrested then
		DB.StoreJailStatus(ply, CAKE.ConVars[ "Jail_Time" ])
	end
end

local JailOnPlayerSpawn = function(ply)
	-- If the player for some magical reason managed to respawn while jailed then re-jail the bastard.
	if ply:GetTable().Arrested and ply:GetTable().DeathPos then
		ply:SetPos(ply:GetTable().DeathPos)
		-- Not getting away that easily, Sonny Jim.
		if DB.RetrieveJailPos() then
			ply:Arrest()
		else
			CAKE.Response(ply, TEXT.ScottFree)
		end
	end
end
hook.Add("PlayerSpawn", "JailOnPlayerSpawn", JailOnPlayerSpawn)

ATMsHaveBeenSpawned = false
hook.Add("PlayerInitialSpawn", "SpawnATMs", function()
	if ATMsHaveBeenSpawned then return end
	DB.InstallATMs()
	ATMsHaveBeenSpawned = true
end)

-- ATM Pickup Prevention
local function CityScriptPhysGravGunPickup(ply, ent)
	if not IsValid(ent) then return end

	-- When someone manipulates a storage box, they technically own the contents
	if ent:GetClass() == "storage_box" then ent.ply = ply end

	if ent:GetNWBool("ATM") and ent.frozen then return false end
end
hook.Add("GravGunPickupAllowed", "CityScript.GravGunPickupAllowed", CityScriptPhysGravGunPickup)
hook.Add("PhysgunPickup", "CityScript.PhysgunPickup", CityScriptPhysGravGunPickup)

function GM:OnNPCKilled(victim, ent, weapon)
	-- If something killed the npc
	if ent then
		if ent:IsVehicle() and ent:GetDriver():IsPlayer() then ent = ent:GetDriver() end

		-- if it wasn't a player directly, find out who owns the prop that did the killing
		if not ent:IsPlayer() then
			ent = CAKE.FindPlayerBySID(ent.SID)
		end

		-- if we know by now who killed the NPC, pay them.
		if ent and CAKE.ConVars[ "NPC_Kill_Pay" ] > 0 then
			CAKE.ChangeBankMoney(ent, CAKE.ConVars[ "NPC_Kill_Pay" ])
			CAKE.Response(ent, TEXT.BankedTokensForNPCKill(tostring(CAKE.ConVars[ "NPC_Kill_Pay" ])))
		end
	end
end
