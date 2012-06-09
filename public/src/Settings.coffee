class Settings
	@assetDir = 'assets'
	@terrainDir = "#{@assetDir}/terrain"
	@itemDir = "#{@assetDir}/items"
	@spriteDir = "#{@assetDir}/sprites"
	@tileWidth = 25
	@tileHeight = 25
	@canvasWidth = 900
	@canvasHeight = 450
	@numRows = 20
	@numCols = 30
	@fullWidth = @tileWidth*@numCols
	@fullHeight = @tileHeight*@numRows
	@canvasIDName = 'canvas'
	@canvasIDElement = "##{@canvasIDName}"
