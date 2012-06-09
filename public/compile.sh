#!bin/sh
~/node_modules/coffee-script/bin/coffee -b --join lib/game.js --compile src/UserInterface.coffee src/PlayerInput.coffee src/Settings.coffee src/Actions.coffee src/Tile.coffee src/Map.coffee src/Player.coffee src/Game.coffee src/Camera.coffee src/NetworkClient.coffee
