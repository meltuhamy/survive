#!bin/sh
coffee --join server.js --compile -b src/*.coffee
cd public && sh compile.sh