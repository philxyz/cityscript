-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_hud.lua 
-- General HUD stuff.
-------------------------------

LocalPlayer().MyModel = "" -- Has to be blank for the initial value, so it will create a spawnicon in the first place.

surface.CreateFont( "PlInfoFont", {
	font = "ChatFont",
	size = 22,
	weight = 100,
	antialias = true
})

local function DrawTime( )

	draw.DrawText( GetGlobalString( "time" ), "PlInfoFont", 10, 10, Color( 255,255,255,255 ), 0 );
	
end

function DrawTargetInfo( )
	
	local tr = LocalPlayer( ):GetEyeTrace( )
	
	if( !tr.HitNonWorld ) then return; end
	
	if( (not tr.Entity:IsVehicle() and not tr.Entity:IsPlayer() and not tr.Entity:IsNPC()) and tr.Entity:GetPos( ):Distance( LocalPlayer( ):GetPos( ) ) < 100 ) then
	
		local screenpos = tr.Entity:GetPos( ):ToScreen( )
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x + 2, screenpos.y + 2, Color( 0, 0, 0, 255 ), 1 );	
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 );
		if tr.Entity:GetNWString("Title") ~= "" and not CAKE.IsDoor(tr.Entity) then
			draw.DrawText( tr.Entity:GetNWString( "Title" ), "ChatFont", screenpos.x + 2, screenpos.y + 22, Color( 0, 0, 0, 255 ), 1 );	
			draw.DrawText( tr.Entity:GetNWString( "Title" ), "ChatFont", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1 );
		else
			draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x + 2, screenpos.y + 22, Color( 0, 0, 0, 255 ), 1 );	
			draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1 );
		end
		if tr.Entity:GetNWBool("shipment") then
			draw.DrawText( tostring(tr.Entity.dt.count) .. " units\n" .. tostring(math.floor(((tr.Entity.dt.count * tr.Entity.dt.itemWt)*100)+0.5)/100) .. "kg NET", "ChatFont", screenpos.x + 2, screenpos.y + 42, Color( 0, 0, 0, 255 ), 1 );	
			draw.DrawText( tostring(tr.Entity.dt.count) .. " units\n" .. tostring(math.floor(((tr.Entity.dt.count * tr.Entity.dt.itemWt)*100)+0.5)/100) .. "kg NET", "ChatFont", screenpos.x, screenpos.y + 40, Color( 255, 255, 255, 255 ), 1 );
		end
		if tr.Entity:GetNWBool("ATM") then
			draw.DrawText( TEXT.ATMText .. "\n\n" .. TEXT.ATMBalanceCommand .. "\n" .. TEXT.ATMWithdrawCommand .. " <" .. TEXT.Amount .. ">" .. "\n" .. TEXT.ATMDepositCommand .. " <" .. TEXT.Amount .. ">\n" .. TEXT.ATMTransferCommand .. " <" .. TEXT.Amount .. ">\\[" .. TEXT.NameOrUserID .. "]", "ChatFont", screenpos.x + 2, screenpos.y + 22, Color( 0, 255, 0, 255 ), 1 );	
			draw.DrawText( TEXT.ATMText .. "\n\n" .. TEXT.ATMBalanceCommand .. "\n" .. TEXT.ATMWithdrawCommand .. " <" .. TEXT.Amount .. ">" .. "\n" .. TEXT.ATMDepositCommand .. " <" .. TEXT.Amount .. ">\n" .. TEXT.ATMTransferCommand .. " <" .. TEXT.Amount .. ">\\[" .. TEXT.NameOrUserID .. "]", "ChatFont", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1 );
		end

	end
end
		
function GM:HUDShouldDraw( name )

	if not LocalPlayer() then return false end

	if( LocalPlayer():GetNWInt( "charactercreate" ) == 1 or LocalPlayer():GetNWInt( "charactercreate" ) == nil ) then return false; end
	
	local nodraw = 
	{ 
	
		"CHudHealth",
		"CHudAmmo",
		"CHudSecondaryAmmo",
		"CHudBattery",
	
	 }
	
	for k, v in pairs( nodraw ) do
	
		if( name == v ) then return false; end
	
	end
	
	return true;

end

function DrawInfoPanel()
	local hx = 9
	local hy = ScrH() - 25
	local hw = 190
	local hh = 10

	-- Tokens Display
	draw.DrawText(LocalPlayer():GetNWString("money") .. " " .. TEXT.Tokens, "TargetID", hx + 1, hy - 34, Color(0, 0, 0, 200), 0)
	draw.DrawText(LocalPlayer():GetNWString("money") .. " " .. TEXT.Tokens, "TargetID", hx, hy - 35, Color(255, 255, 255, 200), 0)

	-- Health Bar Background
	draw.RoundedBox(0, hx - 1, hy - 1, hw + 2, hh + 2, Color(0, 0, 0, 200))

	-- Health Bar Foreground
	if LocalPlayer():Health() > 0 then
		draw.RoundedBox(0, hx, hy, math.Clamp(hw * (LocalPlayer():Health() / 100), 0, 190), hh, Color(255, 255, 255, 200))
	end
end

function DrawDeathMeter( )

	local timeleft = LocalPlayer( ):GetDTInt(2);
	local w = ( timeleft / 120 ) * 198
	
	draw.RoundedBox( 8, ScrW( ) / 2 - 100, 5, 200, 50, Color( GUIcolor_trans ) );
	draw.RoundedBox( 8, ScrW( ) / 2 - 98, 7, w, 46, Color( 255, 0, 0, 255 ) );
	
	draw.DrawText( TEXT.TimeLeft .. " " .. TEXT.HowToRespawn, "ChatFont", ScrW( ) / 2 - 93, 25 - 5, Color( 255,255,255,255 ), 0 );
	
end

function DrawPlayerInfo( )

	for k, v in pairs( player.GetAll( ) ) do	
	
		if( v != LocalPlayer( ) ) then
		
			if( v:Alive( ) ) then
			
				local alpha = 0
				local position = v:GetPos( )
				local position = Vector( position.x, position.y, position.z + 75 )
				local screenpos = position:ToScreen( )
				local dist = position:Distance( LocalPlayer( ):GetPos( ) )
				local dist = dist / 2
				local dist = math.floor( dist )
				
				if( dist > 100 ) then
				
					alpha = 255 - ( dist - 100 )
					
				else
				
					alpha = 255
					
				end
				
				if( alpha > 255 ) then
				
					alpha = 255
					
				elseif( alpha < 0 ) then
				
					alpha = 0
					
				end
				
				draw.DrawText( v:Nick( ), "DefaultSmall", screenpos.x, screenpos.y, Color( 255, 255, 255, alpha ), 1 )
				draw.DrawText( team.GetName( v:Team( ) ), "DefaultSmall", screenpos.x, screenpos.y + 10, Color( 255, 255, 255, alpha ), 1 )
				draw.DrawText( v:GetNWString( "title" ), "DefaultSmall", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, alpha ), 1 )
				
				if( v:GetDTInt(3) == 1 ) then
				
					draw.DrawText( TEXT.Typing, "ChatFont", screenpos.x, screenpos.y - 50, Color( 255, 255, 255, alpha ), 1 )
					
				end
				
			end
			
		end
		
	end
	
end

function GM:HUDPaint( )

	local tr = LocalPlayer():GetEyeTrace()
	local superAdmin = LocalPlayer():IsSuperAdmin()

	if IsValid(tr.Entity) and CAKE.IsDoor(tr.Entity) and tr.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 200 then
		local pos = tr.HitPos:ToScreen()
		local ent = tr.Entity
		local st

		if ent:GetNWBool("nonRentable") then
			st = ent:GetNWString("dTitle") -- show disabled door title
		else
			st = ent:GetNWString("title") or "" --  show enabled door title
		end

		draw.DrawText(st, "TargetID", pos.x + 1, pos.y + 1, Color(0, 0, 0, 200), 1)
		draw.DrawText(st, "TargetID", pos.x, pos.y, Color(255, 255, 255, 200), 1)
	end
	
	if( LocalPlayer():GetDTInt(1) == 1 ) then
		DrawDeathMeter()
	end
	
	-- DrawPlayerInfo( );
	DrawTime( );
	DrawPlayerInfo( );
	DrawTargetInfo( );
	DrawInfoPanel( );
end
