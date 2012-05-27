#!bin/sh

while [ 1 = 1 ]
do
    inotifywait -e modify src/*
    ~/node_modules/coffee-script/bin/coffee -b --join lib/game.js --compile src/actions.coffee src/Tile.coffee src/Map.coffee  src/mod_game.coffee
    echo modified
done
