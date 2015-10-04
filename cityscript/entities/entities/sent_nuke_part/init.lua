AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

local GoBoom = function(ent, fragments)
	for k, v in pairs(fragments) do
                v:Remove()
        end

	local nuke = ents.Create("sent_nuke")
	nuke:SetPos( ent:GetPos() )
	nuke:SetOwner(ent)
	nuke:Spawn()
	nuke:Activate()
end

function ENT:Initialize()
	self.Entity:SetModel( "models/Items/battery.mdl" )

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )	
	self.Entity:SetSolid( SOLID_VPHYSICS )

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetNWString("Owner", "Shared")
end

function ENT:Pickup(ply)
	self.dt.ownIndex = ply:EntIndex()
	CAKE.Response(ply, "Picked up some fissile material!")
	self:Remove();
end

function ENT:UseItem(ply)
	self.dt.ownIndex = ply:EntIndex()
	CAKE.Response(ply, "You prodded the nuclear material... now wash your hands!")
end

function ENT:Think()
	if self.LastThink and CurTime() > self.LastThink + 5 then return end

	local fragments = {}
	table.insert(fragments, self)

	-- Every 5 seconds, look for 9 other nearby fissile material
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
		if v:GetClass() == "sent_nuke_part" then
			table.insert(fragments, v)
		end
		if #fragments >= 10 then break end
	end

	if #fragments >= 10 then
		GoBoom(self, fragments)
	end

	if not self.LastThink then self.LastThink = CurTime() end
end
