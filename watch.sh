#!bin/sh

while [ 1 = 1 ]
do
    inotifywait -e modify src/*
    ~/node_modules/coffee-script/bin/coffee --join lib/game.js --compile src/Map.coffee src/actions.coffee src/Tile.coffee src/mod_game.coffee
    echo modified
done
