selection=_G.selection
if file.exists(selection..".config") then
    if file.open(selection..".config","r") then
        tempRead=file.read()
        _G.dayTime=string.sub(tempRead,string.find(tempRead,"day:")+4,string.find(tempRead,"temp:")-1)
        _G.tempWanted=string.sub(tempRead,string.find(tempRead,"temp:")+5,string.find(tempRead,"tempoffset:")-1)
        _G.tempOffset=string.sub(tempRead,string.find(tempRead,"tempoffset:")+11,string.find(tempRead,"humi:")-1)
        _G.humiWanted=string.sub(tempRead,string.find(tempRead,"humi:")-5,string.find(tempRead,"humioffset:")-1)
        _G.humiOffset=string.sub(tempRead,string.find(tempRead,"humioffset:")+11,string.find(tempRead,"end:")-1)
        file.close()
    end
    dofile("readSensor.lua")
end
