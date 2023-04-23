-- Inital code/main file -- 
local split = require('coro-split')
local discordia = require('discordia')
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
	end
		
	if command[1] == 'play' then
		local audio = command[2]
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
end)

-- call the token
client:run('Bot ' .. token)
