local tempo=0
local counter=0
for i=1,10 do 
    temp=adc.read(0)
    if temp>0 or temp<1023 then
        tempo=temp+tempo
        counter=counter+1
    end
end
_G.adc_val=tempo/counter

local status,temp,humi,temp_decimal,humi_decimal=dht.read11(1)
if (status == dht.OK) then
    _G.temp_val=temp
    _G.humi_val=humi
elseif (status==dht.ERROR_CHECKSUM) then
    _G.temp_val=0
    _G.humi_val=0
elseif (status==dht.ERROR_TIMEOUT) then
    _G.temp_val=0
    _G.humi_val=0
end
dofile("control.lua")
