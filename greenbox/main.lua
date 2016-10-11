--main.lua --

-- WiFi Connection Verification 
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
         print("Connecting to AP...\n")
            else
                  ip, nm, gw=wifi.sta.getip()
                        print("IP Info: \nIP Address: ",ip)
                              print("Netmask: ",nm)
                                    print("Gateway Addr: ",gw,'\n')
                                          tmr.stop(0)
                                             end
                                             end)
--Read LDR
adc_id = 0
adc_value=adc.read(adc_id)
--Read DHT!!
status,temp,humi,temp_decimal,humi_decimal=dht.read11(1)

-- Web Server --
print("Starting Web Server...")
-- Create a server object with 30 second timeout
srv = net.createServer(net.TCP, 30)
srv:listen(80, function(conn)
        conn:on("receive", function(conn, payload)
                    print(payload)
--Sending basic stuff
conn:send('HTTP/1.1 200 OK\n\n')
conn:send('<!DOCTYPE HTML>\n')
conn:send('<html>\n')
conn:send('<head><meta  content="text/html; charset=utf-8">\n')
conn:send('<title>GreenBox</title></head>\n')
conn:send('<body><h1>GreenBox! Road to success</h1>\n')
--Labels
conn:send('<p>ADC Value: '..adc_value..'</p><br>')
conn:send('<p>Temperature: '..temp..'</p><br>')
conn:send('<p>Humidity: '..humi..'</p><br>')
conn:send('</body></html>\n')
end)
conn:on("sent", function(conn) conn:close() end)
end)
