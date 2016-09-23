function startup()
    print("init...")
    dofile("mqtt_sensor_actuator")
end

tmr.alarm(0,5000,0,startup)

