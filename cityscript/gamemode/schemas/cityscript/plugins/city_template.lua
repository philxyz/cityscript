PLUGIN.Name = "CityScript Team Templates" -- What is the pugin name
PLUGIN.Author = "philxyz" -- Author of the plugin
PLUGIN.Description = "A collection of team making functions." -- The description or purpose of the plugin

function PLUGIN.Init()

end

function CombineDeath(ply)
	util.PrecacheSound("npc/metropolice/die2.wav")
	util.PrecacheSound("npc/overwatch/radiovoice/lostbiosignalforunit.wav")

	ply:EmitSound("npc/metropolice/die2.wav")

	local function EmitThatShit()
		ply:EmitSound("npc/overwatch/radiovoice/lostbiosignalforunit.wav")
	end

	timer.Simple(3, EmitThatShit)
end

function CAKE.CityScriptTeam(name, color, model_path, default_model, partial_model, weapons, role_key, can_access_restricted_areas, radio_groups, sound_groups, item_groups, salary, public, business, broadcast, iscombine)
	local team = CAKE.TeamObject()

	team.name = name or "Citizen"
	team.color = color or Color(0, 255, 0, 255)
	team.model_path = model_path or ""
	team.default_model = default_model or false
	team.partial_model = partial_model or false
	team.weapons = weapons or {}
	team.role_key = role_key or "citizen"
	team.can_access_restricted_areas = can_access_restricted_areas or false
	team.radio_groups = radio_groups or {}
	team.sound_groups = sound_groups or {1}
	team.item_groups = item_groups or {}
	team.salary = salary or 25
	team.public = public or true
	team.business = business or false
	team.broadcast = broadcast or false
	team.iscombine = iscombine or false

	if team.iscombine == true then
		CAKE.AddTeamHook("PlayerDeath", team.role_key .. "_combinedeath", CombineDeath, team.role_key)
	end

	return team
end
