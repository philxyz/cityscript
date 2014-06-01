-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- util.lua
-- Contains important server functions.
-------------------------------

-- Oh, don't mind me.. just adding a useful function.
function string.explode(str)

	local rets = {};
	
	for i=1, string.len(str) do
	
		rets[i] = string.sub(str, i, i);
		
	end
	
	return rets;

end

function CAKE.ReferenceFix(data)

	if(type(data) == "table") then
	
		return table.Copy(data);
		
	else
	
		return data;
		
	end
	
end

function CAKE.NilFix(val, default)

	if(val == nil) then
	
		return default;
	
	else
	
		return val;
		
	end
	
end

function CAKE.InitTime() -- Load the time from a text file or default value, this occurs on gamemode initialization.

	local clumpedtime = "1 1 2012 1"
	
	if(file.Exists("CakeScript/time.txt", "DATA")) then
	
		clumpedtime = file.Read("CakeScript/time.txt")
		
	else
	
		file.Write("CakeScript/time.txt", "1 1 2012 1")
		
	end
	
	local unclumped = string.Explode(" ", clumpedtime)
	CAKE.ClockDay = tonumber(unclumped[1])
	CAKE.ClockMonth = tonumber(unclumped[2])
	CAKE.ClockYear = tonumber(unclumped[3])
	CAKE.ClockMins = tonumber(unclumped[4])
	
	SetGlobalString("time", "Loading..")
	
end

function CAKE.SaveTime()

	local clumpedtime = CAKE.ClockDay .. " " .. CAKE.ClockMonth .. " " .. CAKE.ClockYear .. " " .. CAKE.ClockMins
	file.Write("CakeScript/time.txt", clumpedtime)
	
end

function CAKE.SendTime()

	local nHours = string.format("%02.f", math.floor(CAKE.ClockMins / 60));
	local nMins = string.format("%02.f", math.floor(CAKE.ClockMins - (nHours*60)));
	
	if(tonumber(nHours) > 12) then 
	
		nHours = nHours - 12
		timez = "PM";
		
	else
	
		timez = "AM";
		
	end
	
	if(tonumber(nHours) == 0) then
	
		nHours = 12
		
	end

	local monthLeadingZero = ""
	local dayLeadingZero = ""
	if CAKE.ClockMonth < 10 then monthLeadingZero = "0" end
	if CAKE.ClockDay < 10 then dayLeadingZero = "0" end
	
	SetGlobalString("time", CAKE.ClockYear .. "-" .. monthLeadingZero .. CAKE.ClockMonth .. "-" .. dayLeadingZero .. CAKE.ClockDay .. " | " .. nHours .. ":" .. nMins .. timez)
	
end

function CAKE.FindPlayer(name)
	local ply = nil
	local count = 0
	
	for k, v in pairs(player.GetAll()) do
		if tonumber(name) and tostring(v:UserID()) == name then
			return v
		end

		if(string.find(string.lower(v:Nick()), string.lower(name)) != nil) then
			return v
		end
			
		if(string.find(string.lower(v:Name()), string.lower(name)) != nil) then
			return v
		end
	end
end
