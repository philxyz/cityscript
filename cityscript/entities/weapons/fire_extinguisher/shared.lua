if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "shotgun"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Fire Extinguisher"			
	SWEP.Author				= "Feihc"

	SWEP.Slot				= 1
	SWEP.SlotPos			= 8
	SWEP.ViewModelFOV		= 70
	SWEP.IconLetter			= "x"

end
-----------------------Main functions----------------------------
 
-- function SWEP:Reload() --To do when reloading
-- end 
 
function SWEP:Think() -- Called every frame

end

function SWEP:Initialize()
util.PrecacheSound("ambient/wind/wind_hit2.wav")
end

function smoke(ent, speed, rate, size1, size2, length)
if SERVER then
local smoke = ents.Create("env_steam")
if ent:IsPlayer() then
	smoke:SetPos(ent:GetShootPos())
	smoke:SetKeyValue("Angles", tostring(ent:EyeAngles()))
else
	smoke:SetPos(ent:GetPos())
	smoke:SetKeyValue("Angles", tostring(Angle(0,0,0)))
end

smoke:SetKeyValue("InitialState", "1")
smoke:SetKeyValue("Speed", speed)
smoke:SetKeyValue("Rate", rate)
smoke:SetKeyValue("StartSize", size1)
smoke:SetKeyValue("EndSize", size2)
smoke:SetKeyValue("JetLength", length)
smoke:SetKeyValue("SpreadSpeed", "2")
smoke:SetKeyValue("SpawnFlags", "1")
smoke:Spawn()
smoke:Activate()
smoke:Fire("TurnOn", "", 0)
smoke:Fire("TurnOff","", .25)
smoke:Fire("kill", "", 1)
end
end
 
function SWEP:PrimaryAttack()
	if SERVER then
		smoke(self.Owner, "500", "50", "5", "20", "500")
		local tr = self.Owner:GetEyeTrace()

		if tr.Entity and IsValid(tr.Entity) and tr.Entity:GetPos():Distance(self.Owner:GetPos()) <= 200 then
			if tr.Entity:IsOnFire() then
				if math.random(0, 7) == 5 then
					tr.Entity:Extinguish()
				end
			end
		end

		if tr.Entity:IsNPC() or tr.Entity:IsPlayer() then
			local b = ents.Create( "point_hurt" )
			b:SetKeyValue("targetname", "fier" ) --Yes, I spelled it like that on purpose.
			b:SetKeyValue("DamageRadius", "20" )
			b:SetKeyValue("Damage", "5" )
			b:SetKeyValue("DamageDelay", "1" )
			b:SetKeyValue("DamageType", "16" )
			b:SetPos( tr.Entity:GetPos())
			b:Spawn()
			b:Fire("turnon", "", 0)
			b:Fire("kill", "", 5)
		end

		local Pos1 = tr.HitPos + tr.HitNormal
		local Pos2 = tr.HitPos - tr.HitNormal
		--util.Decal( "hl1glassbreak", Pos1, Pos2 )
	end

	self.Weapon:EmitSound("ambient/wind/wind_hit2.wav")
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Weapon:SetNextPrimaryFire(CurTime() + .2)
end
 
function SWEP:SecondaryAttack()

end
-------------------------------------------------------------------

------------General Swep Info---------------
SWEP.Author   = "Feihc"
SWEP.Contact        = ""
SWEP.Purpose        = ""
SWEP.Instructions   = "Put out ze fire!"
SWEP.Spawnable      = true
SWEP.AdminSpawnable  = true
-----------------------------------------------

------------Models---------------------------
SWEP.ViewModel      = "models/weapons/v_fire_extinguisher.mdl"
SWEP.WorldModel   = "models/weapons/w_fire_extinguisher.mdl"
-----------------------------------------------

-------------Primary Fire Attributes----------------------------------------
SWEP.Primary.Delay			= 0.9 	--In seconds
SWEP.Primary.Recoil			= 0		--Gun Kick
SWEP.Primary.Damage			= 15	--Damage per Bullet
SWEP.Primary.NumShots		= 1		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= 10	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= 10	--Number of shots in next clip
SWEP.Primary.Automatic   	= true	--Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo         	= "pistol"	--Ammo Type
-------------End Primary Fire Attributes------------------------------------
 
-------------Secondary Fire Attributes-------------------------------------
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"
-------------End Secondary Fire Attributes--------------------------------
