PLUGIN.Name = "Admin Commands" -- What is the plugin name
PLUGIN.Author = "LuaBanana" -- Author of the plugin
PLUGIN.Description = "A set of default admin commands" -- The description or purpose of the plugin

function Admin_AddDoor(ply, cmd, args)
	
	local tr = ply:GetEyeTrace()
	local trent = tr.Entity
	
	if not CAKE.IsDoor(trent) then ply:PrintMessage(3, TEXT.MustBeLookingAtDoor); return; end

	if table.getn(args) < 1 then ply:PrintMessage(3, TEXT.SpecifyADoorGroup); return; end
	
	local pos = trent:GetPos()
	local Door = {}

	Door.x = math.ceil(pos.x)
	Door.y = math.ceil(pos.y)
	Door.z = math.ceil(pos.z)
	Door.group = args[1]
	
	table.insert(CAKE.Doors, Door)
	
	CAKE.Response(ply, TEXT.DoorAdded)
	
	local keys = util.TableToKeyValues(CAKE.Doors)
	file.Write("CakeScript/MapData/" .. game.GetMap() .. ".txt", keys)
end

-- rp_admin warn "name" "warning"
function Admin_Warn(ply, cmd, args)
	if #args ~= 2 then
		CAKE.Response(ply, TEXT.RPWarnInvalidArgumentCount)
		return;
	end
	
	local plyname = args[1]
	local warning = args[2]

	local pl = CAKE.FindPlayer(plyname)
	
	if IsValid(pl) and pl:IsPlayer() then
		pl:PrintMessage(HUD_PRINTCENTER, TEXT.WARNING .. ": " .. warning)
		CAKE.AnnounceAction( ply, TEXT.SomeoneHasBeenWarned(pl:Name()))
	else
		CAKE.Response(ply, TEXT.CanNotFindPlayer(plyname))
	end
end

-- rp_admin kick "name" "reason"
function Admin_Kick(ply, cmd, args)
	if #args ~= 2 then
		CAKE.Response(ply, TEXT.RPKickInvalidArgumentCount)
		return
	end
	
	local plyname = args[1]
	local reason = args[2]
	
	local pl = CAKE.FindPlayer(plyname)
	
	if IsValid(pl) and pl:IsPlayer() then
		game.ConsoleCommand("kickid " .. pl:UserID() .. " \"" .. reason .. "\"\n")
		CAKE.AnnounceAction(ply, "kicked " .. pl:Name())
	else
		CAKE.Response(ply, TEXT.CanNotFindPlayer(plyname))
	end
end

-- rp_admin ban "name" "reason" minutes
function Admin_Ban(ply, cmd, args)
	if #args ~= 3 then
		CAKE.Response(ply, TEXT.RPBanInvalidArgumentCount)
		return;
	end
	
	local plyname = args[1]
	local reason = args[2]
	local mins = tonumber(args[3])
	
	local pl = CAKE.FindPlayer(plyname)
	
	if IsValid(pl) and pl:IsPlayer() then
		-- This bans, then kicks, then writes their ID to the file.
		game.ConsoleCommand("banid " .. mins .. " " .. pl:UserID() .. "\n")
		game.ConsoleCommand("kickid " .. TEXT.BanInfo(pl:UserID(), mins, reason))
		game.ConsoleCommand("writeid\n" )
		
		CAKE.AnnounceAction(ply, TEXT.BannedName(pl:Name()))
	else
		CAKE.Response(ply, TEXT.CanNotFindPlayer(plyname))
	end
end

function Admin_Quiet(ply, cmd, args)
	if #args ~= 2 or (args[2] != "1" and args[2] ~= "0") then
		CAKE.Response(ply, TEXT.QuietCommandUsageError)
		return
	end

	local target = CAKE.FindPlayer(args[1])
	local canSpeak = args[2] ~= "1"

	if IsValid(target) and target:IsPlayer() then
		CAKE.AllowSounds(target, canSpeak)
	end
end

function Admin_SetVar(ply, cmd, args)
	if #args ~= 2 then
		CAKE.Response(ply, TEXT.SetVarInvalidArgumentCount)
		return
	end
	
	if CAKE.ConVars[args[1]] then
		local vartype = type(CAKE.ConVars[args[1]])
		
		if vartype == "string" then
			CAKE.ConVars[args[1]] = tostring(args[2])
		elseif vartype == "number" then
			CAKE.ConVars[args[1]] = tonumber(args[2]) or 0 -- Don't set a fkn string for a number, dumbass! >:<
		elseif vartype == "table" then
			CAKE.Response(ply, args[1] .. " cannot be changed, it is a table." ) -- This is kind of like.. impossible.. kinda. (Or I'm just a lazy fuck)
			return
		end
		
		CAKE.Response(ply, TEXT.ReportAdminChangeMade(args[1], args[2]))
		CAKE.CallHook("SetVar", ply, args[1], args[2])
	else
		CAKE.Response(ply, args[1] .. " is not a valid convar! Use rp_admin listvars")
	end
end

function Admin_ListVars(ply, cmd, args)
	CAKE.Response(ply, TEXT.ListVarsHeader)
	
	for k, v in pairs(CAKE.ConVars) do
		CAKE.Response(ply, k .. " - " .. tostring(v))
	end
end

function Admin_SetRoles(ply, cmd, args)
	local target = CAKE.FindPlayer(args[1])
	
	if IsValid(target) and target:IsPlayer() then
		-- klol
	else
		CAKE.Response(ply, TEXT.TargetNotFound)
		return
	end
	
	table.remove(args, 1) -- Get rid of the name
	
	CAKE.SetCharField(target, "roles", args) -- KLOL!
	
	CAKE.Response(ply, TEXT.SetRolesResponse(target:Name(), table.concat(args, " ")))
	CAKE.Response(target, TEXT.SetRolesResponse2(ply:Name(), table.concat(args, " ")))
end

function Admin_Help(ply, cmd, args)
	CAKE.Response(ply, TEXT.ListAdminCmdsHeader)
	
	for cmdname, cmd in pairs(CAKE.AdminCommands) do
		local s = cmdname .. " \"" .. cmd.desc .. "\""
		
		if cmd.CanRunFromConsole then
			s = s .. " console"
		else
			s = s .. " noconsole"
		end
		
		if cmd.CanRunFromAdmin then
			s = s .. " admin"
		end
		
		if cmd.SuperOnly then
			s = s .. " superonly"
		end
		
		CAKE.Response(ply, s)
	end
end
	
-- Let's make some ADMIN COMMANDS!
function PLUGIN.Init()
	CAKE.AdminCommand("help", Admin_Help, TEXT.ListAllAdminCommands, true, true, false)
	CAKE.AdminCommand("warn", Admin_Warn, TEXT.WarnSomeone, true, true, false)
	CAKE.AdminCommand("kick", Admin_Kick, TEXT.KickSomeone, true, true, false)
	CAKE.AdminCommand("ban", Admin_Ban, TEXT.BanSomeone, true, true, false)
	CAKE.AdminCommand("listvars", Admin_ListVars, TEXT.ListConVars, true, true, true)
	CAKE.AdminCommand("setvar", Admin_SetVar, TEXT.SetVar, true, true, true)
	CAKE.AdminCommand("quiet", Admin_Quiet, TEXT.Quiet, true, true, false)
	CAKE.AdminCommand("setroles", Admin_SetRoles, TEXT.SetRoles, true, true, false)
	CAKE.AdminCommand("adddoor", Admin_AddDoor, TEXT.AddDoorToDoorGroup, true, true, true)
end
