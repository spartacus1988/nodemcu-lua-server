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