-- Unobtrusive prop protection by philxyz
-- Client-side code

UPP = {}

function UPP.DrawUI()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return
	end

	local tr = util.TraceLine(util.GetPlayerTrace(ply))

	if tr.HitNonWorld then
		if IsValid(tr.Entity) and not tr.Entity:IsPlayer() and not ply:InVehicle() and tr.Entity:GetNWString("creator") ~= "" then
			local creator = "Creator: " .. tr.Entity:GetNWString("creator")
			surface.SetDrawColor(10, 10, 10, 255)
			surface.SetFont("ScoreboardText")
			local wid, hei = surface.GetTextSize(creator)
			surface.DrawRect(ScrW() - wid - 12, 162, wid + 12, hei+6)
			draw.DrawText(creator, "ScoreboardText", ScrW() - 2, 165, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
		end
	end
end
