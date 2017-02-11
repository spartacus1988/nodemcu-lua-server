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
	conn:send("GET /update?key=apikey&field1="..AOvar.."&field2="..r.." HTTP/1.1\r\n Host: 192.168.43.43:8080\r\n")
	conn:send("Host: 192.168.43.43\r\n")
	conn:send("Accept: */*\r\n")
	conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
	conn:send("\r\n")
	
	conn:on("sent",function(conn)
		print("Closing connect")
		conn:close()
	end)
	
	conn:on("disconnection", function(conn)
		print("Disconnect...")
		print("Sleep 120 sec down...")
		--node.dsleep(COUNTSLEEP)
	end)
	
	end
end

-- Wait 2000 ms for Init DS18B20 and last send to thingspeak
tmr.alarm(0, 2000, 1, function()
sendData()
end)