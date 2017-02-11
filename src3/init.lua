FileToExecute="httpsender.lua"
l = file.list();
 -- читаем ADC до активации коннекта (вызывает сброс после)
    wifi.sta.disconnect()
    wifi.sta.autoconnect(0)
	gpio.mode(4, gpio.OUTPUT)	--LED
	gpio.mode(1, gpio.OUTPUT)	--RELAY
	
local config = require("config")
	
local function waitForIP()
  if wifi.sta.getip() == nil then
    print("IP unavailable, Waiting...")
  else
    tmr.stop(1)
    print("====================================")
    print("ESP8266 mode is: " .. wifi.getmode())
    print("MAC address is: " .. wifi.ap.getmac())
    print("IP is ".. wifi.sta.getip())
    print("====================================")

    wifi.sta.setip({ip="192.168.43.10",netmask="255.255.255.0",gateway="192.168.43.1"})
    print("NOW your static IP is ".. "192.168.43.10")
	
		dofile("httpsender.lua")
		collectgarbage()
  end
end	
	
local function connectToNetwork(aps)
  if aps then
    for key, _ in pairs(aps) do
      if config.SSID and config.SSID[key] then
        wifi.setmode(wifi.STATION);
        wifi.sta.config(key, config.SSID[key])
        wifi.sta.connect()
        print("Connecting to " .. key .. " ...")

        tmr.alarm(1, 2500, 1, waitForIP)
      end
    end
  else
    print("Error getting AP list")
  end
end	
	
	
for k,v in pairs(l) do
  if k == FileToExecute then
    print("*** You've got 5 sec to stop timer 0 ***")
    tmr.alarm(0, 5000, 0, function()
	
		print("Setting up Wi-Fi...")	
		wifi.setmode(wifi.STATION)
		wifi.sta.getap(connectToNetwork)	
    end)
  end
end
	
    