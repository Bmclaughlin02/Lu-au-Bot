-- Inital code/main file -- 
local spawn = require('coro-spawn')
local split = require('coro-split')
local parse = require('url').parse
local discordia = require('discordia')
local http = require("socket.http")
local json = require("json")
local ltn12 = require("ltn12")
local client = discordia.Client()

file = io.open('config.txt', 'r')
token = file:read()
file:close()

client:on('ready', function()
	print('Logged in as '.. client.user.username)
end)

client:on('messageCreate', function(message)
	if message.content == '!ping' then
		message:reply('Pong!')
	end

	local forbiddenWords = {'fuck', 'shit', 'ass', 'nigger', 'nigga', 'faggot', 'bitch'}

	for k, v in ipairs(forbiddenWords) do
    		-- Delete the message and send a warning to the sender
		if string.find(message.content:lower(), v) then
    			message:delete()
    			message:reply("Your message was deleted because it contained inappropriate content.")
		end
	end

-- Simple experimental function using message read and if statements

	local postBody = message.content:lower()
	local isCommand = postBody:sub(1, 1) == '!'

	if not isCommand then
		return
	end

	if postBody:sub(2) == 'hello' then
		message:reply("Hi I am Lu'au Bot")
	end

	if postBody:sub(2) == 'weather' then

		-- Prefix reference
		local prefix = "!weather"

		-- The API key for OpenWeatherMap
		local api_key = "26bcda206e3b8a32bf4d8059b163a054"

		-- Gets the weather information from OpenWeatherMap
		function get_weather(city)

			-- URL for the weather information API call
			local url = string.format("http://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s&units=metric", city, api_key)
		
			-- API call and store data in response_body table
			local response_body = {}
			local success, status_code, _, _ = http.request{url = url, method = "GET", headers = {["Content-Type"] = "application/json"},
				sink = ltn12.sink.table(response_body) 
			}

			-- If API call was successful, decode the JSON response 
			if success and status_code == 200 then

				local response = json.decode(table.concat(response_body))

				-- Get the information we need
				local temperature = response.main.temp
				temperature = (temperature * 9/5) + 32 -- convert temp 
				local description = response.weather[1].description

				-- Print the weather forecast
				print(string.format("The weather forecast in %s is showing %s with a temperature of %d degrees Fahrenheit.", city, description, temperature))
			else
				-- Print error message if the API call failed
				print("Failed to fetch weather data.")
			end
		end

		-- Get the city name after command
		local city = message.content:sub(#prefix + 2)

		-- Get the weather forecast for the city
		get_weather(city)
	end
end)

-- call the token
client:run('Bot ' .. token)
