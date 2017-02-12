-- sleep us = 20-2 sec
	local COUNTSLEEP = 18000

function sendData()
	local r=tmr.now()
	local AOvar = adc.read(0)
	AOvar = AOvar * 3130
	AOvar = AOvar / 1024

	if wifi.sta.getip()== nil then
		print("IP unavaiable, Waiting...")
		print("Sleep 120 sec down...")
		node.dsleep(COUNTSLEEP)
	else
-- conection to thingspeak.com
	print("Sending data to thingspeak.com")
	conn=net.createConnection(net.TCP, 0)
	
	conn:on("receive", function(conn, payload) print(payload) end)
-- api.thingspeak.com
	conn:connect(8080,'192.168.43.43')
	
	print(conn)
	
	local buf = ""
	buf = buf.."<h1> ESP8266 Web Server</h1>"
				
	conn:send(buf)
	conn:send("Host: 192.168.43.43:8080\r\n")
	conn:send("Accept: */*\r\n")
	conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
	conn:send("\r\n")
	
	conn:on("sent",function(conn)
		print("Closing connect")
		conn:close()
	end)
	
	conn:on("disconnection", function(conn)
		print("Disconnect...")
		print("Sleep 2 sec down...")
		--node.dsleep(COUNTSLEEP)
	end)
	
	end
end

-- Wait 2000 ms for Init DS18B20 and last send to thingspeak
tmr.alarm(0, 2000, 1, function()
sendData()
end)

-- локальный сервер доступен в течении 20 sec на порту 8080
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
conn:send("Temperature RAMEDIA:")
conn:on("sent",function(conn) conn:close() end)
end)


