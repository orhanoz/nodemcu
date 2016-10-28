print("firstconn")
srv=net.createServer(net.TCP,30)
	srv:listen(80,function(conn)
		conn:on("receive",function(conn,payload)
                print(payload) 
			if string.match(payload,"wifiId=",0) then
            	wifiId=string.sub(payload,string.find(payload,"wifiId=")+7,string.find(payload,"wifiPwd=")-2)
				wifiPwd=string.sub(payload,string.find(payload,"wifiPwd=")+8,string.find(payload,"writeIdPwd=")-2)                
				if string.len(wifiPwd)>=8 then
					if file.open("datas","w+") then			
						file.write("ssid:"..wifiId.."pass:"..wifiPwd..":end")
						file.close()
						dofile("init.lua")
					end
				end	
            end
		local response={
                'HTTP/1.1 200 OK\n\n',
                '<!DOCTYPE HTML>\n',
                '<html>\n',
                '<head><meta  content="text/html; charset=utf-8">\n',
                '<title>GreenBox</title></head>\n',
                '<body><h1>GreenBox! Road to success</h1>\n',
                '<form action="" method="POST">\n',
                '<input type="text" name="wifiId" value="Wifi Id">\n',
                '<form action="" method="POST">\n',
                '<input type="text" name="wifiPwd" value="Password">\n',
                '<form action="" method="POST">\n',
                '<input type="submit" name="writeIdPwd" value="Send">\n',
                '</body></html>\n'
		}
		local function sender(conn)
    			if #response>0 then conn:send(table.remove(response,1))
        		else conn:close()
    			end
		end
	conn:on("sent", sender)
	sender(conn)
end)
end)
