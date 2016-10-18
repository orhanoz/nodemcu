--init.lua-- 
print('\ninit.lua in progress...\n')
--wifi config begins
local wifiConfig={}
wifiConfig.mode=wifi.STATIONAP
wifiConfig.accessPointConfig={}
wifiConfig.accessPointConfig.ssid="Greeny"..node.chipid()
wifiConfig.accessPointConfig.pwd="Greeny"..node.chipid()

wifiConfig.accessPointIpConfig={}
wifiConfig.accessPointIpConfig.ip="192.168.1.1"
wifiConfig.accessPointIpConfig.netmask="255.255.255.0"
wifiConfig.accessPointIpConfig.gateway="192.168.1.1"

wifiConfig.stationPointConfig={}
wifiConfig.stationPointConfig.ssid=""
wifiConfig.stationPointConfig.pwd=""

if file.open("datas","r") then
    tempRead=file.read()
    wifiConfig.stationPointConfig.ssid=string.sub(tempRead,string.find(tempRead,":")+1,string.find(tempRead,"pass:")-1)
    wifiConfig.stationPointConfig.pwd=string.sub(tempRead,string.find(tempRead,"pass:")+5,string.find(tempRead,":end")-1)
    file.close()
end
wifi.setmode(wifiConfig.mode)
print('set (mode='..wifi.getmode()..')')

if(wifiConfig.mode==wifi.SOFTAP) or (wifiConfig.mode==wifi.STATIONAP) then
    print('AP MAC: ',wifi.ap.getmac())
    wifi.ap.config(wifiConfig.accessPointConfig)
    wifi.ap.setip(wifiConfig.accessPointIpConfig)
end

if(wifiConfig.mode == wifi.STATION) or (wifiConfig.mode == wifi.STATIONAP) then
    print('Client MAC: ',wifi.sta.getmac())
    wifi.sta.config(wifiConfig.stationPointConfig.ssid, wifiConfig.stationPointConfig.pwd, 1)
end
print('ssid: ',wifiConfig.stationPointConfig.ssid)
print('pass: ',wifiConfig.stationPointConfig.pwd)
print('chip: ',node.chipid())
print('heap: ',node.heap())
wifiConfig = nil
tempRead=nil
collectgarbage()
--wificonfig end
if(wifi.getmode()==wifi.STATION) or (wifi.getmode()==wifi.STATIONAP) then
    local joinCounter=0
    local joinMaxAttempts=5
    tmr.alarm(0,3000,1,function()
        local ip=wifi.sta.getip()
        if ip==nil and joinCounter < joinMaxAttempts then
            print("Connecting to wifi access point...")
            joinCounter=joinCounter+1
        else
            if joinCounter==joinMaxAttempts then
                print("Failed to connect access point")
                print("Starting a node on 192.168.1.1")
                srv=net.createServer(net.TCP,30)
                srv:listen(80,function(conn)
                    conn:on("receive",function(conn,payload)
                        print(payload)
                conn:send('HTTP/1.1 200 OK\n\n')
                conn:send('<!DOCTYPE HTML>\n')
                conn:send('<html>\n')
                conn:send('<head><meta  content="text/html; charset=utf-8">\n')
                conn:send('<title>GreenBox</title></head>\n')
                conn:send('<body><h1>GreenBox! Road to success</h1>\n')
                conn:send('<form action="" method="POST">\n')
                conn:send('<input type="text" name="wifiId" value="Wifi Id">\n')
                conn:send('<form action="" method="POST">\n')
                conn:send('<input type="text" name="wifiPwd" value="Password">\n')
                conn:send('<form action="" method="POST">\n')
                conn:send('<input type="submit" name="writeIdPwd" value="Send">\n')
                conn:send('</body></html>\n')
            end)
            conn:on("sent",function(conn) conn:close() end)
        end)
        print(wifiId)
        print(wifiPwd)
            else
                print("Connected .. ip:",ip)
            end
            tmr.stop(0)
            joinCounter=nil
            joinMaxAttempts=nil
            collectgarbage()
        end
    end)
end

