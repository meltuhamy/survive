#!bin/sh
~/node_modules/coffee-script/bin/coffee --join lib/game.js --compile -b src/Settings.coffee  src/UserInterface.coffee src/PlayerInput.coffee src/Actions.coffee src/Tile.coffee src/Map.coffee src/Player.coffee src/Game.coffee src/Camera.coffee src/NetworkClient.coffee && echo "Public compile complete" && cd lib && uglifyjs --overwrite game.js && echo "Public uglify complete"
