-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- error_handling.lua
-- This helps with errors, and catches them before they break the script.
-------------------------------

function ErrorHandler(func, args, ret, errcode)
	CAKE.CallHook("ErrorHandler", func, args, ret, errcode)

	local s = func .. "() " .. TEXT.Failed .. ": " .. func .. "(" .. table.concat(args, ",") .. ") " .. TEXT.FailedWithError .. " " .. errcode .. ": " .. (ErrorCodes[errcode] or TEXT.InvalidErrorCode)

	DB.LogEvent("errors", s)
	print(s)

	return ret
end

ErrorCodes = {}

function AddCode(id, text)
	ErrorCodes[id] = text
end

-- Error Codes
for i=1, 8 do
	AddCode(i, TEXT.Error[i])
end
