-- Unobtrusive prop protection by philxyz
-- Server-side code
UPP = {}

function UPP.PlayerSpawnedProp(ply, model, ent)
        ent:SetNWString("creator", ply:Name())
        ent:SetNWEntity("c_ent", ply)
end
hook.Add("PlayerSpawnedProp", "SetPropCreatorInfo", UPP.PlayerSpawnedProp);

function UPP.PlayerSpawnedVehicle(ply, ent)
        ent:SetNWString("creator", ply:Name())
        ent:SetNWEntity("c_ent", ply)
end
hook.Add("PlayerSpawnedVehicle", "SetVehicleCreatorInfo", UPP.PlayerSpawnedVehicle);
