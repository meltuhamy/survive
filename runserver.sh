#!bin/sh
psql -c "\i database/db.sql"
sh compile.sh
node server.js
