NPC_ANIMS_ENABLED = false
CAN_SELECT_NPCMODEL = true

--Weapons that are always aimed
AlwaysAimed = 
{
	"arrest_stick",
	"unarrest_stick",
	"weapon_nukepack",
	"door_ram",
	"fire_extinguisher",
	"hl2_combo_fists",
	"lockpick",
	"weapon_physgun",
	"weapon_physcannon",
	"weapon_frag",
	"weapon_slam",
	"weapon_rpg",
	"gmod_tool"
}

--Weapons that are never aimed
NeverAimed =
{
	"hands"
}

--Weapons that can still be usable while not aimed
UsableHolstered =
{
}

function SelectNPCModel( ply, cmd, args )
	
	if( not CAN_SELECT_NPCMODEL ) then
		return;
	end

	local requestedmodel = args[1]
	if( requestedmodel ~= nil ) then
		string.lower( requestedmodel )
	end
	
	local validmodel = false
	local validmodels = {}
	
	table.Add( validmodels, NPCAnim.CitizenMaleModels )
	table.Add( validmodels, NPCAnim.CitizenFemaleModels )
	table.Add( validmodels, NPCAnim.CombineMetroModels )
	table.Add( validmodels, NPCAnim.CombineOWModels )
	
	for k, v in pairs( validmodels ) do
		string.lower( v )
		if( v == requestedmodel ) then
			validmodel = true
		end
	end
	
	if( validmodel or requestedmodel == not nil ) then
		ply:SetModel( args[1] )
		else
		ply:PrintMessage( 2, "That is not a valid model! You can select from the following models:" )
		for k, v in pairs ( validmodels ) do
			ply:PrintMessage( 2, tostring( v ) )
		end
	end
	
end
concommand.Add( "rp_selectmodel", SelectNPCModel )


function HolsterToggle( ply )

	if( not NPC_ANIMS_ENABLED ) then return; end

	if( not ply:GetActiveWeapon():IsValid() ) then
		return;
	end

	if( ply:GetNWInt( "holstered" ) == 1 ) then
		
		for j, l in pairs( NeverAimed ) do
			
			if( l == ply:GetActiveWeapon():GetClass() ) then
				return;
			end
			
		end
	
		MakeAim( ply );
	else
		
		for j, l in pairs( AlwaysAimed ) do
			
			if( l == ply:GetActiveWeapon():GetClass() ) then
				return;
			end
			
		end
		
		MakeUnAim( ply );
	end

end
concommand.Add( "rp_toggleholster", HolsterToggle );
concommand.Add( "toggleholster", HolsterToggle );

function MakeAim( ply )

	if( not ply:GetActiveWeapon():GetTable().Invisible ) then
		ply:DrawViewModel( true );
		ply:DrawWorldModel( true );
	else
		ply:DrawViewModel( false );
		ply:DrawWorldModel( false );
	end
	
	ply:GetActiveWeapon():SetNWBool( "NPCAimed", true );
	ply:GetActiveWeapon():SetNextPrimaryFire( CurTime() );
	
	ply:SetNWInt( "holstered", 0 );

end

function MakeUnAim( ply )

	ply:DrawViewModel( false );
	
	if( ply:GetActiveWeapon():IsValid() ) then
		ply:GetActiveWeapon():SetNWBool( "NPCAimed", false );
		
		local delay = true;
		
		for k, v in pairs( UsableHolstered ) do
			if( v == ply:GetActiveWeapon():GetClass() ) then
				delay = false;
			end
		end
		
		if( delay ) then
			ply:GetActiveWeapon():SetNextPrimaryFire( CurTime() + 999999 );
		end
		
		if( ply:GetActiveWeapon():GetNWBool( "ironsights" ) ) then
			ply:GetActiveWeapon():ToggleIronsight();
		end
	end
	
	ply:SetNWInt( "holstered", 1 );

end

function NPCPlayerThink()

	if( not NPC_ANIMS_ENABLED ) then return; end

	for k, v in pairs( player.GetAll() ) do
	
		if( not v:GetTable().NPCLastWeapon or not v:GetActiveWeapon():IsValid() or v:GetTable().NPCLastWeapon ~= v:GetActiveWeapon():GetClass() ) then
	
			MakeUnAim( v );
			
			v:GetTable().NPCLastWeapon = "";
			
			if( v:GetActiveWeapon():IsValid() ) then
			
				v:GetTable().NPCLastWeapon = v:GetActiveWeapon():GetClass();
			
				for j, l in pairs( AlwaysAimed ) do
				
					if( l == v:GetActiveWeapon():GetClass() and not v:GetActiveWeapon():GetNWBool( "NPCAimed" ) ) then
						MakeAim( v );
					end
				
				end
			
			end
			
		end
	
	end

end
hook.Add( "Think", "NPCPlayerThink", NPCPlayerThink );


NPCAnim = { }

NPCAnim.CitizenMaleAnim = { }
NPCAnim.CitizenMaleModels = 
{

	      "models/player/group01/male_01.mdl",
              "models/player/group01/male_02.mdl",
              "models/player/group01/male_03.mdl",
              "models/player/group01/male_04.mdl",
              "models/player/group01/male_06.mdl",
              "models/player/group01/male_07.mdl",
              "models/player/group01/male_08.mdl",
              "models/player/group01/male_09.mdl",
              "models/player/group02/male_01.mdl",
              "models/player/group02/male_02.mdl",
              "models/player/group02/male_03.mdl",
              "models/player/group02/male_04.mdl",
              "models/player/group02/male_06.mdl",
              "models/player/group02/male_07.mdl",
              "models/player/group02/male_08.mdl",
              "models/player/group02/male_09.mdl",
              "models/player/group03/male_01.mdl",
              "models/player/group03/male_02.mdl",
              "models/player/group03/male_03.mdl",
              "models/player/group03/male_04.mdl",
              "models/player/group03/male_06.mdl",
              "models/player/group03/male_07.mdl",
              "models/player/group03/male_08.mdl",
              "models/player/group03/male_09.mdl",
              "models/player/group03m/male_01.mdl",
              "models/player/group03m/male_02.mdl",
              "models/player/group03m/male_03.mdl",
              "models/player/group03m/male_04.mdl",
              "models/player/group03m/male_06.mdl",
              "models/player/group03m/male_07.mdl",
              "models/player/group03m/male_08.mdl",
              "models/player/group03m/male_09.mdl"
}



for k, v in pairs( NPCAnim.CitizenMaleModels ) do

	NPCAnim.CitizenMaleModels[k] = string.lower( v );

end


NPCAnim.CitizenMaleAnim["idle"] = ACT_IDLE
NPCAnim.CitizenMaleAnim["walk"] = ACT_WALK
NPCAnim.CitizenMaleAnim["run"] = ACT_RUN
NPCAnim.CitizenMaleAnim["jump"] = ACT_JUMP
NPCAnim.CitizenMaleAnim["land"] = ACT_LAND
NPCAnim.CitizenMaleAnim["glide"] = ACT_GLIDE
NPCAnim.CitizenMaleAnim["sit"] = ACT_BUSY_SIT_CHAIR
NPCAnim.CitizenMaleAnim["crouch"] = ACT_COVER_LOW
NPCAnim.CitizenMaleAnim["crouchwalk"] = ACT_WALK_CROUCH
 
NPCAnim.CitizenMaleAnim["pistolidle"] = "ACT_IDLE"
NPCAnim.CitizenMaleAnim["pistolwalk"] = "ACT_WALK"
NPCAnim.CitizenMaleAnim["pistolrun"] = "ACT_RUN"
NPCAnim.CitizenMaleAnim["pistolcrouchwalk"] = "ACT_WALK_CROUCH"
NPCAnim.CitizenMaleAnim["pistolcrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenMaleAnim["pistolaimidle"] = "ACT_IDLE_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["pistolaimwalk"] = "ACT_WALK_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["pistolaimrun"] = "ACT_RUN_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["pistolaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CitizenMaleAnim["pistolaimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenMaleAnim["pistolreload"] = "ACT_GESTURE_RELOAD_SMG1"
NPCAnim.CitizenMaleAnim["pistolfire"] = "ACT_RANGE_ATTACK_PISTOL"
 
NPCAnim.CitizenMaleAnim["smgidle"] = "ACT_IDLE_SMG1_RELAXED"
NPCAnim.CitizenMaleAnim["smgrun"] = "ACT_RUN_RIFLE_RELAXED"
NPCAnim.CitizenMaleAnim["smgwalk"] = "ACT_WALK_RIFLE_RELAXED"
NPCAnim.CitizenMaleAnim["smgaimidle"] = "ACT_IDLE_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["smgaimwalk"] = "ACT_WALK_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["smgcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CitizenMaleAnim["smgcrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenMaleAnim["smgaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CitizenMaleAnim["smgaimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenMaleAnim["smgaimrun"] = "ACT_RUN_AIM_RIFLE"
NPCAnim.CitizenMaleAnim["smgreload"] = "ACT_GESTURE_RELOAD_SMG1"
NPCAnim.CitizenMaleAnim["smgfire"] = "ACT_RANGE_ATTACK_SMG1"
 
NPCAnim.CitizenMaleAnim["ar2idle"] = "ACT_IDLE_SMG1_RELAXED"
NPCAnim.CitizenMaleAnim["ar2walk"] = "ACT_WALK_RIFLE_RELAXED"
NPCAnim.CitizenMaleAnim["ar2run"] = "ACT_RUN_RIFLE_RELAXED"
NPCAnim.CitizenMaleAnim["ar2aimidle"] = "ACT_IDLE_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["ar2aimwalk"] = "ACT_WALK_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["ar2aimrun"] = "ACT_RUN_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["ar2crouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CitizenMaleAnim["ar2crouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenMaleAnim["ar2aimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CitizenMaleAnim["ar2aimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenMaleAnim["ar2reload"] = "ACT_GESTURE_RELOAD_SMG1"
NPCAnim.CitizenMaleAnim["ar2fire"] = "ACT_RANGE_ATTACK_AR2"
 
NPCAnim.CitizenMaleAnim["shotgunidle"] = "ACT_IDLE_SHOTGUN_STIMULATED"
NPCAnim.CitizenMaleAnim["shotgunwalk"] = "ACT_WALK_RIFLE_RELAXED"
NPCAnim.CitizenMaleAnim["shotgunrun"] = "ACT_RUN_RIFLE_RELAXED"
NPCAnim.CitizenMaleAnim["shotgunaimidle"] = "ACT_IDLE_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["shotgunaimwalk"] = "ACT_WALK_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["shotgunaimrun"] = "ACT_RUN_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["shotguncrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CitizenMaleAnim["shotguncrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenMaleAnim["shotgunaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CitizenMaleAnim["shotgunaimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenMaleAnim["shotgunreload"] = "ACT_GESTURE_RELOAD_SMG1"
NPCAnim.CitizenMaleAnim["shotgunfire"] = "ACT_RANGE_ATTACK_SHOTGUN"
 
NPCAnim.CitizenMaleAnim["crossbowidle"] = "ACT_IDLE_SMG1_RELAXED"
NPCAnim.CitizenMaleAnim["crossbowwalk"] = "ACT_WALK_RIFLE_RELAXED"
NPCAnim.CitizenMaleAnim["crossbowrun"] = "ACT_RUN_RIFLE_RELAXED"
NPCAnim.CitizenMaleAnim["crossbowaimidle"] = "ACT_IDLE_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["crossbowaimwalk"] = "ACT_WALK_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["crossbowaimrun"] = "ACT_RUN_AIM_RIFLE"
NPCAnim.CitizenMaleAnim["crossbowcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CitizenMaleAnim["crossbowcrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenMaleAnim["crossbowaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CitizenMaleAnim["crossbowaimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenMaleAnim["crossbowreload"] = "ACT_GESTURE_RELOAD_SMG1"
NPCAnim.CitizenMaleAnim["crossbowfire"] = "ACT_RANGE_ATTACK_SHOTGUN"
 
NPCAnim.CitizenMaleAnim["meleeidle"] = "ACT_IDLE"
NPCAnim.CitizenMaleAnim["meleewalk"] = "ACT_WALK"
NPCAnim.CitizenMaleAnim["meleerun"] = "ACT_RUN"
NPCAnim.CitizenMaleAnim["meleeaimidle"] = "ACT_IDLE_MANNEDGUN"
NPCAnim.CitizenMaleAnim["meleeaimcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CitizenMaleAnim["meleeaimcrouch"] = "ACT_COWER"
NPCAnim.CitizenMaleAnim["meleecrouchwalk"] = "ACT_WALK_CROUCH"
NPCAnim.CitizenMaleAnim["meleecrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenMaleAnim["meleeaimwalk"] = "ACT_WALK_AIM_RIFLE"
NPCAnim.CitizenMaleAnim["meleeaimrun"] = "ACT_SPRINT"
NPCAnim.CitizenMaleAnim["meleefire"] = "ACT_MELEE_ATTACK_SWING"
 
NPCAnim.CitizenMaleAnim["rpgidle"] = "ACT_IDLE_RPG"
NPCAnim.CitizenMaleAnim["rpgwalk"] = "ACT_WALK_RPG"
NPCAnim.CitizenMaleAnim["rpgrun"] = "ACT_RUN_RPG"
NPCAnim.CitizenMaleAnim["rpgaimidle"] = "ACT_IDLE_ANGRY_RPG"
NPCAnim.CitizenMaleAnim["rpgaimwalk"] = "ACT_WALK_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["rpgaimrun"] = "ACT_RUN_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenMaleAnim["rpgcrouchwalk"] = "ACT_WALK_CROUCH_RPG"
NPCAnim.CitizenMaleAnim["rpgcrouch"] = "ACT_COVER_LOW_RPG"
NPCAnim.CitizenMaleAnim["rpgaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CitizenMaleAnim["rpgaimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenMaleAnim["rpgfire"] = "ACT_RANGE_ATTACK_RPG"
 
NPCAnim.CitizenMaleAnim["grenadeidle"] = "ACT_IDLE"
NPCAnim.CitizenMaleAnim["grenadewalk"] = "ACT_WALK"
NPCAnim.CitizenMaleAnim["grenaderun"] = "ACT_RUN"
NPCAnim.CitizenMaleAnim["grenadeaimidle"] = "ACT_IDLE"
NPCAnim.CitizenMaleAnim["grenadeaimcrouchwalk"] = "ACT_WALK_CROUCH"
NPCAnim.CitizenMaleAnim["grenadeaimcrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenMaleAnim["grenadecrouchwalk"] = "ACT_WALK_CROUCH"
NPCAnim.CitizenMaleAnim["grenadecrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenMaleAnim["grenadeaimwalk"] = "ACT_WALK"
NPCAnim.CitizenMaleAnim["grenadeaimrun"] = "ACT_RUN"
NPCAnim.CitizenMaleAnim["grenadefire"] = "ACT_RANGE_ATTACK_THROW"
 
NPCAnim.CitizenMaleAnim["slamidle"] = "ACT_IDLE_SUITCASE"
NPCAnim.CitizenMaleAnim["slamwalk"] = "ACT_WALK_SUITCASE"
NPCAnim.CitizenMaleAnim["slamrun"] = "ACT_RUN"
NPCAnim.CitizenMaleAnim["slamaimidle"] = "ACT_IDLE_PACKAGE"
NPCAnim.CitizenMaleAnim["slamaimcrouchwalk"] = "ACT_WALK_CROUCH_RPG"
NPCAnim.CitizenMaleAnim["slamaimcrouch"] = "ACT_COVER_LOW_RPG"
NPCAnim.CitizenMaleAnim["slamcrouchwalk"] = "ACT_WALK_CROUCH_RPG"
NPCAnim.CitizenMaleAnim["slamcrouch"] = "ACT_COVER"
NPCAnim.CitizenMaleAnim["slamaimwalk"] = "ACT_WALK_PACKAGE"
NPCAnim.CitizenMaleAnim["slamaimrun"] = "ACT_RUN_RPG"
NPCAnim.CitizenMaleAnim["slamfire"] = "ACT_PICKUP_GROUND"
 
NPCAnim.CitizenMaleAnim["physgunidle"] = "ACT_IDLE_SMG1_RELAXED"
NPCAnim.CitizenMaleAnim["physgunwalk"] = "ACT_WALK_RIFLE_RELAXED"
NPCAnim.CitizenMaleAnim["physgunrun"] = "ACT_RUN_RIFLE_RELAXED"
NPCAnim.CitizenMaleAnim["physgunaimidle"] = "ACT_IDLE_SMG1_STIMULATED"
NPCAnim.CitizenMaleAnim["physgunaimwalk"] = "ACT_WALK_AIM_RIFLE"
NPCAnim.CitizenMaleAnim["physgunaimrun"] = "ACT_RUN_AIM_RIFLE"
NPCAnim.CitizenMaleAnim["physgunaimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenMaleAnim["physgunaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"

NPCAnim.CitizenFemaleAnim = { }
NPCAnim.CitizenFemaleModels = 
{
	
              "models/player/group01/female_01.mdl",
              "models/player/group01/female_02.mdl",
              "models/player/group01/female_03.mdl",
              "models/player/group01/female_04.mdl",
              "models/player/group01/female_06.mdl",
              "models/player/group01/female_07.mdl",
              "models/player/group02/female_01.mdl",
              "models/player/group02/female_02.mdl",
              "models/player/group02/female_03.mdl",
              "models/player/group02/female_04.mdl",
              "models/player/group02/female_06.mdl",
              "models/player/group02/female_07.mdl",
              "models/player/group03/female_01.mdl",
              "models/player/group03/female_02.mdl",
              "models/player/group03/female_03.mdl",
              "models/player/group03/female_04.mdl",
              "models/player/group03/female_06.mdl",
              "models/player/group03/female_07.mdl",
              "models/player/group03m/female_01.mdl",
              "models/player/group03m/female_02.mdl",
              "models/player/group03m/female_03.mdl",
              "models/player/group03m/female_04.mdl",
              "models/player/group03m/female_06.mdl",
              "models/player/group03m/female_07.mdl"	  
}

for k, v in pairs( NPCAnim.CitizenFemaleModels ) do

	NPCAnim.CitizenFemaleModels[k] = string.lower( v );

end

NPCAnim.CitizenFemaleAnim["idle"] = "ACT_IDLE"
NPCAnim.CitizenFemaleAnim["walk"] = "ACT_WALK"
NPCAnim.CitizenFemaleAnim["run"] = "ACT_RUN"
NPCAnim.CitizenFemaleAnim["jump"] = "ACT_JUMP"
NPCAnim.CitizenFemaleAnim["land"] = "ACT_LAND"
NPCAnim.CitizenFemaleAnim["glide"] = "ACT_GLIDE"
NPCAnim.CitizenFemaleAnim["sit"] = "ACT_BUSY_SIT_CHAIR"
NPCAnim.CitizenFemaleAnim["crouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenFemaleAnim["crouchwalk"] = "ACT_WALK_CROUCH"
 
NPCAnim.CitizenFemaleAnim["pistolidle"] = "ACT_IDLE"
NPCAnim.CitizenFemaleAnim["pistolwalk"] = "ACT_WALK"
NPCAnim.CitizenFemaleAnim["pistolrun"] = "ACT_RUN"
NPCAnim.CitizenFemaleAnim["pistolcrouchwalk"] = "ACT_WALK_CROUCH"
NPCAnim.CitizenFemaleAnim["pistolcrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenFemaleAnim["pistolaimidle"] = "ACT_IDLE_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["pistolaimwalk"] = "ACT_WALK_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["pistolaimrun"] = "ACT_RUN_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["pistolaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CitizenFemaleAnim["pistolaimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["pistolreload"] = "ACT_GESTURE_RELOAD_SMG1"
NPCAnim.CitizenFemaleAnim["pistolfire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
 
NPCAnim.CitizenFemaleAnim["smgidle"] = "ACT_IDLE_SMG1_RELAXED"
NPCAnim.CitizenFemaleAnim["smgrun"] = "ACT_RUN_RIFLE_RELAXED"
NPCAnim.CitizenFemaleAnim["smgwalk"] = "ACT_WALK_RIFLE_RELAXED"
NPCAnim.CitizenFemaleAnim["smgaimidle"] = "ACT_IDLE_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["smgaimwalk"] = "ACT_WALK_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["smgcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CitizenFemaleAnim["smgcrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenFemaleAnim["smgaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CitizenFemaleAnim["smgaimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["smgaimrun"] = "ACT_RUN_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["smgreload"] = "ACT_GESTURE_RELOAD_SMG1"
NPCAnim.CitizenFemaleAnim["smgfire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
 
NPCAnim.CitizenFemaleAnim["ar2idle"] = "ACT_IDLE_SMG1_RELAXED"
NPCAnim.CitizenFemaleAnim["ar2walk"] = "ACT_WALK_RIFLE_RELAXED"
NPCAnim.CitizenFemaleAnim["ar2run"] = "ACT_RUN_RIFLE_RELAXED"
NPCAnim.CitizenFemaleAnim["ar2aimidle"] = "ACT_IDLE_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["ar2aimwalk"] = "ACT_WALK_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["ar2aimrun"] = "ACT_RUN_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["ar2crouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CitizenFemaleAnim["ar2crouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenFemaleAnim["ar2aimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CitizenFemaleAnim["ar2aimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["ar2reload"] = "ACT_GESTURE_RELOAD_SMG1"
NPCAnim.CitizenFemaleAnim["ar2fire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
 
NPCAnim.CitizenFemaleAnim["shotgunidle"] = "ACT_IDLE_SHOTGUN_STIMULATED"
NPCAnim.CitizenFemaleAnim["shotgunwalk"] = "ACT_WALK_RIFLE_RELAXED"
NPCAnim.CitizenFemaleAnim["shotgunrun"] = "ACT_RUN_RIFLE_RELAXED"
NPCAnim.CitizenFemaleAnim["shotgunaimidle"] = "ACT_IDLE_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["shotgunaimwalk"] = "ACT_WALK_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["shotgunaimrun"] = "ACT_RUN_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["shotguncrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CitizenFemaleAnim["shotguncrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenFemaleAnim["shotgunaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CitizenFemaleAnim["shotgunaimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["shotgunreload"] = "ACT_GESTURE_RELOAD_SMG1"
NPCAnim.CitizenFemaleAnim["shotgunfire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
 
NPCAnim.CitizenFemaleAnim["crossbowidle"] = "ACT_IDLE_SMG1_RELAXED"
NPCAnim.CitizenFemaleAnim["crossbowwalk"] = "ACT_WALK_RIFLE_RELAXED"
NPCAnim.CitizenFemaleAnim["crossbowrun"] = "ACT_RUN_RIFLE_RELAXED"
NPCAnim.CitizenFemaleAnim["crossbowaimidle"] = "ACT_IDLE_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["crossbowaimwalk"] = "ACT_WALK_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["crossbowaimrun"] = "ACT_RUN_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["crossbowcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CitizenFemaleAnim["crossbowcrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenFemaleAnim["crossbowaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CitizenFemaleAnim["crossbowaimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["crossbowreload"] = "ACT_GESTURE_RELOAD_SMG1"
NPCAnim.CitizenFemaleAnim["crossbowfire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
 
NPCAnim.CitizenFemaleAnim["meleeidle"] = "ACT_IDLE"
NPCAnim.CitizenFemaleAnim["meleewalk"] = "ACT_WALK"
NPCAnim.CitizenFemaleAnim["meleerun"] = "ACT_RUN"
NPCAnim.CitizenFemaleAnim["meleeaimidle"] = "ACT_IDLE_MANNEDGUN"
NPCAnim.CitizenFemaleAnim["meleeaimcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CitizenFemaleAnim["meleeaimcrouch"] = "ACT_COWER"
NPCAnim.CitizenFemaleAnim["meleecrouchwalk"] = "ACT_WALK_CROUCH"
NPCAnim.CitizenFemaleAnim["meleecrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenFemaleAnim["meleeaimwalk"] = "ACT_WALK_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["meleeaimrun"] = "ACT_SPRINT"
NPCAnim.CitizenFemaleAnim["meleefire"] = "ACT_MELEE_ATTACK_SWING"
 
NPCAnim.CitizenFemaleAnim["rpgidle"] = "ACT_IDLE_RPG"
NPCAnim.CitizenFemaleAnim["rpgwalk"] = "ACT_WALK_RPG"
NPCAnim.CitizenFemaleAnim["rpgrun"] = "ACT_RUN_RPG"
NPCAnim.CitizenFemaleAnim["rpgaimidle"] = "ACT_IDLE_ANGRY_RPG"
NPCAnim.CitizenFemaleAnim["rpgaimwalk"] = "ACT_WALK_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["rpgaimrun"] = "ACT_RUN_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["rpgcrouchwalk"] = "ACT_WALK_CROUCH_RPG"
NPCAnim.CitizenFemaleAnim["rpgcrouch"] = "ACT_COVER_LOW_RPG"
NPCAnim.CitizenFemaleAnim["rpgaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CitizenFemaleAnim["rpgaimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["rpgfire"] = "ACT_GESTURE_RANGE_ATTACK_SMG1"
 
NPCAnim.CitizenFemaleAnim["grenadeidle"] = "ACT_IDLE"
NPCAnim.CitizenFemaleAnim["grenadewalk"] = "ACT_WALK"
NPCAnim.CitizenFemaleAnim["grenaderun"] = "ACT_RUN"
NPCAnim.CitizenFemaleAnim["grenadeaimidle"] = "ACT_IDLE"
NPCAnim.CitizenFemaleAnim["grenadeaimcrouchwalk"] = "ACT_WALK_CROUCH"
NPCAnim.CitizenFemaleAnim["grenadeaimcrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenFemaleAnim["grenadecrouchwalk"] = "ACT_WALK_CROUCH"
NPCAnim.CitizenFemaleAnim["grenadecrouch"] = "ACT_COVER_LOW"
NPCAnim.CitizenFemaleAnim["grenadeaimwalk"] = "ACT_WALK"
NPCAnim.CitizenFemaleAnim["grenadeaimrun"] = "ACT_RUN"
NPCAnim.CitizenFemaleAnim["grenadefire"] = "ACT_RANGE_ATTACK_THROW"
 
NPCAnim.CitizenFemaleAnim["slamidle"] = "ACT_IDLE_SUITCASE"
NPCAnim.CitizenFemaleAnim["slamwalk"] = "ACT_WALK_SUITCASE"
NPCAnim.CitizenFemaleAnim["slamrun"] = "ACT_RUN"
NPCAnim.CitizenFemaleAnim["slamaimidle"] = "ACT_IDLE_PACKAGE"
NPCAnim.CitizenFemaleAnim["slamaimcrouchwalk"] = "ACT_WALK_CROUCH_RPG"
NPCAnim.CitizenFemaleAnim["slamaimcrouch"] = "ACT_COVER_LOW_RPG"
NPCAnim.CitizenFemaleAnim["slamcrouchwalk"] = "ACT_WALK_CROUCH_RPG"
NPCAnim.CitizenFemaleAnim["slamcrouch"] = "ACT_COVER"
NPCAnim.CitizenFemaleAnim["slamaimwalk"] = "ACT_WALK_PACKAGE"
NPCAnim.CitizenFemaleAnim["slamaimrun"] = "ACT_RUN_RPG"
NPCAnim.CitizenFemaleAnim["slamfire"] = "ACT_PICKUP_GROUND"
 
NPCAnim.CitizenFemaleAnim["physgunidle"] = "ACT_IDLE_SMG1_RELAXED"
NPCAnim.CitizenFemaleAnim["physgunwalk"] = "ACT_WALK_RIFLE_RELAXED"
NPCAnim.CitizenFemaleAnim["physgunrun"] = "ACT_RUN_RIFLE_RELAXED"
NPCAnim.CitizenFemaleAnim["physgunaimidle"] = "ACT_IDLE_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["physgunaimwalk"] = "ACT_WALK_AIM_RIFLE_STIMULATED"
NPCAnim.CitizenFemaleAnim["physgunaimrun"] = "ACT_RUN_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["physgunaimcrouchwalk"] = "ACT_WALK_CROUCH_AIM_RIFLE"
NPCAnim.CitizenFemaleAnim["physgunaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"

NPCAnim.CombineMetroAnim = { }
NPCAnim.CombineMetroModels =
{
	 "models/police.mdl"
}

for k, v in pairs( NPCAnim.CombineMetroModels ) do

	NPCAnim.CombineMetroModels[k] = string.lower( v );

end


	NPCAnim.CombineMetroAnim["idle"] = "ACT_IDLE"
	NPCAnim.CombineMetroAnim["walk"] = "ACT_WALK"
	NPCAnim.CombineMetroAnim["run"] = "ACT_RUN"
	NPCAnim.CombineMetroAnim["jump"] = "ACT_JUMP"
	NPCAnim.CombineMetroAnim["land"] = "ACT_LAND"
	NPCAnim.CombineMetroAnim["glide"] = "ACT_GLIDE"
	NPCAnim.CombineMetroAnim["sit"] = "ACT_COVER_PISTOL_LOW"
	NPCAnim.CombineMetroAnim["crouch"] = "ACT_COVER_PISTOL_LOW"
	NPCAnim.CombineMetroAnim["crouchwalk"] = "ACT_WALK_CROUCH"

	NPCAnim.CombineMetroAnim["pistolidle"] = "ACT_IDLE_PISTOL"
	NPCAnim.CombineMetroAnim["pistolwalk"] = "ACT_WALK_PISTOL"
	NPCAnim.CombineMetroAnim["pistolrun"] = "ACT_RUN_PISTOL"
	NPCAnim.CombineMetroAnim["pistolcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["pistolcrouch"] = "ACT_COVER_PISTOL_LOW"
	NPCAnim.CombineMetroAnim["pistolaimidle"] = "ACT_IDLE_ANGRY_PISTOL"
	NPCAnim.CombineMetroAnim["pistolaimwalk"] = "ACT_WALK_AIM_PISTOL"
	NPCAnim.CombineMetroAnim["pistolaimrun"] = "ACT_RUN_AIM_PISTOL"
	NPCAnim.CombineMetroAnim["pistolaimcrouch"] = "ACT_RANGE_AIM_PISTOL_LOW"
	NPCAnim.CombineMetroAnim["pistolaimcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["pistolreload"] = "ACT_RELOAD_PISTOL"
	NPCAnim.CombineMetroAnim["pistolfire"] = "ACT_RANGE_ATTACK_PISTOL"

	NPCAnim.CombineMetroAnim["smgidle"] = "ACT_IDLE_SMG1"
	NPCAnim.CombineMetroAnim["smgrun"] = "ACT_RUN_RIFLE"
	NPCAnim.CombineMetroAnim["smgwalk"] = "ACT_WALK_RIFLE"
	NPCAnim.CombineMetroAnim["smgaimidle"] = "ACT_IDLE_ANGRY_SMG1"
	NPCAnim.CombineMetroAnim["smgaimwalk"] = "ACT_WALK_AIM_RIFLE"
	NPCAnim.CombineMetroAnim["smgcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["smgcrouch"] = "ACT_COVER_SMG1_LOW"
	NPCAnim.CombineMetroAnim["smgaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
	NPCAnim.CombineMetroAnim["smgaimcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["smgaimrun"] = "ACT_RUN_AIM_RIFLE"
	NPCAnim.CombineMetroAnim["smgreload"] = "ACT_RELOAD_SMG1"
	NPCAnim.CombineMetroAnim["smgfire"] = "ACT_RANGE_ATTACK_SMG1"

	NPCAnim.CombineMetroAnim["ar2idle"] = "ACT_IDLE_SMG1"
	NPCAnim.CombineMetroAnim["ar2walk"] = "ACT_WALK_RIFLE"
	NPCAnim.CombineMetroAnim["ar2run"] = "ACT_RUN_RIFLE"
	NPCAnim.CombineMetroAnim["ar2aimidle"] = "ACT_IDLE_ANGRY_SMG1"
	NPCAnim.CombineMetroAnim["ar2aimwalk"] = "ACT_WALK_AIM_RIFLE"
	NPCAnim.CombineMetroAnim["ar2aimrun"] = "ACT_RUN_AIM_RIFLE"
	NPCAnim.CombineMetroAnim["ar2crouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["ar2crouch"] = "ACT_COVER_SMG1_LOW"
	NPCAnim.CombineMetroAnim["ar2aimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
	NPCAnim.CombineMetroAnim["ar2aimcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["ar2reload"] = "ACT_RELOAD_SMG1"
	NPCAnim.CombineMetroAnim["ar2fire"] = "ACT_RANGE_ATTACK_SMG1"

	NPCAnim.CombineMetroAnim["shotgunidle"] = "ACT_IDLE_SMG1"
	NPCAnim.CombineMetroAnim["shotgunwalk"] = "ACT_WALK_RIFLE"
	NPCAnim.CombineMetroAnim["shotgunrun"] = "ACT_RUN_RIFLE"
	NPCAnim.CombineMetroAnim["shotgunaimidle"] = "ACT_IDLE_ANGRY_SMG1"
	NPCAnim.CombineMetroAnim["shotgunaimwalk"] = "ACT_WALK_AIM_RIFLE"
	NPCAnim.CombineMetroAnim["shotgunaimrun"] = "ACT_RUN_AIM_RIFLE"
	NPCAnim.CombineMetroAnim["shotguncrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["shotguncrouch"] = "ACT_COVER_SMG1_LOW"
	NPCAnim.CombineMetroAnim["shotgunaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
	NPCAnim.CombineMetroAnim["shotgunaimcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["shotgunreload"] = "ACT_RELOAD_SMG1"
	NPCAnim.CombineMetroAnim["shotgunfire"] = "ACT_RANGE_ATTACK_SMG1"

	NPCAnim.CombineMetroAnim["crossbowidle"] = "ACT_IDLE_SMG1"
	NPCAnim.CombineMetroAnim["crossbowwalk"] = "ACT_WALK_RIFLE"
	NPCAnim.CombineMetroAnim["crossbowrun"] = "ACT_RUN_RIFLE"
	NPCAnim.CombineMetroAnim["crossbowaimidle"] = "ACT_IDLE_ANGRY_SMG1"
	NPCAnim.CombineMetroAnim["crossbowaimwalk"] = "ACT_WALK_AIM_RIFLE"
	NPCAnim.CombineMetroAnim["crossbowaimrun"] = "ACT_RUN_AIM_RIFLE"
	NPCAnim.CombineMetroAnim["crossbowcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["crossbowcrouch"] = "ACT_COVER_SMG1_LOW"
	NPCAnim.CombineMetroAnim["crossbowaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
	NPCAnim.CombineMetroAnim["crossbowaimcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["crossbowreload"] = "ACT_RELOAD_SMG1"
	NPCAnim.CombineMetroAnim["crossbowfire"] = "ACT_RANGE_ATTACK_SMG1"

	NPCAnim.CombineMetroAnim["meleeidle"] = "ACT_IDLE"
	NPCAnim.CombineMetroAnim["meleewalk"] = "ACT_WALK"
	NPCAnim.CombineMetroAnim["meleerun"] = "ACT_RUN"
	NPCAnim.CombineMetroAnim["meleeaimidle"] = "ACT_IDLE_ANGRY_MELEE"
	NPCAnim.CombineMetroAnim["meleeaimcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["meleeaimcrouch"] = "ACT_COVER_PISTOL_LOW"
	NPCAnim.CombineMetroAnim["meleecrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["meleecrouch"] = "ACT_COVER_PISTOL_LOW"
	NPCAnim.CombineMetroAnim["meleeaimwalk"] = "ACT_WALK_ANGRY"
	NPCAnim.CombineMetroAnim["meleeaimrun"] = "ACT_RUN"
	NPCAnim.CombineMetroAnim["meleefire"] = "ACT_MELEE_ATTACK_SWING"

	NPCAnim.CombineMetroAnim["rpgidle"] = "ACT_IDLE_SMG1"
	NPCAnim.CombineMetroAnim["rpgwalk"] = "ACT_WALK_RIFLE"
	NPCAnim.CombineMetroAnim["rpgrun"] = "ACT_RUN_RIFLE"
	NPCAnim.CombineMetroAnim["rpgaimidle"] = "ACT_IDLE_ANGRY_PISTOL"
	NPCAnim.CombineMetroAnim["rpgaimwalk"] = "ACT_WALK_AIM_PISTOL"
	NPCAnim.CombineMetroAnim["rpgaimrun"] = "ACT_RUN_AIM_PISTOL"
	NPCAnim.CombineMetroAnim["rpgcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["rpgcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
	NPCAnim.CombineMetroAnim["rpgaimcrouch"] = "ACT_RANGE_AIM_PISTOL_LOW"
	NPCAnim.CombineMetroAnim["rpgaimcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["rpgreload"] = "ACT_RELOAD_PISTOL"
	NPCAnim.CombineMetroAnim["rpgfire"] = "ACT_RANGE_ATTACK_PISTOL"

	NPCAnim.CombineMetroAnim["grenadeidle"] = "ACT_IDLE"
	NPCAnim.CombineMetroAnim["grenadewalk"] = "ACT_WALK"
	NPCAnim.CombineMetroAnim["grenaderun"] = "ACT_RUN"
	NPCAnim.CombineMetroAnim["grenadeaimidle"] = "ACT_IDLE"
	NPCAnim.CombineMetroAnim["grenadeaimcrouchwalk"] = "ACT_WALK"
	NPCAnim.CombineMetroAnim["grenadeaimcrouch"] = "ACT_COVER_PISTOL_LOW"
	NPCAnim.CombineMetroAnim["grenadecrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["grenadecrouch"] = "ACT_COVER_PISTOL_LOW"
	NPCAnim.CombineMetroAnim["grenadeaimwalk"] = "ACT_WALK_ANGRY"
	NPCAnim.CombineMetroAnim["grenadeaimrun"] = "ACT_RUN"
	NPCAnim.CombineMetroAnim["grenadefire"] = "ACT_COMBINE_THROW_GRENADE"

	NPCAnim.CombineMetroAnim["slamidle"] = "ACT_IDLE"
	NPCAnim.CombineMetroAnim["slamwalk"] = "ACT_WALK"
	NPCAnim.CombineMetroAnim["slamrun"] = "ACT_RUN"
	NPCAnim.CombineMetroAnim["slamaimidle"] = "ACT_IDLE_MANNEDGUN"
	NPCAnim.CombineMetroAnim["slamaimcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["slamaimcrouch"] = "ACT_RANGE_AIM_PISTOL_LOW"
	NPCAnim.CombineMetroAnim["slamcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["slamcrouch"] = "ACT_COVER_PISTOL_LOW"
	NPCAnim.CombineMetroAnim["slamaimwalk"] = "ACT_WALK_RIFLE"
	NPCAnim.CombineMetroAnim["slamaimrun"] = "ACT_RUN_RIFLE"
	NPCAnim.CombineMetroAnim["slamfire"] = "ACT_PICKUP_GROUND"

	NPCAnim.CombineMetroAnim["physgunidle"] = "ACT_IDLE_SMG1"
	NPCAnim.CombineMetroAnim["physgunwalk"] = "ACT_WALK_RIFLE"
	NPCAnim.CombineMetroAnim["physgunrun"] = "ACT_RUN_RIFLE"
	NPCAnim.CombineMetroAnim["physgunaimidle"] = "ACT_IDLE_ANGRY_SMG1"
	NPCAnim.CombineMetroAnim["physgunaimwalk"] = "ACT_WALK_AIM_RIFLE"
	NPCAnim.CombineMetroAnim["physgunaimrun"] = "ACT_RUN_AIM_RIFLE"
	NPCAnim.CombineMetroAnim["physgunaimcrouchwalk"] = "ACT_WALK_CROUCH"
	NPCAnim.CombineMetroAnim["physgunaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"

NPCAnim.CombineOWAnim = { }

NPCAnim.CombineOWModels =
{
	
	"models/combine_super_soldier.mdl",
	"models/Combine_Soldier.mdl",
	"models/Combine_Soldier_PrisonGuard.mdl",
	"models/soldier_stripped.mdl"

}

for k, v in pairs( NPCAnim.CombineOWModels ) do

	NPCAnim.CombineOWModels[k] = string.lower( v );

end


NPCAnim.CombineOWAnim["idle"] = "ACT_IDLE"
NPCAnim.CombineOWAnim["walk"] = "ACT_WALK_RIFLE"
NPCAnim.CombineOWAnim["run"] = "ACT_RUN_RIFLE"
NPCAnim.CombineOWAnim["jump"] = "ACT_JUMP"
NPCAnim.CombineOWAnim["land"] = "ACT_LAND"
NPCAnim.CombineOWAnim["glide"] = "ACT_GLIDE"
NPCAnim.CombineOWAnim["sit"] = "ACT_COVER_LOW"
NPCAnim.CombineOWAnim["crouch"] = "ACT_COVER_LOW"
NPCAnim.CombineOWAnim["crouchwalk"] = "ACT_WALK_CROUCH_RIFLE"

NPCAnim.CombineOWAnim["pistolidle"] = "ACT_IDLE"
NPCAnim.CombineOWAnim["pistolwalk"] = "ACT_WALK_EASY"
NPCAnim.CombineOWAnim["pistolrun"] = "ACT_RUN_RIFLE"
NPCAnim.CombineOWAnim["pistolcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["pistolcrouch"] = "ACT_COVER_LOW"
NPCAnim.CombineOWAnim["pistolaimidle"] = "ACT_IDLE_ANGRY"
NPCAnim.CombineOWAnim["pistolaimwalk"] = "ACT_WALK_AIM_RIFLE"
NPCAnim.CombineOWAnim["pistolaimrun"] = "ACT_RUN_AIM_RIFLE"
NPCAnim.CombineOWAnim["pistolaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CombineOWAnim["pistolaimcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["pistolreload"] = "ACT_RELOAD"
NPCAnim.CombineOWAnim["pistolfire"] = "ACT_RANGE_ATTACK_SMG1"

NPCAnim.CombineOWAnim["smgidle"] = "ACT_IDLE_SMG1"
NPCAnim.CombineOWAnim["smgrun"] = "ACT_RUN_RIFLE"
NPCAnim.CombineOWAnim["smgwalk"] = "ACT_WALK_RIFLE"
NPCAnim.CombineOWAnim["smgaimidle"] = "ACT_IDLE_ANGRY_SMG1"
NPCAnim.CombineOWAnim["smgaimwalk"] = "ACT_WALK_AIM_RIFLE"
NPCAnim.CombineOWAnim["smgcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["smgcrouch"] = "ACT_COVER_LOW"
NPCAnim.CombineOWAnim["smgaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CombineOWAnim["smgaimcrouchwalk"] = "ACT_RUN_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["smgaimrun"] = "ACT_RUN_AIM_RIFLE"
NPCAnim.CombineOWAnim["smgreload"] = "ACT_RELOAD"
NPCAnim.CombineOWAnim["smgfire"] = "ACT_RANGE_ATTACK_SMG1"

NPCAnim.CombineOWAnim["ar2idle"] = "ACT_IDLE_SMG1"
NPCAnim.CombineOWAnim["ar2walk"] = "ACT_WALK_RIFLE"
NPCAnim.CombineOWAnim["ar2run"] = "ACT_RUN_RIFLE"
NPCAnim.CombineOWAnim["ar2aimidle"] = "ACT_IDLE_ANGRY_SMG1"
NPCAnim.CombineOWAnim["ar2aimwalk"] = "ACT_WALK_AIM_RIFLE"
NPCAnim.CombineOWAnim["ar2aimrun"] = "ACT_RUN_AIM_RIFLE"
NPCAnim.CombineOWAnim["ar2crouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["ar2crouch"] = "ACT_COVER_LOW"
NPCAnim.CombineOWAnim["ar2aimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CombineOWAnim["ar2aimcrouchwalk"] = "ACT_RUN_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["ar2reload"] = "ACT_RELOAD"
NPCAnim.CombineOWAnim["ar2fire"] = "ACT_RANGE_ATTACK_SMG1"

NPCAnim.CombineOWAnim["shotgunidle"] = "ACT_IDLE"
NPCAnim.CombineOWAnim["shotgunwalk"] = "ACT_WALK_EASY"
NPCAnim.CombineOWAnim["shotgunrun"] = "ACT_RUN_RIFLE"
NPCAnim.CombineOWAnim["shotgunaimidle"] = "ACT_IDLE_ANGRY_SHOTGUN"
NPCAnim.CombineOWAnim["shotgunaimwalk"] = "ACT_WALK_AIM_SHOTGUN"
NPCAnim.CombineOWAnim["shotgunaimrun"] = "ACT_RUN_AIM_SHOTGUN"
NPCAnim.CombineOWAnim["shotguncrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["shotguncrouch"] = "ACT_COVER_LOW"
NPCAnim.CombineOWAnim["shotgunaimcrouch"] = "ACT_RANGE_AIM_AR2_LOW"
NPCAnim.CombineOWAnim["shotgunaimcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["shotgunreload"] = "ACT_RELOAD"
NPCAnim.CombineOWAnim["shotgunfire"] = "ACT_RANGE_ATTACK_SHOTGUN"

NPCAnim.CombineOWAnim["crossbowidle"] = "ACT_IDLE_SMG1"
NPCAnim.CombineOWAnim["crossbowwalk"] = "ACT_WALK_RIFLE"
NPCAnim.CombineOWAnim["crossbowrun"] = "ACT_RUN_RIFLE"
NPCAnim.CombineOWAnim["crossbowaimidle"] = "ACT_IDLE_ANGRY_SMG1"
NPCAnim.CombineOWAnim["crossbowaimwalk"] = "ACT_WALK_AIM_RIFLE"
NPCAnim.CombineOWAnim["crossbowaimrun"] = "ACT_RUN_AIM_RIFLE"
NPCAnim.CombineOWAnim["crossbowcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["crossbowcrouch"] = "ACT_COVER_LOW"
NPCAnim.CombineOWAnim["crossbowaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CombineOWAnim["crossbowaimcrouchwalk"] = "ACT_RUN_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["crossbowreload"] = "ACT_RELOAD"
NPCAnim.CombineOWAnim["crossbowfire"] = "ACT_RANGE_ATTACK_SMG1"

NPCAnim.CombineOWAnim["meleeidle"] = "ACT_IDLE"
NPCAnim.CombineOWAnim["meleewalk"] = "ACT_WALK_RIFLE"
NPCAnim.CombineOWAnim["meleerun"] = "ACT_RUN_RIFLE"
NPCAnim.CombineOWAnim["meleeaimidle"] = "ACT_IDLE_MANNEDGUN"
NPCAnim.CombineOWAnim["meleeaimcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["meleeaimcrouch"] = "ACT_RANGE_AIM_AR2_LOW"
NPCAnim.CombineOWAnim["meleecrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["meleecrouch"] = "ACT_COVER_LOW"
NPCAnim.CombineOWAnim["meleeaimwalk"] = "ACT_WALK_AIM_SHOTGUN"
NPCAnim.CombineOWAnim["meleeaimrun"] = "ACT_RUN_AIM_SHOTGUN"
NPCAnim.CombineOWAnim["meleefire"] = "ACT_MELEE_ATTACK1"

NPCAnim.CombineOWAnim["rpgidle"] = "ACT_IDLE_SMG1"
NPCAnim.CombineOWAnim["rpgwalk"] = "ACT_WALK_RIFLE"
NPCAnim.CombineOWAnim["rpgrun"] = "ACT_RUN_RIFLE"
NPCAnim.CombineOWAnim["rpgaimidle"] = "ACT_IDLE_ANGRY_SMG1"
NPCAnim.CombineOWAnim["rpgaimwalk"] = "ACT_WALK_AIM_RIFLE"
NPCAnim.CombineOWAnim["rpgaimrun"] = "ACT_RUN_AIM_RIFLE"
NPCAnim.CombineOWAnim["rpgcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["rpgcrouch"] = "ACT_COVER_LOW"
NPCAnim.CombineOWAnim["rpgaimcrouch"] = "ACT_RANGE_AIM_SMG1_LOW"
NPCAnim.CombineOWAnim["rpgaimcrouchwalk"] = "ACT_RUN_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["rpgreload"] = "ACT_RELOAD"
NPCAnim.CombineOWAnim["rpgfire"] = "ACT_RANGE_ATTACK_SMG1"

NPCAnim.CombineOWAnim["grenadeidle"] = "ACT_IDLE"
NPCAnim.CombineOWAnim["grenadewalk"] = "ACT_WALK_RIFLE"
NPCAnim.CombineOWAnim["grenaderun"] = "ACT_RUN_RIFLE"
NPCAnim.CombineOWAnim["grenadeaimidle"] = "ACT_IDLE"
NPCAnim.CombineOWAnim["grenadeaimcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["grenadeaimcrouch"] = "ACT_COVER_LOW"
NPCAnim.CombineOWAnim["grenadecrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["grenadecrouch"] = "ACT_COVER_LOW"
NPCAnim.CombineOWAnim["grenadeaimwalk"] = "ACT_WALK_GRAVCARRY"
NPCAnim.CombineOWAnim["grenadeaimrun"] = "ACT_RUN_AIM_SHOTGUN"
NPCAnim.CombineOWAnim["grenadefire"] = "ACT_COMBINE_THROW_GRENADE"

NPCAnim.CombineOWAnim["slamidle"] = "ACT_IDLE"
NPCAnim.CombineOWAnim["slamwalk"] = "ACT_WALK_EASY"
NPCAnim.CombineOWAnim["slamrun"] = "ACT_RUN_RIFLE"
NPCAnim.CombineOWAnim["slamaimidle"] = "ACT_IDLE_MANNEDGUN"
NPCAnim.CombineOWAnim["slamaimcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["slamaimcrouch"] = "ACT_RANGE_AIM_AR2_LOW"
NPCAnim.CombineOWAnim["slamcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["slamcrouch"] = "ACT_COVER_LOW"
NPCAnim.CombineOWAnim["slamaimwalk"] = "ACT_WALK_GRAVCARRY"
NPCAnim.CombineOWAnim["slamaimrun"] = "ACT_RUN_RIFLE"
NPCAnim.CombineOWAnim["slamfire"] = "ACT_SPECIAL_ATTACK2"

NPCAnim.CombineOWAnim["physgunidle"] = "ACT_IDLE"
NPCAnim.CombineOWAnim["physgunwalk"] = "ACT_WALK_RIFLE"
NPCAnim.CombineOWAnim["physgunrun"] = "ACT_RUN_RIFLE"
NPCAnim.CombineOWAnim["physgunaimidle"] = "ACT_IDLE_ANGRY_SHOTGUN"
NPCAnim.CombineOWAnim["physgunaimwalk"] = "ACT_WALK_AIM_SHOTGUN"
NPCAnim.CombineOWAnim["physgunaimrun"] = "ACT_RUN_AIM_SHOTGUN"
NPCAnim.CombineOWAnim["physgunaimcrouchwalk"] = "ACT_WALK_CROUCH_RIFLE"
NPCAnim.CombineOWAnim["physgunaimcrouch"] = "ACT_RANGE_AIM_AR2_LOW"

WeapActivityTranslate = { }

WeapActivityTranslate[ACT_HL2MP_IDLE_PISTOL] = "pistol";
WeapActivityTranslate[ACT_HL2MP_IDLE_SMG1] = "smg";
WeapActivityTranslate[ACT_HL2MP_IDLE_AR2] = "ar2";
WeapActivityTranslate[ACT_HL2MP_IDLE_RPG] = "rpg";
WeapActivityTranslate[ACT_HL2MP_IDLE_GRENADE] = "grenade";
WeapActivityTranslate[ACT_HL2MP_IDLE_SHOTGUN] = "shotgun";
WeapActivityTranslate[ACT_HL2MP_IDLE_PHYSGUN] = "physgun";
WeapActivityTranslate[ACT_HL2MP_IDLE_CROSSBOW] = "crossbow";
WeapActivityTranslate[ACT_HL2MP_IDLE_SLAM] = "slam";
WeapActivityTranslate[ACT_HL2MP_IDLE_MELEE] = "melee";
WeapActivityTranslate[ACT_HL2MP_IDLE] = "";
WeapActivityTranslate["weapon_pistol"] = "pistol";
WeapActivityTranslate["weapon_357"] = "pistol";
WeapActivityTranslate["gmod_tool"] = "pistol";
WeapActivityTranslate["weapon_smg1"] = "smg";
WeapActivityTranslate["weapon_ar2"] = "ar2";
WeapActivityTranslate["weapon_rpg"] = "rpg";
WeapActivityTranslate["weapon_frag"] = "grenade";
WeapActivityTranslate["weapon_slam"] = "slam";
WeapActivityTranslate["weapon_physgun"] = "physgun";
WeapActivityTranslate["weapon_physcannon"] = "physgun";
WeapActivityTranslate["weapon_crossbow"] = "crossbow";
WeapActivityTranslate["weapon_shotgun"] = "shotgun";
WeapActivityTranslate["weapon_crowbar"] = "melee";
WeapActivityTranslate["weapon_stunstick"] = "melee";

local function GetWeaponAct( ply, act )

	local weap = ply:GetActiveWeapon();
	
	if( weap == NULL or not weap:IsValid() ) then
		return "";
	end

	local class = weap:GetClass();
	
	local trans = "";
	local posttrans = "";
	
	if( weap:GetNWBool( "NPCAimed" ) ) then
		posttrans = "aim";	
	else
		
		if( weap:GetTable().NotHolsterAnim ) then
		
			act = weap:GetTable().NotHolsterAnim;
		
		end
	
	end

	if( act ~= -1 ) then
		trans = WeapActivityTranslate[act];
	else
		trans = WeapActivityTranslate[class];
	end
	
	return trans or "" .. posttrans or "";

end

local function FindEnumeration( actname )

	for k, v in pairs ( _G ) do
		if(  k == actname ) then
			return tonumber( v );
		end
	end
	
return -1;

end


local function GetAnimTable( ply )

	local model = string.lower( ply:GetModel() );

	if( table.HasValue( NPCAnim.CitizenMaleModels, model ) ) then return NPCAnim.CitizenMaleAnim; end
	if( table.HasValue( NPCAnim.CitizenFemaleModels, model ) ) then return NPCAnim.CitizenFemaleAnim; end
	if( table.HasValue( NPCAnim.CombineMetroModels, model ) ) then return NPCAnim.CombineMetroAnim; end
	if( table.HasValue( NPCAnim.CombineOWModels, model ) ) then return NPCAnim.CombineOWAnim; end
	
	return NPCAnim.CitizenMaleAnim;

end

local animname = "";
local seqname = animname;
local crouch = "";
local act = nil;
local seq = nil;
local actid = nil;

function NPCAnim.CalcMainActivity( ply, velocity )


	if( not NPC_ANIMS_ENABLED ) then return; end
	
	local weap = ply:GetActiveWeapon();
	local animname = "";
	
	if( weap:IsValid() ) then
		animname = GetWeaponAct( ply, ply:Weapon_TranslateActivity( ACT_HL2MP_IDLE ) or -1 );
	end
	local seqname = animname;
	local crouch = "";

	if( ply:OnGround() and ply:KeyDown( IN_DUCK ) ) then
		crouch = "crouch";
	end
	
	if( velocity:Length2D() >= 120 and ply:KeyDown( IN_SPEED )) then

		seqname = seqname .. crouch .. "run";
	
	elseif( velocity:Length2D() >= 1 ) then
	
		seqname = seqname .. crouch .. "walk";
	
	else
		
		if( crouch == "crouch" ) then
			seqname = seqname .. crouch;
		else
			seqname = seqname .. crouch .. "idle";
		end
		
	end

	local AnimTable = GetAnimTable( ply );
	
	if( ( weap:GetActivity() == ACT_VM_PRIMARYATTACK or weap:GetActivity() == ACT_VM_RELOAD ) and weap:IsValid() ) then
		local act = nil;
	
		if( weap:GetActivity() == ACT_VM_RELOAD ) then

			local actname = string.gsub( seqname, "aim", "" ) .. "reload";
			actname = string.gsub( actname, "idle", "" );
		
			local act = FindEnumeration( AnimTable[actname] );
			
			if( act == nil ) then
				return;
			end

			ply.CalcIdeal = act
			ply.CalcSeqOverride = -1
			ply:RestartGesture( act );
		
			return act, -1;
			
		else
		
			if( string.find( seqname, "melee" ) or string.find( seqname, "grenade" ) or string.find( seqname, "slam" ) ) then
			
				local actname = string.gsub( seqname, "aim", "" ) .. "fire";
				actname = string.gsub( actname, "idle", "" );
			
				local act = FindEnumeration( AnimTable[actname] );
				
				if( act == nil ) then
					return;
				end

				ply.CalcIdeal = act

				ply:RestartGesture( act );
				ply:Weapon_SetActivity( act, 0 );
				
				return act, -1;
				
			end
		
			return;
			
		end
	
	end

	if ( ( not ply:OnGround() or ply:WaterLevel() > 4 ) and 
		   not ply:InVehicle() ) then
		seqname = "glide";
	end
 

	local actid = FindEnumeration( AnimTable[seqname] )
	local seq = nil;

	if( actid == nil or actid == -1 ) then
		seq = ply:GetSequence();
	else
		seq = ply:SelectWeightedSequence( actid );
	end

	if ( ply:GetSequence() == seq ) then return seq, -1; end

	ply:SetPlaybackRate( 1 );
	ply:ResetSequence( seq );
	ply:SetCycle( 1 );
	
	return seq, -1;

end
	
--hook.Add( "CalcMainActivity", "NPCAnim.CalcMainActivity", NPCAnim.CalcMainActivity );
