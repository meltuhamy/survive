#!bin/sh

while [ 1 = 1 ]
do
    inotifywait -e modify src/game.coffee
    #sh compile.sh
    ~/node_modules/coffee-script/bin/coffee -o lib/ -c src/
    echo modified
done
