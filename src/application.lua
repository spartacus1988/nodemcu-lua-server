local net = require("net")
local wifi = require("wifi")

local config = require("config")

local module = {}



local homepage = [[
  <!DOCTYPE HTML>
  <html>
    <head>
      <meta content="text/html; charset=utf-8">
      <title>ESP8266</title>
      <style type="text/css">
        html, body {
          min-height: 100%;
        }
        body {
          font-family: monospace;
          background: url(http://i.imgur.com/rqJrop4.gif) no-repeat 0 0 #5656fa;
          background-size: cover;
          margin: 0;
          padding: 10px;
          text-align: center;
          color: #56f2ff;
        }
      </style>
    </head>
    <body>
      NodeMCU Server
    </body>
  </html>
]]


local function runServer()

	local s = net.createServer(net.TCP)

	print("====================================")
	print("Server Started")
	print("Open " .. wifi.sta.getip() .. " in your browser")
	print("====================================")

	s:listen(
		config.PORT, function(connection)
			connection:on(
				"receive", function(c, request)
				print(request)
				--print("THIS_CLIENT")
				--print(c)
				--  c:send(homepage)
				--end)
	
				local buf = "";
				local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
												
				if(method == nil)then
								_, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
				end
												
				local _GET = {}
				
				if (vars ~= nil)then
								for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
								_GET[k] = v
								end
				end
				
				
				
				buf = buf.."<h1> ESP8266 Web Server</h1>";
				buf = buf.."<p><tr><td>MAC : <b>"..wifi.sta.getmac().."</b></td></tr></p>";
				buf = buf.."<p><tr><td>Uptime : <b>"..tmr.time().."</b></td></tr></p>";
				buf = buf.."<p><tr><td>Heap : <b>"..node.heap().."</b></td></tr></p>";
				
				buf = buf.."<p>GPIO0 <a href=\"?pin=ON1\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF1\"><button>OFF</button></a></p>";
				
				--someFunc()
				AOvar = adc.read(0);
				AOvar = AOvar * 3130;
				AOvar = AOvar / 1024;
				--buf = buf.."<p class=\"temp\">"..string.format("%04d", AOvar).."</p>" 
				buf = buf.."<p><tr><td>AO : <b>"..string.format("%04d", AOvar).."</b></td></tr></p>";
				
				
				local _on,_off = "",""
				gpio.mode(4, gpio.OUTPUT)	--LED
				gpio.mode(1, gpio.OUTPUT)	--RELAY
												
				if(_GET.pin == "ON1")then
									gpio.write(1, gpio.HIGH);
				elseif(_GET.pin == "OFF1")then
									gpio.write(1, gpio.LOW);
				end
				
				c:send(buf);
				c:close();
				collectgarbage();
			end)
			connection:on("sent", function(c) c:close() end)
	end)
	
	
end


function module.start()
  runServer()
end

return module
