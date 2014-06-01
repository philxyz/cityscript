
// Variables that are used on both client and server

SWEP.Author		= "Slob187"
SWEP.Contact		= "slob187.pb@gmail.com"
SWEP.Purpose		= TEXT.CallForHelp
SWEP.Instructions	= TEXT.SignalFlareInstructions

SWEP.ViewModel		= "models/weapons/v_Pistol.mdl"
SWEP.WorldModel		= "models/weapons/W_pistol.mdl"

SWEP.Spawnable      = false
SWEP.AdminSpawnable = false

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.NextFire = 0
SWEP.NextZoom = 0



/*---------------------------------------------------------
	Initialize
---------------------------------------------------------*/
function SWEP:Initialize()

    if (!SERVER) then return end
	
	self.Zoomed = false
	self:SetWeaponHoldType("pistol")
				
end
	
/*---------------------------------------------------------
	Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	
end	
	

function SWEP:Throw( range )

	if (!SERVER) then return end
	
	local flare = ents.Create ( "prop_physics" )
	flare:SetModel("models/props_junk/PopCan01a.mdl")
	flare:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 16 ) )
	flare:SetAngles( self.Owner:EyeAngles() ) 
	flare:SetOwner( self.Owner )
	flare:SetMaterial( "models/shiny" )
	flare:SetColor(Color(255, 0, 0, 255))
	util.SpriteTrail( flare, 0, Color( 100, 50, 50 ), true, 30, 5, 10, 0, "trails/smoke.vmt" )		
	flare:Spawn()
	flare:GetPhysicsObject():ApplyForceCenter( self.Owner:GetAimVector():GetNormalized() * range )
	
	timer.Simple( 5, function() 
	
		if flare:IsValid() then
		
			flare:Remove() 
			
		end 
		
	end )

		
end

	
/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
	
end


/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	self.Weapon:EmitSound("weapons/flaregun/fire.wav")	
	
	if (SERVER) then
	
		self:Throw( 150000000 )
		self.Owner:ViewPunch( Angle( math.random( -15, -5 ), 0, 0 ) ) //view punch
		local fGun = self.Weapon
		self.Owner:DropWeapon( fGun )
		fGun:Remove()
		
	end	

end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if (!SERVER) then return end
	
	if CurTime() < self.NextZoom then return end
	
	if !self.Zoomed then
		self.Owner:SetFOV( 30, 0 )
		self.Zoomed = true
	else
		self.Owner:SetFOV( 80, 0 )
		self.Zoomed = false
	end	
	
	self.NextZoom = CurTime() + .5	
	
end

/*---------------------------------------------------------
	Think does nothing 
---------------------------------------------------------*/
function SWEP:Think()

end

