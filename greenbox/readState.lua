CHANNEL="176507"
READ_KEY="WPPGMVOKBF89KH63"
function readTSfield(level)
connout=nil
connout=net.createConnection(net.TCP,0)
connout:on("receive",function(connout,payloadout)success=true 
    print("received"..payloadout)
    if string.sub(payloadout,string.len(payloadout)-1)==nil then 
    end
    if string.sub(payloadout,string.len(payloadout)-1)~=nil then
        _G.selection=tonumber(string.sub(payloadout,string.len(payloadout)-1))
        dofile("existence.lua")
    end
end)
connout:on("connection",function(connout,payloadout)
    print("Receiving...")
    connout:send("GET /channels/"..CHANNEL.."/fields/4/last?key="..READ_KEY..
    " HTTP/1.1\r\n"..
    "Host: api.thingspeak.com\r\n"..
    "Connection:close\r\n"..
    "Accept: */*\r\n"..
    "User-Agent: Mozilla/4.0 (compatible;esp8266 Lua;Windows NT 5.1)\r\n"..
    "\r\n")
    
end)
connout:on("disconnection",function(connout,payloadout)print("disconnected")
end)
connout:connect(80,"api.thingspeak.com")
end
tmr.alarm(1,5000,1,function() readTSfield(0) end)
