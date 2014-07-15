var express = require('express');
var app = express();
var server = require('http').Server(app);
var io = require('socket.io')(server);
var port = process.env.PORT || 3000;

app.use(express.static(__dirname + '/public'));

app.listen(port);
console.log("Express listening on port "+port);


/* Socket IO */

var rooms = {}; // map of room name to creator's id

io.on('connection', function (socket) {
});