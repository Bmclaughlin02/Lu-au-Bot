# Lu-au-Bot
This was a bot designed as a part of a group project for the class ITCS 4102 Programming Languages at the University of North Carolina Charlotte. The bot was written mostly in Lua and was designed to show of the features of the language and how it worked. 

# Instructions to Run
1) Create your own bot token and add the bot to your server
    - 1a) The token should be written in config.txt
    - 1b) You will need a openweathermap api token as well in pyconf.txt
    - 1c) The bot should be set up as a admin and have all privilaged intents enabled
2) Once that is done you will need to make sure you have enabled devloper mode on your account settings
    - 2a) Go to your user settings
    - 2b) Scroll down and select advanced
    - 2c) Switch on developer mode
3) You will need two channel IDs that are hardcoded for the bot, and in order to get them you will need dev mode enabled
    - 3a) For your choosen VC and bot command chat right click and select copy channel IDs
    - 3b) In main.lua paste those IDs where indicated by the comments
4) In order to run the bot locally Lua, Luvit, and Python need to be installed and added to your system path
    - 4a) https://www.lua.org/download.html
    - 4b) https://luvit.io/install.html
    - 4c) https://www.python.org/downloads/
5) Before running the bot activate the python virtual enviorment by entering into you command prompt "source venv/Scripts/activate"
    - 5a) If you have cloned this from git make sure to install the requirements to the venv after creating it
6) Finally to run the bot type "luvit main.lua" into your command prompt running out of this directory.

If you cloned this from github you will need to add your own music to the src file and write it in to the audioMasterList and make your own
bot token then follow instructions starting from 2. The bot will need privlaged intent to see messages and user joins to work properly.

# Commands and Triggers
These are the commands included with the bot and triggers for automatic responses
- !hello: replies hello
- !ping: replies pong
- !weather <City Name>: Replies with the weather in that city
- !play <Part of song filename>: Plays song in specified VC, song MUST be a mp3 in the src file with its filename in audioMasterList
    *Note, you do not need the full file name in the command, only part of it. The bot will get the first partial matching filename
- !reaction: Posts a random reaction gif or jfif

TRIGGERS:
- When bot is active and user joins bot will post a welcome in specifed text channel
- When a forbidden word is posted bot will delete the message
