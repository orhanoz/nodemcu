print("control")
temp=tonumber(_G.temp_val)
humi=tonumber(_G.humi_val)
selection=_G.selection
temp_wanted=tonumber(_G.tempWanted)
temp_offset=tonumber(_G.tempOffset)
humi_wanted=tonumber(_G.humiWanted)
humi_offset=tonumber(_G.humiOffset)
day_time=tonumber(_G.dayTime)
gpio.mode(5,gpio.OUTPUT)--fan
gpio.mode(6,gpio.OUTPUT)--heater
gpio.mode(7,gpio.OUTPUT)--atom
gpio.mode(8,gpio.OUTPUT)

if temp>=temp_wanted+temp_offset then
    gpio.write(5,gpio.LOW)
    gpio.write(6,gpio.HIGH)
    tmr.delay(500000)
elseif temp<=temp_wanted-temp_offset then
    gpio.write(6,gpio.LOW)
    gpio.write(5,gpio.HIGH)
    tmr.delay(500000)
else
    gpio.write(5,gpio.HIGH)
    gpio.write(6,gpio.HIGH)
    tmr.delay(500000)
end 

if humi>=humi_wanted+humi_offset then
    gpio.write(7,gpio.HIGH)
    gpio.write(5,gpio.LOW)
    tmr.delay(500000)
elseif humi<=humi_wanted-humi_offset then
    gpio.write(5,gpio.HIGH)
    gpio.write(7,gpio.LOW)
    tmr.delay(500000)
else
    gpio.write(5,gpio.HIGH)
    gpio.write(7,gpio.HIGH)
    tmr.delay(500000)
end

dofile("send.lua")
