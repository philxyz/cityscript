function EFFECT:Init(data)
	self.data = data
	self.particles = 6
end

function EFFECT:Think()
	return false
end

function EFFECT.CollideCallback(particle, hitpos, hitnormal)
	particle:SetPos(hitpos + (hitnormal * 0.15))
	particle:SetVelocity(Vector(0, 0, 0))
	particle:SetAngleVelocity(Angle(0, 0, 0))
	local ang = hitnormal:Angle()
	ang:RotateAroundAxis(hitnormal, particle:GetAngles().y)
	particle:SetAngles(ang)
	particle:SetGravity(Vector(0, 0, 0))
	particle:SetAngles((hitnormal * 0.05):Angle())
	particle:SetDieTime(8)
	particle:SetStartSize(23)
	particle:SetLifeTime(0)
	particle:SetStartAlpha(140)
	particle:SetEndAlpha(0)
	particle:SetEndSize(0)
end

function EFFECT:Render()
	local vOffset = self.data:GetOrigin()
	local vAngle = self.data:GetAngles()
	local forwards = self.data:GetNormal()

	local emitter = ParticleEmitter(vOffset, true)

	if not emitter then return end

	for i=1, self.particles do
		math.randomseed(CurTime()+i*23)
		local rn = math.random(1, 3)
		local eff = "decals/extinguish1"
		if rn == 2 then
			eff = "decals/extinguish2"
		elseif rn == 3 then
			eff = "fire_extinguisher_powder/powderspray"
		end

		local p = emitter:Add(eff, vOffset)
		if p then
			p:SetAirResistance(0.5)	
			if i % 2 ~= 0 then
				p:SetAngles(forwards:Angle())
			elseif i % 3 == 0 then
				local a = forwards:Angle()
				a:RotateAroundAxis(forwards, 90)
				p:SetAngles(a)
			else
				p:SetAngles((forwards * -1):Angle())
			end
			p:SetColor(255, 255, 255)
			p:SetCollideCallback(self.CollideCallback)
			p:SetCollide(true)

			p:SetStartLength(20)
			p:SetEndLength(20)

			p:SetStartSize(3)
			p:SetEndSize(18)

			p:SetGravity(Vector(0, 0, -9.81))

			p:SetLifeTime(0)
			p:SetDieTime(0.6)

			math.randomseed(CurTime())

			p:SetRoll(math.Rand(0, 2*math.pi))

			p:SetVelocity(LocalPlayer():GetAimVector() * Vector(math.Rand(0.9, 1.1), math.Rand(0.9, 1.1), math.Rand(0.9, 1.1)) * 440)

		end
	end
	emitter:Finish()
end
