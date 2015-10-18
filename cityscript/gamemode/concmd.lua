-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- concmd.lua
-- Contains the concommands and changes the way other concommands work.
-------------------------------

function GM:PlayerSpawnSWEP( ply, class )

	CAKE.CallTeamHook( "PlayerSpawnSWEP", ply, class ); -- Perhaps allow certain flags to use sweps, eh?
	
	if( ply:IsSuperAdmin( ) ) then return true; end
	return false;
	
end

function GM:PlayerGiveSWEP( ply )

	CAKE.CallTeamHook( "PlayerGiveSWEP", ply, class ); -- Perhaps allow certain flags to use sweps, eh?

	if( ply:IsSuperAdmin( ) ) then return true; end
	return false; 
	
end

function math.IsFinite(num)
	return not (num ~= num and num ~= math.huge and num ~= -math.huge)
end

-- This is the F1 menu
function GM:ShowHelp( ply )
	local PlyCharTable = {}
	local steam = CAKE.FormatSteamID( ply:SteamID() )
	if steam and CAKE.PlayerData[ steam ] then
		PlyCharTable = CAKE.PlayerData[ steam ]["characters"]
	end

	for k, v in pairs( PlyCharTable ) do
		
		umsg.Start( "ReceiveChar", ply );
			umsg.Long( k );
			umsg.String( v[ "name" ] );
			umsg.String( v[ "model" ] );
		umsg.End( );
		
	end

	umsg.Start( "playermenu", ply );
	umsg.End( )
	
end

-- NO SENT FOR YOU.
function GM:PlayerSpawnSENT( ply, class )

	if ply:GetTable().Arrested then return false end

	CAKE.CallTeamHook( "PlayerSpawnSWEP", ply, class ); -- Perhaps allow certain flags to use sents, eh?
	
	if( ply:IsSuperAdmin( ) ) then return true; end
	return false;
end

function GM:PlayerSpawnEffect(ply, model)
	return self.BaseClass:PlayerSpawnEffect(ply, model) and not ply:GetTable().Arrested
end

function GM:PlayerSpawnVehicle(ply, model)
	return self.BaseClass:PlayerSpawnVehicle(ply, model) and not ply:GetTable().Arrested
end

function GM:PlayerSpawnNPC(ply, model)
	return self.BaseClass:PlayerSpawnNPC(ply, model) and not ply:GetTable().Arrested
end

function GM:PlayerSpawnRagdoll(ply, model)
	return self.BaseClass:PlayerSpawnRagdoll(ply, model) and not ply:GetTable().Arrested
end

function GM:PlayerSpawnedProp(ply, model, ent)
	self.BaseClass:PlayerSpawnedProp(ply, model, ent)
	ent.SID = ply.SID
end

function GM:PlayerSpawnedSWEP(ply, model, ent)
	self.BaseClass:PlayerSpawnedSWEP(ply, model, ent)
	ent.SID = ply.SID
end

function GM:PlayerSpawnedRagdoll(ply, model, ent)
	self.BaseClass:PlayerSpawnedRagdoll(ply, model, ent)
	ent.SID = ply.SID
end


-- Disallows suicide
function GM:CanPlayerSuicide( ply )

	if( ply:GetTable().Arrested or CAKE.ConVars[ "SuicideEnabled" ] != "1" ) then
	
		ply:ChatPrint( TEXT.SuicideIsDisabled )
		return false
		
	end
	
	return true;
	
end

-- Change IC Name
function ccChangeName( ply, cmd, args )

	local name = args[ 1 ];
	CAKE.SetCharField(ply, "name", name );
	ply:SetNWString("name", name);
	
end
concommand.Add( "rp_changename", ccChangeName );

-- Allows a player to skip the respawn timer.
function ccAcceptDeath( ply, cmd, args )

	ply.deathtime = 120;
	
end
concommand.Add( "rp_acceptdeath", ccAcceptDeath );

function ccFlag( ply, cmd, args )
	
	local FlagTo = "";
	
	for k, v in pairs( CAKE.Teams ) do
	
		if( v[ "flag_key" ] == args[ 1 ] ) then
		
			FlagTo = v;
			FlagTo.n = k;
			break;
			
		end
		
	end

	local function CheckLimit(teamName, convar)
		local count = 0
		local ps = player.GetAll()
		for k, v in pairs(ps) do
			if team.GetName(v:Team()) == teamName then
				count = count + 1
			end
		end
		-- If someone is already this team
		if count > 0 then
			-- If adding another person would go over the limit
			if (((count + 1) / #ps) * 100) > convar then
				CAKE.Response(ply, TEXT.MaxReached)
				return true;
			end
		end
		return false;
	end
	
	if FlagTo.name == TEXT.CityMayor or
		FlagTo.name == TEXT.CityPolice or
		FlagTo.name == TEXT.BloodBrothersGangLeader or
		FlagTo.name == TEXT.LaFamigliaVontoriniGangLeader or
		FlagTo.name == TEXT.HellsAngelsGangLeader or
		FlagTo.name == TEXT.SkinHeadsGangLeader or
		FlagTo.name == TEXT.TheLegionGangLeader or
		FlagTo.name == TEXT.TheWIGangLeader then
		-- Max is 1
		for k, v in pairs(player.GetAll()) do
			if team.GetName(v:Team()) == FlagTo.name then
				CAKE.Response(ply, TEXT.MaxIsOne)
				return;
			end
		end
	elseif FlagTo.name == TEXT.CityPolice then
		if CheckLimit(FlagTo.name, CAKE.ConVars[ "PolicePcnt" ]) then return; end
	elseif FlagTo.name == TEXT.GroceryStoreOwner then
		if CheckLimit(FlagTo.name, CAKE.ConVars[ "GroceryStoreOwnerPcnt" ]) then return; end
	elseif FlagTo.name == TEXT.GunStoreOwner then
		if CheckLimit(FlagTo.name, CAKE.ConVars[ "GunStoreOwnerPcnt" ]) then return; end
	elseif FlagTo.name == TEXT.CarDealershipOwner then
		if CheckLimit(FlagTo.name, CAKE.ConVars[ "CarDealershipOwnerPcnt" ]) then return; end
	elseif FlagTo.name == TEXT.BlackMarketDealer then
		if CheckLimit(FlagTo.name, CAKE.ConVars[ "BlackMarketDealerPcnt" ]) then return; end
	elseif FlagTo.name == TEXT.MedicalSpecialist then
		if CheckLimit(FlagTo.name, CAKE.ConVars[ "MedicalSpecialistPcnt" ]) then return; end
	elseif FlagTo.name == TEXT.BloodBrothersGangMember then
		if CheckLimit(FlagTo.name, CAKE.ConVars[ "BloodBrothersGangPcnt" ]) then return; end
	elseif FlagTo.name == TEXT.LaFamigliaVontoriniGangMember then
		if CheckLimit(FlagTo.name, CAKE.ConVars[ "VontoriniGangPcnt" ]) then return; end
	elseif FlagTo.name == TEXT.HellsAngelsGangMember then
		if CheckLimit(FlagTo.name, CAKE.ConVars[ "HellsAngelsGangPcnt" ]) then return; end
	elseif FlagTo.name == TEXT.SkinHeadsGangMember then
		if CheckLimit(FlagTo.name, CAKE.ConVars[ "SkinHeadsGangPcnt" ]) then return; end
	elseif FlagTo.name == TEXT.TheLegionGangMember then
		if CheckLimit(FlagTo.name, CAKE.ConVars[ "LegionGangPcnt" ]) then return; end
	elseif FlagTo.name == TEXT.TheWIGangMember then
		if CheckLimit(FlagTo.name, CAKE.ConVars[ "WIGangPcnt" ]) then return; end
	elseif FlagTo.name == TEXT.Citizen then
		-- It's always OK.
	else
		CAKE.Response( ply, TEXT.IncorrectFlag );
		return;
	end

	if ply:GetTable().Arrested then
		if not ply:Alive() then
			CAKE.Response(ply, TEXT.NoJobChangeWhileDeadInJail);
			return;
		else
			CAKE.Response(ply, TEXT.NoJobChangeWhileAliveInJail);
			return;
		end
	end

	if( ( CAKE.GetCharField(ply, "flags" ) != nil and table.HasValue( CAKE.GetCharField( ply, "flags" ), args[ 1 ] ) ) or FlagTo[ "public" ] ) then
		
		local inv = CAKE.GetCharField( ply, "inventory" );
		if (#inv > 0) then
			for k, v in pairs( inv ) do
				ply:TakeItem( v );
			end
			CAKE.Response(ply, TEXT.NewRoleBackpackEmptied);
		end
		ply:SetTeam( FlagTo.n );
		ply:RefreshBusiness();
		ply.FlagChangeHealth = ply:Health();
		ply:Spawn();
		return;
				
	else
	
		CAKE.Response( ply, TEXT.YouNotHaveThisFlag );
		
	end		
	
end
concommand.Add( "rp_flag", ccFlag );

function ccLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( CAKE.IsDoor( entity ) ) then
	
		if( entity.owner == ply ) then
		
			entity:Fire( "lock", "", 0 );
			
		else
		
			CAKE.Response( ply, TEXT.NotYourDoor );
			
		end
		
	end

end
concommand.Add( "rp_lockdoor", ccLockDoor );

function ccUnLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( CAKE.IsDoor( entity ) ) then
	
		if( entity.owner == ply ) then
		
			entity:Fire( "unlock", "", 0 );
			
		else
		
			CAKE.Response( ply, TEXT.NotYourDoor );
			
		end
		
	end

end
concommand.Add( "rp_unlockdoor", ccUnLockDoor );

function ccOpenDoor( ply, cmd, args )

	local entity = ply:GetEyeTrace( ).Entity;
	
	if( entity != nil and entity:IsValid( ) and CAKE.IsDoor( entity ) and ply:GetPos( ):Distance( entity:GetPos( ) ) < 200 ) then
	
		local pos = entity:GetPos( );
		
		for k, v in pairs( CAKE.Doors ) do
		
			if( tonumber( v[ "x" ] ) == math.ceil( tonumber( pos.x ) ) and tonumber( v[ "y" ] ) == math.ceil( tonumber( pos.y ) ) and tonumber( v[ "z" ] ) == math.ceil( tonumber( pos.z ) ) ) then
			
				for k2, v2 in pairs( CAKE.Teams[ ply:Team( ) ][ "door_groups" ] ) do
				
					if( tonumber( v[ "group" ] ) == tonumber( v2 ) ) then
					
						entity:Fire( "toggle", "", 0 );
						
					end
					
				end
				
			end
			
		end
		
	end
	
end
concommand.Add( "rp_opendoor", ccOpenDoor );

function ccPurchaseDoor( ply, cmd, args )
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) );

	if door:GetNWBool("nonRentable") then
		CAKE.Response(ply, TEXT.DoorNotRentable)
		return
	end
	
	local pos = door:GetPos( );
	
	for k, v in pairs( CAKE.Doors ) do
		
		if( tonumber( v[ "x" ] ) == math.ceil( tonumber( pos.x ) ) and tonumber( v[ "y" ] ) == math.ceil( tonumber( pos.y ) ) and tonumber( v[ "z" ] ) == math.ceil( tonumber( pos.z ) ) ) then
		
			CAKE.Response( ply, TEXT.DoorNotRentable );
			return;
			
		end
		
	end
	
	if( CAKE.IsDoor( door ) ) then

		if( door.owner == nil ) then
		
			if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= 50 ) then
				
				-- Enough money to start off, let's start the rental.
				CAKE.ChangeMoney( ply, -50 );
				door.owner = ply;
				CAKE.Response( ply, TEXT.DoorRented );
				
				local function Rental( ply, doornum )
				
					local door = ents.GetByIndex( tonumber( doornum ) );
					
					if( door.owner == ply ) then
					
						if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= 50 ) then
						
							CAKE.ChangeMoney( ply, 0 - 50 );
							CAKE.Response( ply, TEXT.DoorCharged );
							-- Start the timer again
							timer.Simple( 900, function() ply:Rental(doornum) end ); -- 15 minutes hoo rah
							
						else
						
							CAKE.Response( ply, TEXT.DoorLost );
							door:SetNWString("title", "")
							door.owner = nil;
							
						end
						
					end
				
				end
				
				timer.Simple( 900, function() Rental(ply, tonumber( args[ 1 ] )) end );
				
			end
			
		elseif( door.owner == ply ) then
		
			door.owner = nil;
			CAKE.Response( ply, TEXT.DoorRentCancelled );
			
		else
		
			CAKE.Response( ply, TEXT.DoorAlreadyRented );
			
		end
	
	end
	
end
concommand.Add( "rp_purchasedoor", ccPurchaseDoor );

function ccDoorRenting( ply, cmd, args )
	if not ply:IsSuperAdmin() then
		CAKE.Response(ply, TEXT.SuperAdminOnly)
		return
	end

	if (not args[1] or not tonumber(args[1]) or tonumber(args[1]) < 0) or
		(not args[2] or not tonumber(args[2]) or (tonumber(args[2]) ~= 0 and tonumber(args[2]) ~= 1)) then

		CAKE.Response(ply, TEXT.DoorRentCommandUsedIncorrectly)
		return
	end

	local door = ents.GetByIndex(tonumber(args[1]))
	door:SetNWBool("nonRentable", not door:GetNWBool("nonRentable"))
	local tx
	if door:GetNWBool("nonRentable") then
		tx = TEXT.DoorRentingDisabled
	else
		tx = TEXT.DoorRentingEnabled
	end
	CAKE.Response(ply, tx)
	-- Save it for future map loads
	DB.StoreDoorRentability(door)
end
concommand.Add( "rp_doorrenting", ccDoorRenting );

function ccDropWeapon( ply, cmd, args )
	
	local wep = ply:GetActiveWeapon( )
	
	if( ItemData[ wep:GetClass( ) ] == nil ) then CAKE.Response( ply, TEXT.WeaponNotDroppable ); return; end
	
	ply:StripWeapon( wep:GetClass( ) );
	
	CAKE.CreateItem( ply, wep:GetClass( ), ply:CalcDrop( ), Angle(0,0,0) );
	
end
concommand.Add( "rp_dropweapon", ccDropWeapon );

function ccPickupItem( ply, cmd, args )
	
	local item = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( item != nil and item:IsValid( ) and
		(not CAKE.IsDoor(item) and not item:IsVehicle() and not item:IsPlayer() and not item:IsNPC()) and
		item:GetPos( ):Distance( ply:GetShootPos( ) ) < 100 ) then

		if item:Pickup(ply) ~= false then
			ply:GiveAmmo(item:GetNWInt("Clip1A"), game.GetAmmoName(item:GetNWInt("PAmmoType")))
			ply:GiveAmmo(item:GetNWInt("Clip2A"), game.GetAmmoName(item:GetNWInt("SAmmoType")))
			if item:GetClass() == "spawned_weapon" then
				ply:GiveItem( item.class );
			else
				ply:GiveItem( item.Class );
			end
		end
	end

end
concommand.Add( "rp_pickup", ccPickupItem );

function ccUseItem( ply, cmd, args )
	
	local item = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( item != nil and item:IsValid( ) and (not CAKE.IsDoor(item) and not item:IsVehicle() and not item:IsPlayer() and not item:IsNPC()) and item.UseItem and item:GetPos( ):Distance( ply:GetShootPos( ) ) < 100 ) then
		
		item:UseItem( ply );
		
	end

end
concommand.Add( "rp_useitem", ccUseItem );

function ccTakeAmmo(ply, cmd, args)
	local item = ents.GetByIndex(tonumber(args[ 1 ]))

	if item ~= nil and IsValid(item) and (not CAKE.IsDoor(item) and not item:IsVehicle() and not item:IsPlayer() and not item:IsNPC()) and item.UseItem and item:GetPos():Distance(ply:GetShootPos()) < 100 then

		print("giving ammo...")
		print(tostring(item:GetNWInt("Clip1A")) .. " units of " .. tostring(game.GetAmmoName(item:GetNWInt("PAmmoType") or 0) or ""))
		print(tostring(item:GetNWInt("Clip2A")) .. " units of " .. tostring(game.GetAmmoName(item:GetNWInt("SAmmoType") or 0) or ""))

		ply:GiveAmmo(item:GetNWInt("Clip1A"), tostring(game.GetAmmoName(item:GetNWInt("PAmmoType") or 0) or ""))
		item:SetNWInt("Clip1A", 0)

		ply:GiveAmmo(item:GetNWInt("Clip2A"), tostring(game.GetAmmoName(item:GetNWInt("SAmmoType") or 0) or ""))
		item:SetNWInt("Clip2A", 0)
	end
end
concommand.Add( "rp_takeammo", ccTakeAmmo );

function ccSetMoney(ply, cmd, args)
	if not args[1] or not tonumber(args[2]) or not math.IsFinite(tonumber(args[2])) or not ply:IsSuperAdmin() then
		CAKE.Response(ply, TEXT.SetMoneyUsedIncorrectly)
		return
	end

	local amt = math.floor(tonumber(args[2]))

	local tp = nil

	local plys = player.GetAll()
	for k, v in ipairs(plys) do
		if v:GetName():lower():find(args[1]:lower()) then
			tp = v
			break
		end
	end

	if tp != nil then
		if amt > 0 then
			CAKE.ChangeMoney(tp, -CAKE.GetCharField(tp, "money"))
			CAKE.ChangeMoney( tp, amt );
			CAKE.Response( ply, TEXT.YouGaveX_Y_Tokens(tp:Nick(), amt) );
			CAKE.Response( tp, TEXT.X_GaveYouY_Tokens(ply:Nick(), amt) );
		else
			CAKE.Response( ply, "Invalid Amount" );
		end
	else
		CAKE.Response( ply, "Player Not Found" );
	end
end
concommand.Add( "rp_setmoney", ccSetMoney );

function ccGiveMoney( ply, cmd, args )

	if not args[1] or not tonumber(args[1]) or not math.IsFinite(tonumber(args[1])) or not args[2] or not tonumber(args[2]) or not math.IsFinite(tonumber(args[2])) then
		CAKE.Response(ply, TEXT.GiveMoneyUsedIncorrectly)
		return
	end
	
	if( player.GetByID(tonumber(args[1])) != nil ) then
	
		local target = player.GetByID(args[1])
		
		if tonumber(args[2]) > 0 then
		
			if tonumber(CAKE.GetCharField(ply, "money")) >= tonumber(args[2]) then
			
				CAKE.ChangeMoney( target, args[ 2 ] );
				CAKE.ChangeMoney( ply, 0 - args[ 2 ] );
				CAKE.Response( ply, TEXT.YouGaveX_Y_Tokens(target:Nick(), args[2]) );
				CAKE.Response( target, TEXT.X_GaveYouY_Tokens(ply:Nick(), args[2]) );
				
			else
			
				CAKE.Response( ply, TEXT.NotEnoughTokens );
				
			end
			
		else
		
			CAKE.Response( ply, TEXT.InvalidAmount );
			
		end
		
	else
	
		CAKE.Response( ply, TEXT.TargetNotFound );
		
	end
	
end
concommand.Add( "rp_givemoney", ccGiveMoney );	

function ccOpenChat( ply, cmd, args )

	ply:SetNWInt( "chatopen", 1 )
	
end
concommand.Add( "rp_openedchat", ccOpenChat );

function ccCloseChat( ply, cmd, args )

	ply:SetNWInt( "chatopen" , 0)
	
end
concommand.Add( "rp_closedchat", ccCloseChat );

net.Receive("show_help", function( len, ply )
	if IsValid( ply ) and ply:IsPlayer( ) then
		local whetherToShow = 0;

		if net.ReadBool( ) then
			whetherToShow = 1;
		end

		CAKE.SetPlayerField( ply, "showhelppopup", whetherToShow );
	end
end)
