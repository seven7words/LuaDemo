local str = "接收指挥官任务，前往沙漠<color=#ff0000>收集超合金</color>"


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
    local isCanAdd = false
    while index <= maxNum do
        local s = SubStringUTF8(str, 1, index)
        for i=1,#posT - 1 do
            local v = posT[i]
            if v == string.len(s) + 1  then
                index = index + #t[i]
                isCanAdd = true
            elseif string.len(s) < posT[i+1] - 1 and isCanAdd then
                s = s..t[i+1]
            elseif string.len(s) + 1 == posT[i+1] and isCanAdd then
                s = s..t[i+1]
                index = index + #t[i+1]
            end
        end
        print(s)
        index = index + 1
    end
    
end

test(str)