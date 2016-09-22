--init lua--

ssid=""
pass=""

print("init in progress")
wifi.setmode(wifi.STATION)
wifi.sta.config(ssid,pass)

dofile("main.lua")
