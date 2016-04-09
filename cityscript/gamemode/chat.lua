-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- chat.lua
-- Holds the chat commands and functions.
-- A lot of this code was based off of TacoScript's chat.lua - Credits to DarkCybo1
-------------------------------

-- Thanks to Overv (Puzzle gamemode) lol
local taunt = {
	"vo/npc/male01/hacks02.wav",
	"vo/npc/male01/hacks01.wav",
	"vo/npc/female01/hacks02.wav",
	"vo/npc/female01/hacks01.wav"
}

for k,v in pairs(taunt) do
	util.PrecacheSound(v)
end

CAKE.ChatCommands = {}

function CAKE.SimpleChatCommand(prefix, range, form)
	-- This is for simple chat commands like /me, /y, /w, etc
	-- This isn't useful for radio, broadcast, etc.

	-- Quite a new feature, you can specify a 'format' for the output.
	-- %1 - IC Name
	-- %2 - OOC Name
	-- %3 - Text Given
	--
	-- So, someone using Local OOC chat, would output this:
	-- Joe Bob | Bobby1337 [ LOCAL OOC ]: WAIT WHAT.
	-- The format would be: "%1 | %2 [ LOCAL OOC ]: %3"
	--
	-- Also, the range is a multiplier based upon the ConVar "TalkRange".
	--
	-- Genius, 'miryt?

	local cc = {}
	cc.simple = true
	cc.cmd = cmd
	cc.range = range
	cc.form = form

	CAKE.ChatCommands[prefix] = cc
end

function CAKE.ChatCommand(prefix, callback)
	local cc = {}
	cc.simple = false
	cc.cmd = prefix
	cc.callback = callback

	CAKE.ChatCommands[prefix] = cc
end

function GM:PlayerSay(ply, text, toall)
	saywhat = string.lower(text)

	if string.find(saywhat, "hack") or string.find(saywhat, "hax") or string.find(saywhat, "h4x") or string.find(saywhat, "h4ck") then
		if ply.LastHax < os.time()-20 then
			ply:EmitSound(taunt[math.random(#taunt)], 100, 100)
			ply.LastHax = os.time()
		end
	end

	DB.LogEvent("chat", ply:SteamID() .. ": " .. text) -- we be spyins.
	CAKE.CallHook("PlayerSay", ply, text, toall)

	if string.sub(text, 1, 1) == "!" then -- All rp_ commands can be executed with !
		ply:ConCommand("rp_" .. string.sub( text, 2, string.len(text) ))
		return ""
	end

	for prefix, cc in pairs(CAKE.ChatCommands) do
		local cmd = prefix
		local cmdlen = string.len(cmd)
		local cmdtxt = string.sub(text, 0, cmdlen)

		cmdtxt = string.lower(cmdtxt)
		cmd = string.lower(cmd)

		if cmdtxt == cmd and (string.sub(text, cmdlen + 1, cmdlen + 1) == " " or string.len(text) == cmdlen) then -- This allows for multiple commands to start with the same thing
			local args = string.sub(text, cmdlen + 2)

			if args == nil then
				args = ""
			end

			if not cc.simple then
				return cc.callback(ply, args)
			end

			local range = CAKE.ConVars["TalkRange"] * cc.range

			local s = cc.form
			local s = string.gsub(s, "$1", ply:Nick()) -- IC Name
			local s = string.gsub(s, "$2", ply:Name()) -- OOC Name
			local s = string.gsub(s, "$3", args) -- Text

			for _, pl in pairs(player.GetAll()) do
				if pl:EyePos():Distance(ply:EyePos()) <= range then
					CAKE.Response(pl, s)
				end
			end

			return ""
		end
	end

	if string.sub(text, 1, 1) == "/" then
		CAKE.Response(ply, TEXT.CommandInvalid)
		return ""
	else
		-- Hurr, IC Chat..

		local range = CAKE.ConVars["TalkRange"]

		for _, pl in pairs(player.GetAll()) do
			if pl:EyePos():Distance(ply:EyePos()) <= range then
				CAKE.Response(pl, ply:Nick() .. ": " .. text)
			end
		end

		return ""
	end
end
