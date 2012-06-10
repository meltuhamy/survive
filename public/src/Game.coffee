class Game
  @gamestarted: false
  @gameloaded: false
  @player: new Player()
  @opponents: []
  @vision1 = [{x:0,y:0}, {x:1,y:0}, {x:0,y:1}, {x:-1,y:0}, {x:0,y:-1}]
  @vision2 = [{x:0,y:0},{x:-1,y:-1},{x:0,y:-1},{x:1,y:-1},{x:1,y:0},{x:1,y:1},{x:0,y:1},{x:-1,y:1},{x:-1,y:0},{x:-2,y:0},{x:0,y:-2},{x:0,y:2},{x:2,y:0}]
  @replayData = []
  @replayGameTick = 0
  @mainLoopIntervalId = 0
  @replayLoopIntervalId = 0
  @DEBUGMODE = on
  @filterImage = new Image()
  @filterImage.onload = => @filterReady = true
  @filterImage.src = "#{Settings.assetDir}/filter.png"
  @filterReady = false
  @count = 0
  @mapLayer = null
  @itemLayer = null
  @playerLayer = null
  @hoverSelectBox = null
  @hoverSelectLayer = null
  @onload: =>
    Settings.canvasWidth = $("##{Settings.canvasIDName}").width()
    Settings.canvasHeight = $("##{Settings.canvasIDName}").height()
    @gameloaded = true
    @createStage()

    $(document.documentElement).keyup (evt) ->
      PlayerInput.onKeyUp(evt)

    $(document.documentElement).keydown (evt) ->
      PlayerInput.onKeyDown(evt)

    $("##{Settings.canvasIDName}").mousemove (evt) ->
      PlayerInput.onMouseMove(evt, @)


    $("#dialog").dialog({
      autoOpen: false
    });
    $("#message-list").dialog({
      autoOpen: true,
      height: 530
    });
    $('#inventorymenu').hide()
    $('#actionmenu').fadeOut()
    if(!@DEBUGMODE)
      $('.game').hide();
  @announce: (content) => 
    $('#playerAnnouncementList').prepend("<li class=\"playerAnnouncement\">#{content}</li>")
    if($('.playerAnnouncement').length >= Settings.MAXANNOUNCEMENTS)
      $('.playerAnnouncement').last().remove()
    else
      $('#playerAnnouncements').css('margin-top', '-=25')
  @createStage : =>  
    # Map layer
    @mapLayer = new Kinetic.Layer()

    # Current square select layer
    @hoverSelectLayer = new Kinetic.Layer()
    @hoverSelectBox = new Kinetic.Rect(
      fill: 'yellow'
      width: Settings.tileWidth
      height: Settings.tileHeight
      alpha: 0.6
    )
    @hoverSelectLayer.add @hoverSelectBox

    # Item layer
    @itemLayer = new Kinetic.Layer()

    # Player layer
    @playerLayer = new Kinetic.Layer()

    # Create the kinetic stage
    @stage = new Kinetic.Stage(
      container: Settings.canvasIDName
      width: Settings.canvasWidth
      height: Settings.canvasHeight
    )

    # Add the layers to the stage
    @stage.add @mapLayer
    @stage.add @hoverSelectLayer
    @stage.add @itemLayer
    @stage.add @playerLayer

  @start = (allplayers) =>
    @setOpponents allplayers
    @gamestarted = true
    NetworkClient.sendPlayerData()
    $("#lobby").fadeOut()
    $(".game").fadeIn()


  @spawnPlayer = (spawnData) ->
    @player = new Player(spawnData.id, spawnData.roomNumber)
    @player.tilex = spawnData.tilex
    @player.tiley = spawnData.tiley

  @setOpponents = (players) =>
    @opponents = []
    @opponents.push new Player(p.id, p.roomNumber) for p in players when p.id isnt @player.id

  @removePlayerFromArray = (id) ->
    @opponents.splice @getPlayerIndexById(id), 1

  @getPlayerIndexById = (id) ->
    ids = []
    ids.push p.id for p in @opponents
    return ids.indexOf(id)

  @render = =>
    mapContext = @mapLayer.getContext() # get map
    mapContext.fillStyle = "#000000" 
    mapContext.fillRect(0,0,Settings.canvasWidth,Settings.canvasHeight) # fill map black
    itemContext = @itemLayer.getContext() # get drawing context for item layer
    @itemLayer.clear()
    playerContext = @playerLayer.getContext() # get drawing context for item layer
    @playerLayer.clear()
    
    # for every grid location
    for y in [0...map.tileGrid.numrows]
      for x in [0...map.tileGrid.numcols]
        # if the corresponding tile is loaded
        if (map.getTile(x,y).tileReady)
          # draw the image on the map in the position relative to map scroll
          mapContext.drawImage map.getTile(x,y).tileImage, x*Settings.tileWidth-Camera.scrollx, y*Settings.tileHeight-Camera.scrolly
          if (@filterReady)
              mapContext.drawImage @filterImage, x*Settings.tileWidth-Camera.scrollx, y*Settings.tileHeight-Camera.scrolly

    # for every grid location in our vision
    for v in @vision2
      visionx = @player.tilex+v.x
      visiony = @player.tiley+v.y 
      if(map.inBounds(visionx,visiony))
        # overwrite the grayed out tile with a full brightness map tile
        mapContext.drawImage map.getTile(visionx,visiony).tileImage, visionx*Settings.tileWidth-Camera.scrollx, visiony*Settings.tileHeight-Camera.scrolly
        # draw any items in our view
        if !map.noItem(visionx,visiony) 
          itemContext.drawImage map.getItem(visionx,visiony).tileImage, visionx*Settings.tileWidth-Camera.scrollx, visiony*Settings.tileHeight-Camera.scrolly
        # draw other players that are in our view
        for p in @opponents
          if (p.tilex == visionx && p.tiley == visiony)
            playerContext.drawImage @player.playerImage, visionx*Settings.tileWidth-Camera.scrollx, visiony*Settings.tileHeight-Camera.scrolly if @player.imgReady

    # draw the yellow square for the tile the player is currently standing on
    @hoverSelectBox.setX @player.tilex*Settings.tileWidth - Math.floor(Camera.scrollx)
    @hoverSelectBox.setY @player.tiley*Settings.tileHeight - Math.floor(Camera.scrolly)
    @hoverSelectLayer.draw()

    # draw the player that the client is controlling
    playerContext.drawImage @player.playerImage, @player.posx-Camera.scrollx, @player.posy-Camera.scrolly if @player.imgReady



  @update = (modifier) =>
    # draw onto the blue debug bar at the top of the game
    $('.debugbar').html("inventory = #{@player.inventory}, @player.tilex = #{@player.tilex}, @player.tiley = #{@player.tiley} \n
      health = #{@player.health}, stamina = #{@player.stamina}, hunger = #{@player.hunger}, thirst = #{@player.thirst}")
    # call update methods
    if(@gamestarted || @DEBUGMODE)
      @player.update()
      Camera.updateScroll()


  @replayGameRender = =>
    mapContext = @mapLayer.getContext() # get map
    mapContext.fillStyle = "#000000" 
    mapContext.fillRect(0,0,Settings.canvasWidth,Settings.canvasHeight) # fill map black
    itemContext = @itemLayer.getContext() # get drawing context for item layer
    @itemLayer.clear()
    playerContext = @playerLayer.getContext() # get drawing context for item layer
    @playerLayer.clear()
    # for every grid location
    for y in [0...map.tileGrid.numrows]
      for x in [0...map.tileGrid.numcols]
        # if the corresponding tile is loaded
        if (map.getTile(x,y).tileReady)
          # draw the image on the map in the position relative to map scroll
          mapContext.drawImage map.getTile(x,y).tileImage, x*Settings.tileWidth-Camera.scrollx, y*Settings.tileHeight-Camera.scrolly
          if !map.noItem(x,y)
             itemContext.drawImage map.getItem(x,y).tileImage, x*Settings.tileWidth-Camera.scrollx, y*Settings.tileHeight-Camera.scrolly
    playerContext.drawImage @player.playerImage, @player.posx-Camera.scrollx, @player.posy-Camera.scrolly if @player.imgReady
    for p in @opponents
      playerContext.drawImage @player.playerImage, p.tilex*Settings.tileWidth-Camera.scrollx, p.tiley*Settings.tileHeight-Camera.scrolly if @player.imgReady


  @replayGameUpdate = =>
    if @replayGameTick < @replayData.length
      replay = @replayData[@replayGameTick]
      console.log "Replaying row #{@replayGameTick}:"
      console.log replay
      switch @replayData[@replayGameTick].type
        when "t"
          map.setTileElement replay.tilex, replay.tiley, replay.value, false
        when "i"
          map.setItemElement replay.tilex, replay.tiley, replay.value, false
        when "p"
          if replay.socketid != @player.id
            playerindex = @getPlayerIndexById(replay.socketid)
            @opponents[playerindex].tilex = replay.tilex
            @opponents[playerindex].tiley = replay.tiley
          else
            @player.posx = replay.tilex*Settings.tileWidth
            @player.posy = replay.tiley*Settings.tileHeight
            @player.tilex = Math.floor((@player.posx+12.5) / 25);
            @player.tiley = Math.floor((@player.posy+12.5) / 25);
      @replayGameTick++

  @gameReplay = (receivedReplayData) ->
    clearInterval @replayLoopIntervalId
    map.restore()
    @replayData = receivedReplayData
    clearInterval @mainLoopIntervalId
    @replayLoopIntervalId = setInterval @replayLoop, 40



  @mainLoop = =>
    now = Date.now()
    delta = now - then_
    @update delta / 1000
    @render()
    then_ = now
    if @count == 100
        @player.decrement()
        @count = 0
    @count += 1
  then_ = Date.now()

  @beginMainLoop = =>
    @mainLoopIntervalId = setInterval @mainLoop, 10

  @replayLoop = =>
    @replayGameRender()
    @replayGameUpdate()




