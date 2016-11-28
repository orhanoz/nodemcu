if file.open("time.config","w+") then
	t=rtctime.epoch2cal(rtctime.get())
	print(t["hour"],t["min"])
	file.write("state:1year:"..t["year"].."mon:"..t["mon"].."day"..t["day"].."hour:"..t["hour"].."min:"..t["min"]..":end")
	file.close()
end
if file.open("time.config","r") then
	tempRead=file.read()
	if(string.sub(tempRead,string.find(tempRead,"year:")+5,string.find(tempRead,"mon:")-1)=="1970") then
 		dofile("readDate.lua")
		file.close()
	end
	file.close()
end
end


