#!bin/sh
~/node_modules/coffee-script/bin/coffee --join server.js --compile -b src/*.coffee
cd public && sh compile.sh
