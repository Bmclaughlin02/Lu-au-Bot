-- Inital code/main file -- 

local discordia = require('discordia')
local client = discordia.Client()


client:on('ready', function()
	print('Logged in as '.. client.user.username)
end)

-- pong me if I ping you
client:on('messageCreate', function(message)
	if message.content == '!ping' then
		message.channel:send('Pong!')
	end
end)

-- call the token
client:run('Bot ' .. token)