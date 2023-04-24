-- Inital code/main file -- 
local split = require('coro-split')
local discordia = require('discordia')
local client = discordia.Client()
local e = discordia.enums.gatewayIntent
client:enableIntents(e.guildMembers, e.guildPresences, e.messageContent)

file = io.open('config.txt', 'r')
token = file:read()
file:close()

-- Split contributed by Jon, need to break up and return array of commands
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

function getAudio(audio)
	local audioFile = nil
	local masterList = io.open(".//src//audioMasterList.txt")

	if masterList ~= nil then
		for line in masterList:lines() do
			if string.find(line, audio) then
				audioFile = line .. ".mp3"
			end
		end
	end

	return './/src//'..audioFile
end

-- Contributed by Rachel
client:on('ready', function()
	print('Logged in as '.. client.user.username)
end)

client:on('memberJoin', function(member)
	print('I am being called properly')
    local WelcomeMessage = string.format("Hello %s, Welcome to our server!", member.username)
	-- COPY BOT COMMAND CHANNEL ID HERE IN THE getChannel FIELD
    client:getChannel('1099767452495249428'):send(WelcomeMessage)
end)

client:on('messageCreate', function(message)
	if message.content == '!ping' then
		message:reply('Pong!')
	end

	--This was contributed by Darius
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
	end
		
	-- Command contributed by Brennan McLaughlin
	if command[1] == 'play' then
		local audio = command[2]
		-- COPY VC FOR MUSIC COMMANDS HERE IN THE getChannel FIELD
		local channel  = client:getChannel('1077675032370745520')
		local connection = channel:join()
		print('making call to get audio')
		local stream = getAudio(audio)
		print(stream)
		if stream ~= nil then
			connection:playFFmpeg(stream)
		else
			message:reply("There was a problem playing the file, either it does not exist or it was not added to the masterList")
		end
	end

	-- Contributed by Aiden
	if command[1] == 'weather' then
		local city = command[2]
		os.execute('python weather.py ' .. city)

		while true do
			if fileExists('report.txt') then
				break
			else
				local start = os.time()
				repeat until os.time() > start + 0.125
			end
		end

		message:reply({file = 'report.txt'})
	end

	-- Method contributed by Nykyta
	if command[1] == 'reaction' then
		local x = math.random(10)
		local randImage = ""

		if x == 0 then
			randImage = "1.gif"
		elseif x == 1 then
			randImage = "2.jfif"
		elseif x == 2 then
			randImage = "3.gif"
		elseif x == 3 then
			randImage = "4.gif"
		elseif x == 4 then
			randImage = "5.jpg"
		elseif x == 5 then
			randImage = "6.jfif"
		elseif x == 6 then
			randImage = "7.jfif"
		elseif x == 7 then
			randImage = "8.gif"
		elseif x == 8 then
			randImage = "9.gif"
		elseif x == 9 then
			randImage = "10.gif"
		elseif x == 10 then
			randImage = "11.gif"
		end

		message:reply({file = './/src//reactions//'..randImage})
	end
end)

-- call the token
client:run('Bot ' .. token)
