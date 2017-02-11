local wifi = require("wifi")
local tmr = require("tmr")

local app = require("application")
local config = require("config")

local module = {}

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
    print("NOW your static IP is ".. "192.168.1.10")

    app.start()
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

function module.start()
  print("Configuring Wifi ...")
  wifi.setmode(wifi.STATION);
  wifi.sta.getap(connectToNetwork)
end


return module
