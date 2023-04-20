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

function split(input, sep)
	local t = {}

	-- If no seperator specified uses spaces
	if sep == nil then
		sep = '%s'
	end
	-- Iterates through return from gmatch and loads them into the return table
	for str in string.gmatch(input, '([^'..sep..']+)') do
		table.insert(t, str)
	end

	return t
end

function fileExists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end

function getVideo(vid)
	audioFile = 'audio.mp3'

	print('Fetching video')
	if fileExists(audioFile) then
		os.remove(audioFile)
		os.remove('fetch.txt')
	end

	os.execute("powershell -file downloader.ps1" .. vid)

	while true do
		print('downloading...')
		if fileExists(audioFile) then
			break
		else
			local start = os.time()
			repeat until os.time() > start + 0.125
		end
	end

	print('Done')
	return audioFile
end

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
	postBody = postBody:sub(2)

	if not isCommand then
		return
	end

	print(postBody)
	local command = split(postBody, ' ')

	if command[1] == 'hello' then
		message:reply("Hi I am Lu'au Bot")
	elseif command[1] == 'play' then
		table.remove(command, 1)
		local vid = table.concat(command, ' ')
		local vc = client:getChannel('1077675032370745520')
		local connection = vc:join()
		print('making call to get video')
		local stream = getVideo(vid)
		coroutine.wrap(function()
			connection:playFFmpeg(stream)
		end)()

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
