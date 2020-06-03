local str = "不同的机体从属于不同的<color=#ff0000>阵营</color>，每个<color=#ff0000>阵营</color>的所带来的<color=#ff0000>加成</color>不同"

local function _list_table(tb, table_list, level)
    local ret = ""
    local indent = string.rep(" ", level*4)

    for k, v in pairs(tb) do
        local quo = type(k) == "string" and "\"" or ""
        ret = ret .. indent .. "[" .. quo .. tostring(k) .. quo .. "] = "

        if type(v) == "table" then
            local t_name = table_list[v]
            if t_name then
                ret = ret .. tostring(v) .. " -- > [\"" .. t_name .. "\"]\n"
            else
                table_list[v] = tostring(k)
                ret = ret .. "{\n"
                ret = ret .. _list_table(v, table_list, level+1)
                ret = ret .. indent .. "}\n"
            end
        elseif type(v) == "string" then
            ret = ret .. "\"" .. tostring(v) .. "\"\n"
        else
            ret = ret .. tostring(v) .. "\n"
        end
    end

    local mt = getmetatable(tb)
    if mt then 
        ret = ret .. "\n"
        local t_name = table_list[mt]
        ret = ret .. indent .. "<metatable> = "

        if t_name then
            ret = ret .. tostring(mt) .. " -- > [\"" .. t_name .. "\"]\n"
        else
            ret = ret .. "{\n"
            ret = ret .. _list_table(mt, table_list, level+1)
            ret = ret .. indent .. "}\n"
        end
        
    end

   return ret
end

-------------------------------------------------------------------
-- Public functions
-------------------------------------------------------------------

function table.str(tb)
    if type(tb) ~= "table" then
        error("Sorry, it's not table, it is " .. type(tb) .. ".")
    end

    local ret = " = {\n"
    local table_list = {}
    table_list[tb] = "root table"
    ret = ret .. _list_table(tb, table_list, 1)
    ret = ret .. "}"
    return ret
end
function LogError(...)
	local args = { ... }
	local arg = (args)[1]
	if type(arg) == 'table' then
		args[1] = table.str(arg)
	end
    -- UIMethod.LogError('lua', '', tostring(args[1]))
    print(tostring(args[1]))
end
function SubStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = SubStringGetTotalIndex(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = SubStringGetTotalIndex(str) + endIndex + 1;
    end

    if endIndex == nil then 
        return string.sub(str, SubStringGetTrueIndex(str, startIndex));
    else
        -- print(SubStringGetTrueIndex(str, endIndex + 1) - 1)
        return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) - 1);
    end
end
 
 --獲取中英混合UTF8字符串的真實字符數量
 function SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
 end
 
 function SubStringGetTrueIndex(str, index)
     local curIndex = 0;
     local i = 1;
     local lastCount = 1;
    repeat 
         lastCount = SubStringGetByteCount(str, i)
         i = i + lastCount;
         curIndex = curIndex + 1;
     until(curIndex >= index);
     return i - lastCount;
 end
 
 --返回當前字符實際占用的字符數
 function SubStringGetByteCount(str, index)
     local curByte = string.byte(str, index)
     local byteCount = 1;
     if curByte == nil then
         byteCount = 0
     elseif curByte > 0 and curByte <= 127 then
         byteCount = 1
     elseif curByte>=192 and curByte<=223 then
         byteCount = 2
     elseif curByte>=224 and curByte<=239 then
         byteCount = 3
     elseif curByte>=240 and curByte<=247 then
         byteCount = 4
  end
     return byteCount
 end

 function test(str)
    local maxNum = SubStringGetTotalIndex(str)
    local index = 1
    local t = {}
    for i in string.gmatch(str,"%<[%/%#%w=]*%>") do
        table.insert(t, i)
    end

    local posT = {}
    local firstPos = 1
    while string.find(str,"%<",firstPos ) do
        local pos = string.find(str, "%<", firstPos)
        firstPos = pos + 1
        table.insert(posT, pos)
    end
    LogError(posT)
    local isCanAdd = false
    while index <= maxNum do
        local s = SubStringUTF8(str, 1, index)
        for i=1,#posT - 1 do
            local v = posT[i]
            if v == string.len(s)  then
                index = index + #t[i]
                isCanAdd = true
            elseif string.len(s) < posT[i+1] - 1 and isCanAdd then
                s = s..t[i+1]
            elseif string.len(s) + 1 == posT[i+1] and isCanAdd then
                s = s..t[i+1]
                index = index + #t[i+1]
            end
        end
        index = index + 1
    end
    print("sdfsdfsdfsd")
end


test(str)