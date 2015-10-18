include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local ang = self:GetAngles()
	local pos = self:GetPos()

	local text = tostring(self:Getamount())

	ang:RotateAroundAxis(ang:Up(), 90)

	cam.Start3D2D(pos + ang:Up() * 0.1, ang, 0.1)
		draw.SimpleText(text, "ChatFont", -32, -18, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	cam.End3D2D()

	ang:RotateAroundAxis(ang:Forward(), 180)

	cam.Start3D2D(pos + ang:Up() * 0.1, ang, 0.1)
		draw.SimpleText(text, "ChatFont", 14, -1, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
	cam.End3D2D()
end
