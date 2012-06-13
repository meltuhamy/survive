class Camera
  @scrollx: 0.0
  @scrollxvel: 0.0
  @scrollxacc: 0.0
  @scrolly: 0.0
  @scrollyvel: 0.0
  @scrollyacc: 0.0
  @scrollRegion: 0.15
  @scrollAccConst: 0.14
  @panning: false
  @panDamping: 0.2
  @modes: {followPlayer:0, mouseMove:1, panLocation:2}
  @currentMode: 0

  @updateScroll: =>
    # check if the map is smaller than the canvas, 
    # if it is, then center the camera else, do scrolling
    smallerx = map.fullWidth() < Settings.canvasWidth
    smallery = map.fullHeight() < Settings.canvasHeight
    if(!smallerx || !smallery)
      switch(@currentMode)
        when(@modes.followPlayer)
          @calculatePanLocation(Game.player.posx, Game.player.posy)
          @panScroll()
        when(@modes.mouseMove)
          @mouseScroll()
        when(@modes.panLocation)
          @panScroll()
    @scrollx = -(Settings.canvasWidth-map.fullWidth())/2  if smallerx
    @scrolly = -(Settings.canvasHeight-map.fullHeight())/2 if smallery

  @panScroll: =>
    @scrollx = @panDamping * (@scrollx - @panx) + @panx
    @scrolly = @panDamping * (@scrolly - @pany) + @pany

  @mouseScroll: =>
    @scrollxvel = @scrollxvel * 0.92
    @scrollyvel = @scrollyvel * 0.92
    @scrollx += @scrollxvel
    @scrollxvel += @scrollxacc
    @scrolly += @scrollyvel
    @scrollyvel += @scrollyacc
    # mouse scroll horizontally 
    if (@scrollx < 0)
      @scrollx = 0
      @scrollxvel = 0
      @scrollxacc = 0
    else if (PlayerInput.mousex < Settings.canvasWidth * @scrollRegion)
      @scrollxacc = -@scrollAccConst
    else if (@scrollx > map.fullWidth() - Settings.canvasWidth)
      @scrollx = map.fullWidth() - Settings.canvasWidth 
      @scrollxvel = 0
      @scrollxacc = 0
    else if (PlayerInput.mousex > Settings.canvasWidth * (1 - @scrollRegion))
      @scrollxacc = @scrollAccConst
    else 
      @scrollxacc = 0
    # mouse scroll vertically 
    if(@scrolly < 0)
      @scrolly = 0
      @scrollyvel = 0
      @scrollyacc = 0
    else if (PlayerInput.mousey < Settings.canvasHeight * @scrollRegion)
      @scrollyacc = -@scrollAccConst
    else if (@scrolly > map.fullHeight() - Settings.canvasHeight)
      @scrolly = map.fullHeight() - Settings.canvasHeight 
      @scrollyvel = 0
      @scrollyacc = 0
    else if (PlayerInput.mousey > Settings.canvasHeight * (1 - @scrollRegion))
      @scrollyacc = @scrollAccConst
    else 
      @scrollyacc = 0
      

  @panTo: (x,y) ->
    @currentMode = @modes.panLocation

  @calculatePanLocation: (centerx, centery) ->
    @panx = centerx - Settings.canvasWidth/2;
    @pany = centery - Settings.canvasHeight/2;
    @panx = 0 if @panx < 0
    @pany = 0 if @pany < 0
    @panx = map.fullWidth() - Settings.canvasWidth if (@panx > map.fullWidth() - Settings.canvasWidth)
    @pany = map.fullHeight() - Settings.canvasHeight if (@pany > map.fullHeight() - Settings.canvasHeight)