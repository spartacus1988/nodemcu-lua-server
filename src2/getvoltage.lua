
 
serv_ip = '192.168.43.43'
serv_port = 80
gpio.mode(4, gpio.OUTPUT)	--LED
gpio.mode(1, gpio.OUTPUT)	--RELAY
interval = 5000000

 
function getVoltage()
  AOvar = adc.read(0);
  AOvar = AOvar * 3130;
  AOvar = AOvar / 1024;
  conn = net.createConnection(net.TCP, 0)
  
  conn:on("connection", function(socket)
    socket:send(""..node.chipid().." "..tries.." "..AOvar.."\r")
  end)
  
  conn:on("sent",function(conn)
    conn:close()
  end)
  
  conn:on("disconnection", function(conn)
    node.dsleep(interval-tmr.now())
  end)
 
  conn:connect(serv_port, serv_ip)
 
end                  
 
function connect()
  tries = tries + 1
  wifi_ip = wifi.sta.getip()
  if wifi_ip == nil then
    if tries < 5 then
	  wifi.sta.setip({ip="192.168.43.10",netmask="255.255.255.0",gateway="192.168.43.1"})
	  print("NOW your static IP is ".. "192.168.1.10")
      tmr.alarm(0, 1000, 0, connect)
    else
      node.dsleep(interval-tmr.now())
    end
  else
	wifi.sta.setip({ip="192.168.43.10",netmask="255.255.255.0",gateway="192.168.43.1"})
	print("NOW your static IP is ".. "192.168.1.10")
    getVoltage()
  end
end
 
tries = 0
connect()