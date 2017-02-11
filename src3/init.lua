FileToExecute="httpsender.lua"
l = file.list();
 -- читаем ADC до активации коннекта (вызывает сброс после)
    wifi.sta.disconnect()
    wifi.sta.autoconnect(0)
	gpio.mode(4, gpio.OUTPUT)	--LED
	gpio.mode(1, gpio.OUTPUT)	--RELAY
	
local config = require("config")
	
for k,v in pairs(l) do
  if k == FileToExecute then
    print("*** You've got 5 sec to stop timer 0 ***")
    tmr.alarm(0, 5000, 0, function()
	
		print("Setting up Wi-Fi...")	
		if config.SSID and config.SSID[key] then
        wifi.setmode(wifi.STATION);
        wifi.sta.config(key, config.SSID[key])
        wifi.sta.connect()
        print("Connecting to " .. key .. " ...")
		
		local cnt=0

		tmr.alarm(1, 1000, 1, function()
			if wifi.sta.getip()==nil then
			print("IP unavaiable, Waiting...")

			cnt = cnt + 1
			if (cnt > 4) then tmr.stop(1) node.dsleep(COUNTSLEEP) end
			else tmr.stop(1)
			print("Config done, IP is "..wifi.sta.getip())
			wifi.sta.setip({ip="192.168.43.10",netmask="255.255.255.0",gateway="192.168.43.1"})
			print("NOW your static IP is ".. "192.168.43.10")
			dofile("httpsender.lua")
			collectgarbage()
			end
		end)
    end)
  end
end
	
    