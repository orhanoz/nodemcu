--main.lua--

print("main in progress")

tmr.alarm(0,1000,1,function()
    if wifi.sta.getip()==nil then
        print("Connecting...")
    else
        ip,nm,gw=wifi.sta.getip()
        print("\nIP:",ip)
        print("\nNetmask:",nm)
        print("\nGateway:",gw)
    end
end)

--http server
srv=net.createServer(net.TCP)
srv.listen(80,function(conn)
    conn:on("recieve",function(conn,payload)
        print(payload)
        conn:send("<h1>Hi there</h1>")
    end)
    conn:on("sent",function(conn) conn:close() end)
end)
