-- Inital code/main file -- 
local discord = require('discordia')
local client = discord.Client()

file = io.open('config.txt', 'r')
token = file:read()
file:close()

client:on('ready', function()
	print('Logged in as '.. client.user.username)
	print('Bot token ' .. token)
end)

-- pong me if I ping you
client:on('messageCreate', function(message)
	if message.content == '!ping' then
		print('Bug test, message was read')
		message:reply('Pong!')
	end
end)

-- call the token
client:run('Bot ' .. token)
