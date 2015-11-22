-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- hooks.lua
-- A hook system for plugins and other things.
-------------------------------

CAKE.Hooks = {}
CAKE.TeamHooks = {}

function CAKE.CallTeamHook(hook_name, ply, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) -- Holy shit what a hacky method fo sho.
	local team = CAKE.Teams[ply:Team()] or nil

	if team == nil then
		return -- Team hasn't even been set yet!
	end
	
	-- Look through the Hooks table for any hooks that should be called
	for _, hook in pairs(CAKE.TeamHooks) do
		if hook.hook_name == hook_name and team.role_key == hook.role_key then
			local unique = hook.unique_name or ""
			local func = hook.callback or function() end
			
			CAKE.DayLog("script.txt", TEXT.RunningTeamHook .. ": " .. unique)
			
			local override = (func(ply, (arg1 or nil), (arg2 or nil), (arg3 or nil), (arg4 or nil), (arg5 or nil), (arg6 or nil), (arg7 or nil), (arg8 or nil), (arg9 or nil), (arg10 or nil)) or 1)
			
			if override == 0 then
				return 0
			end
		end
	end
	
	return 1
end

function CAKE.AddTeamHook(hook_name, unique_name, callback, rolekey)
	local hook = {}
	hook.hook_name = hook_name
	hook.unique_name = unique_name
	hook.callback = callback
	hook.role_key = rolekey
	
	table.insert(CAKE.TeamHooks, hook)
	
	CAKE.DayLog("script.txt", TEXT.AddingTeamHook .. ": " .. unique_name .. " ( " .. hook_name .. " | " .. rolekey .. " )")
end

-- This is to be called within CAKE functions
-- It will basically run through a table of hooks and call those functions if it matches the hook name.
-- If the hook returns a value of 0, it will not call any more hooks.
function CAKE.CallHook(hook_name, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) -- Holy shit what a hacky method fo sho.
	-- Look through the Hooks table for any hooks that should be called
	for _, hook in pairs(CAKE.Hooks) do
		if hook.hook_name == hook_name then
			local unique = hook.unique_name or ""
			local func = hook.callback or function() end
			
			CAKE.DayLog("script.txt", TEXT.RunningHook .. ": " .. unique)
			
			func( (arg1 or nil), (arg2 or nil), (arg3 or nil), (arg4 or nil), (arg5 or nil), (arg6 or nil), (arg7 or nil), (arg8 or nil), (arg9 or nil), (arg10 or nil))
			
			if override == 0 then
				return 0
			end
		end
	end
	
	return 1
end

function CAKE.AddHook(hook_name, unique_name, callback)
	local hook = {}
	hook.hook_name = hook_name
	hook.unique_name = unique_name
	hook.callback = callback
	
	table.insert(CAKE.Hooks, hook)
	
	CAKE.DayLog("script.txt", TEXT.AddingHook .. ": " .. unique_name .. " (" .. hook_name .. ")")
end
