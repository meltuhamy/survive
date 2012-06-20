class Game
  @gamestarted: false
  @gameloaded: false
  @player: new Player()
  @opponents: []
  @vision1 = [{x:0,y:0}, {x:1,y:0}, {x:0,y:1}, {x:-1,y:0}, {x:0,y:-1}]
  @vision2 = [{x:0,y:0},{x:-1,y:-1},{x:0,y:-1},{x:1,y:-1},{x:1,y:0},{x:1,y:1},{x:0,y:1},{x:-1,y:1},{x:-1,y:0},{x:-2,y:0},{x:0,y:-2},{x:0,y:2},{x:2,y:0}]
  @vision3 = [{x:0,y:0},{x:-1,y:-1},{x:0,y:-1},{x:1,y:-1},{x:1,y:0},{x:1,y:1},{x:0,y:1},{x:-1,y:1},{x:-1,y:0},{x:-2,y:0},{x:0,y:-2},{x:0,y:2},{x:2,y:0},
              {x:1,y:-2},{x:2,y:-1},{x:2,y:1},{x:1,y:2},{x:-1,y:2},{x:-2,y:1},{x:-2,y:-1},{x:-1,y:-2}]
  @replayData = []
  @replayGameTick = 0
  @mainLoopIntervalId = 0
  @replayLoopIntervalId = 0
  @filterImage = new Image()
  @filterImage.onload = => @filterReady = true
  @filterImage.src = "#{Settings.assetDir}/filter.png"
  @filterReady = false
  @count = 0
  @count2 = 0
  @announcementCounter = 0
  @mapLayer = null
  @itemLayer = null
  @playerLayer = null
  @hoverSelectBox = null
  @hoverSelectLayer = null

  @onload: =>
    $('.actionmenu').hide()
    @gameloaded = true
    @createStage()

    $(document.documentElement).keyup (evt) ->
      PlayerInput.onKeyUp(evt)

    $(document.documentElement).keydown (evt) ->
      PlayerInput.onKeyDown(evt)

    $("##{Settings.canvasIDName}").mousemove (evt) ->
      PlayerInput.onMouseMove(evt, @)
    if(!Settings.DEBUGMODE)
      $('.game').hide();

  @announce: (content) =>
    if $('.playerAnnouncement').length == 0 then $('#playerAnnouncements').css('margin-top', '0px')
    $('#playerAnnouncementList').prepend($("<li class=\"playerAnnouncement\">#{content}</li>").hide().fadeIn(150))
    $('#playerAnnouncements').css('margin-top', '-=25')
    if($('.playerAnnouncement').length >= Settings.MAXANNOUNCEMENTS)
      $('.playerAnnouncement').last().fadeOut 300, -> 
        $('.playerAnnouncement').remove()
        $('#playerAnnouncements').css('margin-top', '+=25')
  @reduceAnnouncementNext = false
  @reduceList = []
  @reduceInSeconds = 0
  @reduceAnnouncements: ->
    #console.log "Removing announcements"
    if $('.playerAnnouncement').length == 0 then $('#playerAnnouncements').css('margin-top', '0px')
    @reduceList.push $('.playerAnnouncement').last()
    if(@reduceList.length >=1)
      reduceItem = @reduceList.pop()
      $(reduceItem).last().fadeOut 300, -> 
        $('.playerAnnouncement').remove()
        $('#playerAnnouncements').css('margin-top', '+=25')
        @announcementCounter = 0
    ###if(@reduceAnnouncementNext)
      console.log "Time to remove an announcement!"
      @reduceAnnouncementNext = false
      #Get rid of the last (i.e. li:last) announcement made)
      $('.playerAnnouncement').last().fadeOut 300, -> 
        $('.playerAnnouncement').remove()
        $('#playerAnnouncements').css('margin-top', '+=25')
    else
      #There's a new announcement(s) since the last check!
      if($('.playerAnnouncement').length >= 1) then @reduceAnnouncementNext = true
    ###
  @createStage: =>  
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
    createTextEffects(@stage)


  @playerImages: [[],[],[],[],[],[],[],[],[]]

  @loadPlayerImages: =>
    for folder in [0..8]
      baseSource = "#{Settings.spriteDir}" + folder + "\\"
      for direction in [0..3]
        @playerImages[folder].push(new Image())
        @playerImages[folder][direction].src = baseSource + "sprite#{direction}.png"
        @playerImages[folder][direction].isReady = false
        @playerImages[folder][direction].onload = ->
          @isReady = true

  @start = (allplayers) =>
    @loadPlayerImages()
    @setOpponents allplayers
    $("#lobby").fadeOut(1000, Game.lobbyFadedOut)

  @lobbyFadedOut = =>
    @gamestarted = true
    $(".game").fadeIn(1000, Game.startGameplay)

  @startGameplay = =>
    showFightText()
    NetworkClient.sendPlayerData()

  @spawnPlayer = (spawnData) ->
    @player = new Player(spawnData.id, spawnData.roomNumber)
    @player.tilex = spawnData.tilex
    @player.tiley = spawnData.tiley

  @setOpponents = (players) =>
    @opponents = []
    @opponents.push new Player(p.id, p.roomNumber) for p in players when p.id isnt @player.id

  @removeAliveOpponent = (id) ->
    @opponents[@getPlayerIndexById(id)].alive = false

  @getPlayerIndexById = (id) ->
    ids = []
    ids.push p.id for p in @opponents
    return ids.indexOf(id)

  @opponentDisconnect = (id) ->
    @removeAliveOpponent(id)

  @opponentDeath = (deathData) ->
    @removeAliveOpponent(deathData.id)

  @render = =>
    if (!@gamestarted && !Settings.DEBUGMODE) then return
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
    for v in @vision3
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
          if (p.tilex == visionx && p.tiley == visiony && p.alive)
            playerContext.drawImage @playerImages[p.spriteNumber][p.direction], visionx*Settings.tileWidth-Camera.scrollx, visiony*Settings.tileHeight-Camera.scrolly if @player.imgReady()

    # draw the yellow square for the tile the player is currently standing on
    @hoverSelectBox.setX @player.tilex*Settings.tileWidth - Math.floor(Camera.scrollx)
    @hoverSelectBox.setY @player.tiley*Settings.tileHeight - Math.floor(Camera.scrolly)
    @hoverSelectLayer.draw()

    # draw the player that the client is controlling
    playerContext.drawImage @player.playerImage, @player.posx-Camera.scrollx, @player.posy-Camera.scrolly if @player.imgReady()



  @update = (modifier) =>
    # draw onto the blue debug bar at the top of the game
    #$('.debugbar').html("inventory = #{@player.inventory}, @player.tilex = #{@player.tilex}, @player.tiley = #{@player.tiley} \n
    #  health = #{@player.stats.health}, stamina = #{@player.stats.stamina}, hunger = #{@player.stats.hunger}, thirst = #{@player.stats.thirst}")
    # call update methods
    if(@gamestarted || Settings.DEBUGMODE)
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
    playerContext.drawImage @player.playerImage, @player.posx-Camera.scrollx, @player.posy-Camera.scrolly if @player.imgReady()
    for p in @opponents
      playerContext.drawImage @playerImages[p.spriteNumber][p.direction], p.tilex*Settings.tileWidth-Camera.scrollx, p.tiley*Settings.tileHeight-Camera.scrolly if @player.imgReady()
   

  @replayGameUpdate = =>
    if @replayGameTick < @replayData.length
      replay = @replayData[@replayGameTick]
      #console.log "Replaying row #{@replayGameTick}:"
      #console.log replay
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
    if @gamestarted
      @update delta / 1000
      if Game.player.stats.health <= 0 or NetworkClient.winnerRecieved then @replayGameRender() else @render()
      Camera.updateScroll()
      if @announcementCounter == 100
        @reduceAnnouncements()
      @announcementCounter++
      if @count == 100
        @player.decrement()
        @count = 0
      @count += 1
    then_ = now
  then_ = Date.now()

  @beginMainLoop = =>
    @mainLoopIntervalId = setInterval @mainLoop, 30

  @replayLoop = =>
    @replayGameRender()
    @replayGameUpdate()




