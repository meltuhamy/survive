#!bin/sh
~/node_modules/coffee-script/bin/coffee --join server.js --compile -b src/*.coffee && echo "Server compile complete" && uglifyjs --overwrite server.js && echo "Server uglify complete" && cd public && sh prepare-deploy.sh && echo "Ready to deploy"
