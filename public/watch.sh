#!bin/sh
~/node_modules/coffee-script/bin/coffee -b --join lib/game.js --compile src/Settings.coffee  src/UserInterface.coffee src/PlayerInput.coffee src/Actions.coffee src/Tile.coffee src/Map.coffee src/Player.coffee src/Game.coffee src/Camera.coffee src/NetworkClient.coffee
while [ 1 = 1 ]
do
    inotifywait -e modify src/*
    ~/node_modules/coffee-script/bin/coffee -b --join lib/game.js --compile src/Settings.coffee  src/UserInterface.coffee src/PlayerInput.coffee src/Actions.coffee src/Tile.coffee src/Map.coffee src/Player.coffee src/Game.coffee src/Camera.coffee src/NetworkClient.coffee
    echo modified
done
