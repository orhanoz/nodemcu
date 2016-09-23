projectID="8027"
SENSOR_NAME1="ldr"
SENSOR_NAME2     = "dht"
ACTUATOR_NAME    = "led"
apiKey           = "4b054efb-a46d-4582-98d7-2550501a9288"
deviceUUID       = "88ada8eb-7081-46f7-a499-7453efda907c"
serverIP   = "mqtt.devicehub.net" -- mqtt.devicehub.net IP
mqttport   = 1883                 -- MQTT port (default 1883)
userID     = "orhanoz"                   -- username for authentication if required
userPWD    = "dallama"                   -- user password if needed for security
clientID   = "ndcu"               -- Device ID
mqtt_state = 0                    -- State control

wifiName = "TeRaSMoteL"
wifiPass = "terasmotel"

wifi.setmode(wifi.STATION)
wifi.sta.config(wifiName,wifiPass)
wifi.sta.connect()
tmr.alarm(0,1000,1,function()
        if wifi.sta.getip()==nil then
            print("Connecting")
        else
            ip,nm,gw=wifi.sta.getip()
            print("\nIP:",ip)
            print("\nNetmask:",nm)
            print("\nGateway:",gw)
            tmr.stop(0)
        end
    end)

relay_pin=
dht_pin=
ldr_pin=

gpio.mode(dht_pin,gpio.INT)
gpio.mode(ldr_pin,gpio.INT)
gpio.mode(relay_pin,gpio.OUTPUT)
gpio.write(relay_pin,gpio.LOW)

function setRelay(state)
    if state==1 then
        gpio.write(relay_pin,gpio.HIGH)
    else
        gpio.write(relay_pin,gpio.LOW)
    end
end

function mqtt_do()
    if mqtt_state < 5 then
        mqtt_state=wifi.sta.status()
    elseif mqtt_state==5 then
        m=mqtt.Client(clientID,120,userID,userPWD)
        mqtt_state=10
        m:on("message",
        function(conn,topic,data)
            if data~=nil then
                local pack=cjson.decode(data)
                if pack.state then 
                    print("Recieved actuator 1 value"..pack.state.."!")
                    if pack.state ==0 or pack.state=="0" then
                        setRelay(0)
                    elseif pack.state==1 or pack.state=="1" then
                        setRelay(1)
                    end
                end
            end
        end)
    elseif mqtt_state==10 then
        m:connect(serverIP,mqttport,0,
        function(conn)
            print("Connected to mqtt:"..serverIP..":"..mqttport.."as"..clientID)
            m:subscribe("/a/"..apiKey.."/p/"..projectID.."/d/"..deviceUUID.."/actuator/"..ACTUATOR_NAME.."/state",0,
            function(conn)
                print("subscribed")
                mqtt_state = 20 -- Go to publish state
            end)
        end)
    elseif mqtt_state==20 then
         t1 = math.random(0, 500) -- generate random number to simulate analog sensor, replace with your actual sensor
         m:publish("/a/"..apiKey.."/p/"..projectID.."/d/"..deviceUUID.."/sensor/"..SENSOR_NAME1.."" , "{\"value\": "..t1.."}", 0, 0,
         function(conn)
             print("Sent sensor value "..t1.."!")
             mqtt_state=25
         end)
         tmr.delay(250)
     elseif mqtt_state=25 then
         t2 = math.random(0, 1) -- generate random number to simulate digital sensor, replace with your actual senso mqtt_state=25 then
         m:publish("/a/"..apiKey.."/p/"..projectID.."/d/"..deviceUUID.."/sensor/"..SENSOR_NAME2.."" , "{\"value\": "..t2.."}", 0, 0,
         function(conn)
             print(" Sent Sensor 2 value "..t2.." !")
             mqtt_state = 20
         end)
         tmr.delay(250)
     end
 end
 tmr.alarm(0,600,1,function() mqtt_do() end)

