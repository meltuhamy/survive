#!bin/sh

while [ 1 = 1 ]
do
    inotifywait -e modify src/*
    ~/node_modules/coffee-script/bin/coffee -o lib/ -c src/
    echo modified
done
