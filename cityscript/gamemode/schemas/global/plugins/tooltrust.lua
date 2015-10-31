PLUGIN.Name = "Tool Trust" -- What is the plugin name
PLUGIN.Author = "LuaBanana" -- Author of the plugin
PLUGIN.Description = "Toolgun permissions, as well as physgun ban." -- The description or purpose of the plugin

function Tooltrust_Give(ply)
	if tostring(CAKE.GetPlayerField(ply, "tooltrust")) == "1" then
		ply:Give("gmod_tool")
	end
	
	if tostring(CAKE.GetPlayerField(ply, "phystrust")) == "1" then
		ply:Give("weapon_physgun")
	end
	
	if tostring(CAKE.GetPlayerField(ply, "gravtrust")) == "1" then
		ply:Give("weapon_physcannon")
	end
end

function Admin_Tooltrust(ply, cmd, args)
	if #args ~= 2 then
		CAKE.Response( ply, TEXT.ToolTrustInvalidArguments)
		return
	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if IsValid(target) and target:IsPlayer() then
		-- klol
	else
		CAKE.Response(ply, TEXT.TargetNotFound)
		return
	end
	
	if args[2] == "1" then
		CAKE.SetPlayerField(target, "tooltrust", 1)
		target:Give("gmod_tool")
		CAKE.Response(target, TEXT.ToolTrustGivenBy(ply:Name()))
		CAKE.Response(ply, TEXT.ToolTrustGivenAnnounce(target:Name()))
	elseif args[2] == "0" then
		CAKE.SetPlayerField(target, "tooltrust", 0)
		target:StripWeapon("gmod_tool")
		CAKE.Response(target, TEXT.ToolTrustRevokedBy(ply:Name()))
		CAKE.Response(ply, TEXT.ToolTrustRevokedAnnounce(target:Name()))
	end
end

function Admin_Phystrust(ply, cmd, args)
	if #args ~= 2 then
		CAKE.Response(ply, TEXT.PhysTrustInvalidArguments)
		return
	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if IsValid(target) and target:IsPlayer() then
		-- klol
	else
		CAKE.Response(ply, TEXT.TargetNotFound)
		return
	end
	
	if args[2] == "0" then
		CAKE.SetPlayerField(target, "phystrust", 0)
		target:StripWeapon("weapon_physgun")
		CAKE.Response(target, TEXT.PhysTrustRevokedBy(ply:Name()))
		CAKE.Response(ply, TEXT.PhysTrustRevokedAnnounce(target:Name()))
	elseif args[2] == "1" then
		CAKE.SetPlayerField(target, "phystrust", 1)
		target:Give("weapon_physgun")
		CAKE.Response(target, TEXT.PhysTrustGivenBy(ply:Name()))
		CAKE.Response(ply, TEXT.PhysTrustRevokedAnnounce(target:Name()))
	end
end

function Admin_Gravtrust(ply, cmd, args)
	if #args ~= 2 then
		CAKE.Response(ply, TEXT.GravTrustInvalidArguments)
		return
	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if IsValid(target) and target:IsPlayer() then
		-- klol
	else
		CAKE.Response(ply, TEXT.TargetNotFound)
		return
	end
	
	if args[2] == "0" then
		CAKE.SetPlayerField(target, "gravtrust", 0)
		target:StripWeapon("weapon_physcannon")
		CAKE.Response(target, TEXT.GravTrustRevokedBy(ply:Name()))
		CAKE.Response(ply, TEXT.GravTrustRevokedAnnounce(target:Name()))
	elseif args[2] == "1" then
		CAKE.SetPlayerField(target, "gravtrust", 1)
		target:Give("weapon_physcannon")
		CAKE.Response( target, TEXT.GravTrustGivenBy(ply:Name()))
		CAKE.Response( ply, TEXT.GravTrustGivenAnnounce(target:Name()))
	end
end

function Admin_Proptrust(ply, cmd, args)
	if #args ~= 2 then
		CAKE.Response(ply, TEXT.PropTrustInvalidArguments)
		return
	end
	
	local target = CAKE.FindPlayer(args[1])
	
	if IsValid(target) and target:IsPlayer() then
		-- klol
	else
		CAKE.Response(ply, TEXT.TargetNotFound)
		return
	end
	
	if args[2] == "0" then
		CAKE.SetPlayerField(target, "proptrust", 0)
		CAKE.Response(target, TEXT.PropTrustRevokedBy(ply:Name()))
		CAKE.Response(ply, TEXT.PropTrustRevokedAnnounce(target:Name()))
	elseif args[2] == "1" then
		CAKE.SetPlayerField(target, "proptrust", 1)
		CAKE.Response(target, TEXT.PropTrustGivenBy(ply:Name()))
		CAKE.Response(ply, TEXT.PropTrustGivenAnnounce(target:Name()))
	end
end

	
function PLUGIN.Init()
	CAKE.ConVars.Default_Tooltrust = 1 -- Are players allowed to have the toolgun when they first start.
	CAKE.ConVars.Default_Gravtrust = 1 -- Are players allowed to have the gravgun when they first start.
	CAKE.ConVars.Default_Phystrust = 1 -- Are players allowed to have the physgun when they first start.
	CAKE.ConVars.Default_Proptrust = 1 -- Are players allowed to spawn props when they first start.
	
	CAKE.AddDataField(1, "tooltrust", CAKE.ConVars.Default_Tooltrust) -- Is the player allowed to have the toolgun
	CAKE.AddDataField(1, "gravtrust", CAKE.ConVars.Default_Gravtrust) -- Is the player allowed to have the gravity gun
	CAKE.AddDataField(1, "phystrust", CAKE.ConVars.Default_Phystrust) -- Is the player allowed to have the physics gun
	CAKE.AddDataField(1, "proptrust", CAKE.ConVars.Default_Proptrust) -- Is the player allowed to spawn props
	
	CAKE.AddHook("PlayerSpawn", "tooltrust_give", Tooltrust_Give)
	
	CAKE.AdminCommand("tooltrust", Admin_Tooltrust, TEXT.ChangeATrust("tool"), true, true, false)
	CAKE.AdminCommand("gravtrust", Admin_Gravtrust, TEXT.ChangeATrust("grav"), true, true, false)
	CAKE.AdminCommand("phystrust", Admin_Phystrust, TEXT.ChangeATrust("phys"), true, true, false)
	CAKE.AdminCommand("proptrust", Admin_Proptrust, TEXT.ChangeATrust("prop"), true, true, false)
end
