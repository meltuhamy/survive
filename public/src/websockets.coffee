sendMessageToServer = (message) ->
  socket.send message
  log "<span style=\"color:#888\">Sending \"" + message + "\" to the server!</span>"
log = (message) ->
  li = document.createElement("li")
  li.innerHTML = message
  document.getElementById("message-list").appendChild li
  $('#message-list').prepend(li)

socket = io.connect()
socket.on "connect", ->
  log "<span style=\"color:green;\">Client has connected to the server!</span>"

socket.on "message", (data) ->
  log "Received a message from the server:  " + data

socket.on "disconnect", ->
  log "<span style=\"color:red;\">The client has disconnected!</span>"