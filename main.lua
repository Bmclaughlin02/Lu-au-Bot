-- Inital code/main file -- 
local spawn = require('coro-spawn')
local split = require('coro-split')
local parse = require('url').parse
local discordia = require('discordia')
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
end)

-- call the token
client:run('Bot ' .. token)
