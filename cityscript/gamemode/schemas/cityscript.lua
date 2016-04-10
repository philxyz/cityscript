SCHEMA.Name = "CityScript"
SCHEMA.Author = "philxyz"
SCHEMA.Description = "City Roleplay"
SCHEMA.Base = "global"

function SCHEMA.SetUp()
	-- name, color, model_path, default_model, partial_model, weapons, role_key, can_access_restricted_areas, radio_groups, sound_groups, item_groups, salary, public, business, broadcast

	-- Item Groups
	-- Groceries: 2
	-- Guns: 3
	-- Cars: 4
	-- Black Market: 5
	-- Medical Supplies: 7

	-- Door + Radio + Sound Groups
	-- Combine: 1
	-- Medical: 2
	-- Blood Brothers: 3
	-- La famiglia Vontorini: 4
	-- The Legion: 7

	-- Radio Groups
	-- Combine: 1
	-- Rebel: 2

	-- Citizens
	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.Citizen)) -- Citizen
	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.GroceryStoreOwner, nil, nil, nil, nil, nil, "grocery", false, nil, { 1 }, { 2 }, 0, true, true, nil)) -- Grocery Store Owner
	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.GunStoreOwner, nil, nil, nil, nil, nil, "gun", false, nil, { 1 }, { 3 }, 0, true, true, nil))
	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.CarDealershipOwner, nil, nil, nil, nil, nil, "car", false, nil, { 1 }, { 4 }, 0, true, true, nil))
	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.BlackMarketDealer, nil, nil, nil, nil, nil, "bm", false, nil, { 1 }, { 5 }, 0, true, true, false))
	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.MedicalSpecialist, nil, nil, nil, nil, nil, "doctor", false, { 2 }, { 1 }, { 7 }, 0, true, true, nil)) -- Doctor

	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.BloodBrothersGangLeader, Color(255, 0, 0, 255), "models/player/group03/", true, true, nil, "bloodldr", false, { 3 }, { 1 }, { 1 }, 10, true, false, nil))
	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.BloodBrothersGangMember, Color(248, 0, 0, 255), "models/player/group03/", true, true, nil, "blood", false, { 3 }, { 1 }, { 1 }, 10, true, false, nil))

	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.LaFamigliaVontoriniGangLeader, Color(0, 0, 10, 255), "models/player/group03/", true, true, nil, "vontldr", false, { 4 }, { 1 }, { 1 }, 10, true, false, nil))
	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.LaFamigliaVontoriniGangMember, Color(0, 0, 0, 255), "models/player/group03/", true, true, nil, "vont", false, { 4 }, { 1 }, { 1 }, 10, true, false, nil))

	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.TheLegionGangLeader, Color(0, 0, 10, 255), "models/player/group03/", true, true, nil, "legionldr", false, { 7 }, { 1 }, { 1 }, 10, true, false, nil))
	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.TheLegionGangMember, Color(0, 0, 0, 255), "models/player/group03/", true, true, nil, "legion", false, { 7 }, { 1 }, { 1 }, 10, true, false, nil))

	-- Police
	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.CityPolice, Color(0, 0, 200, 255), "models/police.mdl", true, false, {"weapon_stunstick", "bb_usp_alt", "door_ram", "arrest_stick", "unarrest_stick"}, "cp", true, {1}, {1, 2}, {1}, 50, true, true, true)) -- Civil Protection

	-- Mayor
	CAKE.AddTeam(CAKE.CityScriptTeam(TEXT.CityMayor, Color(150, 0, 0, 255), "models/breen.mdl", true, false, {"m9k_m29satan"}, "ca", true, {1}, {1}, {1}, 200, false, false, true)) -- City Administrator


	-- Selectable models on character creation
	-- Bogus models were needed because the shitty derma doesn't wanna scroll unless it has a certain amount of models.
	CAKE.AddModels({
		"models/player/group01/male_01.mdl",
		"models/player/group01/male_02.mdl",
		"models/player/group01/male_03.mdl",
		"models/player/group01/male_04.mdl",
		"models/player/group01/male_06.mdl",
		"models/player/group01/male_07.mdl",
		"models/player/group01/male_08.mdl",
		"models/player/group01/male_09.mdl",
		"models/player/group01/female_01.mdl",
		"models/player/group01/female_02.mdl",
		"models/player/group01/female_03.mdl",
		"models/player/group01/female_04.mdl",
		"models/player/group01/female_06.mdl",
		"models/player/group01/female_07.mdl"
	})
end
