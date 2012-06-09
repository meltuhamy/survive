#!bin/sh
~/node_modules/coffee-script/bin/coffee -b --join lib/game.js --compile src/UserInterface.coffee src/Settings.coffee src/Actions.coffee src/Tile.coffee src/Map.coffee src/Player.coffee src/PlayerInput.coffee src/Game.coffee src/Camera.coffee src/NetworkClient.coffee 
while [ 1 = 1 ]
do
    inotifywait -e modify src/*
    ~/node_modules/coffee-script/bin/coffee -b --join lib/game.js --compile src/UserInterface.coffee src/Settings.coffee src/Actions.coffee src/Tile.coffee src/Map.coffee src/Player.coffee src/PlayerInput.coffee src/Game.coffee src/Camera.coffee src/NetworkClient.coffee 
    echo modified
done
