-- philxyz 2015

SWEP.AdminOnly = true
SWEP.HoldType = "knife"

SWEP.Primary.Ammo = "Extinguisher_Powder"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 350
SWEP.Primary.DefaultClip = 350

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0

SWEP.Spawnable = true -- TODO: make false for RP games after testing.
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/v_fire_extinguisher_powder.mdl"
SWEP.ViewModelFOV = 54
SWEP.WorldModel = "models/fire_extinguisher_powder/w_fire_extinguisher_powder.mdl"

util.PrecacheSound("spray_start.wav")
util.PrecacheSound("spray_hold.wav")
util.PrecacheSound("spray_end.wav")

if CLIENT then
        SWEP.Author = "philxyz"
        SWEP.BobScale = 1.15
	SWEP.BounceWeaponIcon = false
        SWEP.Category = "RP"
        SWEP.DrawAmmo = true
        SWEP.DrawCrosshair = false
        SWEP.Instructions = "Aim at base of fire and squeeze handle"
        SWEP.PrintName = "Fire Extinguisher"
        SWEP.Purpose = "Suitable for all types of fires"
        SWEP.Slot = 0
        SWEP.SlotPos = 10
        SWEP.WepSelectIcon =
		surface.GetTextureID("weapons/weapon_fire_extinguisher_powder")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetNextPrimaryTime(0)
	self:SetAttacking(false)
	self.NextHoldSoundTime = 0
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextPrimaryTime")
	self:NetworkVar("Bool", 0, "Attacking")
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryTime(CurTime() + self.Owner:GetViewModel():SequenceDuration())
end

function SWEP:Think()
	if self:GetAttacking() then
		if CurTime() >= self:GetNextPrimaryTime() and self.Owner:KeyPressed(IN_ATTACK) then
			self:SendWeaponAnim(ACT_VM_IDLE_1)
		elseif self.Owner:KeyReleased(IN_ATTACK) then
			self:SetAttacking(false)
			self:SendWeaponAnim(ACT_VM_RELEASE)
			sound.Play("spray_end.wav", self:GetPos(), 75, 100, 1.0)
		end

		if CurTime() >= self.NextHoldSoundTime then
			self.NextHoldSoundTime = CurTime() + 0.367
			sound.Play("spray_hold.wav", self:GetPos(), 75, 100, 1.0)
		end

		self:SprayFoam()
	end
end

function SWEP:SprayFoam()
	if self.SprayTime == nil or CurTime() >= self.SprayTime then
		local edata = EffectData()
		local rhand = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		local wHandPos, wHandAngle = self.Owner:GetBonePosition(rhand)
		local pav = self.Owner:GetAimVector()
		local up = pav:Angle():Up():Angle()
		up:RotateAroundAxis(pav:Angle():Up(), 90)
		local wOffset, wAngle = LocalToWorld(Vector(9.5, -4.8, -2), up, wHandPos, wHandAngle)
		edata:SetOrigin(wOffset)
		edata:SetAngles(wAngle)
		edata:SetNormal(self.Owner:GetAimVector())
		edata:SetEntity(self.Owner)
		util.Effect("fire_extinguisher_powder", edata)
		local line = util.TraceLine({
			start = wOffset,
			endpos = wOffset + self.Owner:GetAimVector() * 350,
		})
		local pos = (IsValid(line.Entity) and line.Entity:GetPos()) or line.HitPos
		local targets = ents.FindInSphere(pos, 30)
		math.randomseed(CurTime())
		for _, t in ipairs(targets) do
			if t:IsOnFire() and math.random(1, 10) == 1 then
				if SERVER then
					t:Extinguish()
				end
				-- puff of smoke
				local ed2 = EffectData()
				ed2:SetOrigin(t:GetPos())
				ed2:SetAngles(t:GetAngles())
				ed2:SetEntity(t)
				ed2:SetNormal(Vector(0, 0, 1))
				util.Effect("hitsmoke", ed2)
			end
		end

		self.SprayTime = CurTime() + 0.08
	else
		return
	end
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	-- Can't fire again yet

	if self:GetAttacking() then return end

	if game.SinglePlayer() then
		self:CallOnClient("PrimaryAttack")
	end

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:SetNextPrimaryTime(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self:SetAttacking(true)
	self.NextHoldSoundTime = CurTime() + 0.5122
	sound.Play("spray_start.wav", self:GetPos(), 75, 100, 1.0)
	self:SprayFoam()
end
