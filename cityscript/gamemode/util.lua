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
	local rets = {}

	for i=1, string.len(str) do
		rets[i] = string.sub(str, i, i)
	end

	return rets
end

function CAKE.ReferenceFix(data)
	if type(data) == "table" then
		return table.Copy(data)
	else
		return data
	end
end

function CAKE.InitTime() -- Load the time from the database or use the default value. This occurs on gamemode initialization.
	local clumpedtime = "1 1 " .. tostring(os.date("*t").year + 3) .. " 1"

	local d = 1
	local m = 1
	local y = tostring(os.date("*t").year + 3)
	local mins = 1

	local rpTime = DB.GetRPTime()

	if rpTime ~= nil then
		d = tonumber(rpTime.day)
		m = tonumber(rpTime.month)
		y = tonumber(rpTime.year)
		mins = tonumber(rpTime.minutes)
	else
		DB.InitRPTime(d, m, y, mins)
	end

	CAKE.ClockDay = d
	CAKE.ClockMonth = m
	CAKE.ClockYear = y
	CAKE.ClockMins = mins or 1

	SetGlobalString("time", "Loading...")
end

function CAKE.SaveTime()
	print("Saving the current RP time to the DB.")
	DB.SaveRPTime(CAKE.ClockDay, CAKE.ClockMonth, CAKE.ClockYear, CAKE.ClockMins)
end

function CAKE.SendTime()
	local nHours = string.format("%02.f", math.floor(CAKE.ClockMins / 60))
	local nMins = string.format("%02.f", math.floor(CAKE.ClockMins - (nHours*60)))

	if tonumber(nHours) > 12 then
		nHours = nHours - 12
		timez = "PM"
	else
		timez = "AM"
	end

	if tonumber(nHours) == 0 then
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

		if string.find(string.lower(v:Nick()), string.lower(name)) ~= nil then
			return v
		end

		if string.find(string.lower(v:Name()), string.lower(name)) ~= nil then
			return v
		end
	end
end
