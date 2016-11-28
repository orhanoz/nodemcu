function postThingSpeak(level)
    connout=nil
    connout=net.createConnection(net.TCP,0)
    connout:on("receive",function(connout,payloadout)
        if(string.find(payloadout,"Status: 200 OK")~=nil) then
            print("Posted OK")
        end
    end)
    connout:on("connection",function(connout,payloadout)
        print("Posting")
        temp=tonumber(_G.temp_val)
        humi=tonumber(_G.humi_val)
        adc_value=tonumber(_G.adc_val)
        connout:send("GET /update?api_key=29I9SY6QZWYQ9FF2&field1="..adc_value..
        "&field2="..temp..
        "&field3="..humi..
        " HTTP/1.1\r\n"..
        "Host: api.thingspeak.com\r\n"..
        "Connection:close\r\n"..
        "Accept: */*\r\n"..
        "User-Agent: Mozilla/4.0 (compatible;esp8266 Lua;Windows NT 5.1)\r\n"..
        "\r\n")
    end)
    connout:on("disconnection",function(connout,payloadout)
        connout:close();
        collectgarbage();
    end)
    connout:connect(80,'api.thingspeak.com')
    dofile("read.lua")
end
tmr.alarm(1,30000,1,function() postThingSpeak(0) end)
