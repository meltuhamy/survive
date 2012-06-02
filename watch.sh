#!bin/sh
coffee --join server.js --compile -b src/*.coffee
while [ 1 = 1 ]
do
    inotifywait -e modify src/*
    coffee --join server.js --compile -b src/*.coffee
    echo modified
done
