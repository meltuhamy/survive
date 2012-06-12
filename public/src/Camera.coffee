class Camera
  @scrollx: 0.0
  @scrollxvel: 0.0
  @scrollxacc: 0.0
  @scrolly: 0.0
  @scrollyvel: 0.0
  @scrollyacc: 0.0
  @scrollRegion: 0.15
  @scrollAccConst: 0.12

  @updateScroll: =>
   @scrollxvel = @scrollxvel * 0.92
   @scrollyvel = @scrollyvel * 0.92
   @scrollx += @scrollxvel
   @scrollxvel += @scrollxacc
   @scrolly += @scrollyvel
   @scrollyvel += @scrollyacc
   if (Settings.canvasWidth < map.fullWidth())
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
   else 
     @scrollx = -(Settings.canvasWidth-map.fullWidth())/2  
   if (Settings.canvasHeight < map.fullHeight())
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
   else 
    @scrolly = -(Settings.canvasHeight-map.fullHeight())/2
   mouseSquarex = Math.floor(PlayerInput.mousex / Settings.tileWidth)
   mouseSquarey = Math.floor(PlayerInput.mousey / Settings.tileHeight)