PLUGIN.Name = "Player Voices" -- What is the plugin name
PLUGIN.Author = "LuaBanana" -- Author of the plugin
PLUGIN.Description = "Enables players to say things" -- The description or purpose of the plugin

CAKE.Voices = {} -- I hear voices D:>

function ccVoice(ply, cmd, args) -- People near you will hear the voice
	local id = args[1]
	
	if CAKE.Voices[id] == nil then
		CAKE.Response(ply, TEXT.SoundDoesNotExist)
		return
	end

	local voice = CAKE.Voices[id]
	local team = ply:Team()
	
	if table.HasValue(CAKE.Teams[team].sound_groups, voice.soundgroup) then
		local path = voice.path
		
		if (string.find(string.lower(ply:GetModel()), "female") or string.lower(ply:GetModel()) == "models/alyx.mdl") and voice.femalealt ~= "" then
			path = voice.femalealt
		end
		
		if CAKE.Teams[team].rations == true then
			-- This is a combine team, thus we will give them COMBINE STYLE VOICES.
			util.PrecacheSound("/npc/metropolice/vo/on2.wav")
			util.PrecacheSound("/npc/metropolice/vo/off2.wav")
			
			ply:EmitSound("/npc/metropolice/vo/on2.wav")
			
			local function EmitThatShit()
				ply:EmitSound(path)
			end

			timer.Simple(1, EmitThatShit)
			
			return ""
		end
			
		util.PrecacheSound(path)
		ply:EmitSound(path)
		ply:ConCommand("say " .. voice.line .. "\n")
	end
end
concommand.Add("rp_voice", ccVoice)

function ccListVoice(ply, cmd, args)
	CAKE.Response(ply, TEXT.ListOfVoicesHeader)
	CAKE.Response(ply, TEXT.NoteFlagSpecific)
	
	for _, voice in pairs(CAKE.Voices) do
		if table.HasValue(CAKE.Teams[ply:Team()]["sound_groups"], voice.soundgroup) then
			CAKE.Response(ply, _ .. " - " .. voice.line .. " - " .. voice.path)
		end
	end
end
concommand.Add( "rp_listvoices", ccListVoice)

function CAKE.AddVoice(id, path, soundgroup, text, fa)
	local voice = {}
	voice.path = path
	voice.soundgroup = soundgroup or 0
	voice.line = text or ""
	voice.femalealt = fa or ""
	
	CAKE.Voices[id] = voice
end
