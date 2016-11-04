print("main")
function postThingSpeak(level)
	connout=nil
	connout=net.createConnection(net.TCP,0)
	connout:on("receive",function(connout,payloadout)
		if(string.find(payloadout,"Status: 200 OK")~=nil) then
			print("Posted OK")
		end
	end)
	connout:on("connection",function(connout,payloadout)
		print("Posting...")
		local adc_value=adc.read(0)
		local status,temp,humi,temp_decimal,humi_decimal=dht.read11(1)
		if temp==-999 or humi==-999 then
		local status,temp,humi,temp_decimal,humi_decimal=dht.read11(1)
		end
		connout:send("GET /update?api_key=*************&field1="..adc_value..
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
end
tmr.alarm(1,60000,1,function() postThingSpeak(0) end)
