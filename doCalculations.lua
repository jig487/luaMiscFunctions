local tArgs = {...}

local debug = false

local menuLua = require("menuLua.lua")

local function txt(x,y,str)
    term.setCursorPos(x,y)
    term.write(str)
end

local function decToBinStr(x)
	local ret=""
	while x~=1 and x~=0 do
		ret=tostring(x%2)..ret
		x=math.modf(x/2)
	end
	ret=tostring(x)..ret
	return ret
end

local function binStrToDec(num)
    local res = 0
    for i=1,#num do
        if num:sub(i,i) ~= '0' and num:sub(i,i) ~= '1' then
            return 0
        end
        res = res * 2 + tonumber(num:sub(i,i))
    end
    return res
end

local function calc(val)
    return (val[1]/256)*val[2]*5000
end

local tbl = {
    0,1,2,4,8,16,32,64,128,192,224,240,248,252,254,255
}

local alt = false

local resultTbl = {}

if #tArgs ~= 0 then
    print( calc(tArgs) )
else
    term.setCursorPos(1,1)
    term.clear()
    for i = 1, #tbl do
        if alt then alt = false term.setTextColor(colors.green)
        else alt = true term.setTextColor(colors.white) end

        resultTbl[i] = { label = tbl[i].." : "..(calc( {0.002,tbl[i]} )) }

    end
    menuLua.handleMenu(resultTbl,5)
end
