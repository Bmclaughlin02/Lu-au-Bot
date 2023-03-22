-- Inital code/main file -- 
local discord = require('discordia')
local client = discord.Client()

file = io.open('config.txt', 'r')
token = file:read()
file:close()

client:on('ready', function()
	print('Logged in as '.. client.user.username)
end)

-- pong me if I ping you
client:on('messageCreate', function(message)
	if message.content == '!ping' then
		message:reply('Pong!')
	end
end)

-- Simple experimental function using message read and if statements
client:on('messageCreate', function(message)
	postBody = message.content:lower()
	isCommand = postBody:sub(1, 1) == '!'

	if not isCommand then
		return
	end

	if postBody:sub(2) == 'hello' then
		message:reply("Hi I am Lu'au Bot")
	end
end)

-- call the token
client:run('Bot ' .. token)
