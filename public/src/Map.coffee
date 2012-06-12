class Grid
        constructor: (@mapArray, @numrows, @numcols) ->
        mapArray: []
        numrows: 0
        numcols: 0

        gridIndex: (x,y) -> y*@numcols + x
        getElement: (row,col) -> @mapArray[@gridIndex(row,col)]
        setElement: (row,col,item) -> @mapArray[@gridIndex(row,col)] = item

class Map
        tileArray: [0,new GrassTile(), new FireTile(), new HillTile(), new ShallowWaterTile(), new DeepWaterTile(), 
                    new TreeTile() , new HoleTrapTile(), new BoobyTrapTile(), new PoisonWaterTile(), new PoisonDeepWaterTile()]
        TileType: {none:0, grass:1, fire:2, hill:3, shallowWater: 4, deepWater:5, tree:6, holeTrap:7, boobyTrap:8, poisonWater:9, poisonDeepWater:10}
        itemArray: [0, new WaterBottle(), new Shovel(), new Log(), new Axe(), new Torch(), new Poison(), new Chicken(), new Berries(), new PoisonBerries(), new EmptyBottle()]
        ItemType: {none:0,waterBottle:1,shovel:2,log:3,axe:4,torch:5,poison:6,chicken:7,berries:8,poisonBerries:9,emptyBottle:10}
        constructor: (@tileGrid, @itemGrid) ->
                @tileGridOriginal = new Grid([],@tileGrid.numrows,@tileGrid.numcols)
                @itemGridOriginal = new Grid([],@itemGrid.numrows,@itemGrid.numcols)
                @tileGridOriginal.mapArray = @tileGrid.mapArray[..]
                @itemGridOriginal.mapArray = @itemGrid.mapArray[..]
                if @tileGrid.numrows != @itemGrid.numrows or @tileGrid.numcols != @itemGrid.numcols then console.warn 'Sizes of grids dont match'
        getTileElement: (row, col) -> @tileGrid.getElement(row,col)
        getItemElement: (row, col) -> @itemGrid.getElement(row,col)

        setTileElement: (row, col, tile, broadcast) -> 
                @tileGrid.setElement(row,col,tile)
                if !broadcast? || (broadcast? && broadcast)
                        NetworkClient.sendTileData {id: Game.player.id, roomNumber:Game.player.roomNumber, tilex: row, tiley: col, tileNumber: tile}
                                                  
        setItemElement: (row, col, item, broadcast) -> 
                @itemGrid.setElement(row,col,item)
                if !broadcast? || (broadcast? && broadcast)
                        NetworkClient.sendItemData {id: Game.player.id, roomNumber:Game.player.roomNumber, tilex: row, tiley: col, itemNumber: item}

        getTile: (row, col) -> @tileArray[@getTileElement(row,col)]
        getItem: (row, col) -> @itemArray[@getItemElement(row,col)]
        getItemFromNumber: (index) -> @itemArray[index]

        getLeftPixel: (row, col) -> row*25
        getRightPixel: (row, col) -> (row+1)*25-1
        getTopPixel: (row, col) -> col*25
        getBottomPixel: (row, col) -> (col+1)*25-1

        removeItem: (row,col) -> @setItemElement row, col, 0, true
        noItem: (row,col) -> @itemGrid.getElement(row,col) == 0

        inBounds: (col,row) -> (row >= 0) && (row < @tileGrid.numrows) && (col >= 0) && (col < @tileGrid.numcols)

        getActions: (x,y) ->
                tileactions = @getTile(x, y).actions
                menuactions = if @noItem(x,y) then [] else @getItem(x, y).actions
                menuactions = menuactions.concat(tileactions)
                return menuactions
        restore: -> 
                @tileGrid.mapArray = @tileGridOriginal.mapArray[..] #copies an array physically
                @itemGrid.mapArray = @itemGridOriginal.mapArray[..]


if(Settings.DEBUGMODE)
        map0 =  [1,2,3,4,5,6,7,8,9,6,7,8,9,4,4,4,5,5,5,5,5,5,5,5,5,5,3,3,3,3,1,1,1,1,1,1,1,3,3,3,4,4,4,4,4,4,5,5,1,1,1,1,1,1,3,5,3,3,3,3,1,1,1,1,1,1,1,3,3,4,4,3,3,4,4,5,5,5,1,1,1,3,3,3,5,5,3,1,1,3,1,1,1,1,1,1,1,1,4,4,3,3,3,3,3,5,5,5,5,3,3,3,3,5,5,1,1,1,1,3,1,1,1,1,1,1,1,1,4,4,1,3,3,3,3,3,3,3,3,3,3,5,5,1,1,1,1,4,4,3,1,1,1,1,1,1,1,1,1,4,4,1,1,3,3,3,3,3,1,1,1,1,1,1,1,1,1,4,4,3,1,1,1,1,1,1,1,1,1,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,3,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,3,3,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,3,1,3,3,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,1,1,3,1,3,3,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,1,3,3,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,3,3,3,3,3,1,1,1,1,3,3,1,1,1,1,1,1,1,4,4,4,4,4,5,5,5,5,5,1,1,3,3,3,3,3,3,3,1,1,1,3,3,1,1,1,1,1,1,1,1,4,4,4,5,5,5,5,5,5,1,3,3,4,4,3,3,2,3,1,3,1,3,1,1,1,1,1,1,1,5,5,5,5,5,5,5,5,5,5,1,3,3,4,4,3,3,2,1,3,3,1,1,1,1,1,1,5,5,5,5,5,5,5,5,5,5,5,5,5,5,3,3,4,4,3,3,2,2,1,1,1,1,1,1,1,1,5,5,5,5,5,5,5,5,5,5,5,5,5,5,3,3,3,3,3,3,2,2,1,1,1,1,1,1,1,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,5,5,5,5,5,5,5,5,5,5,5,3]
        item0 = [8, 1, 3, 5, 4, 5, 6, 7, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        mapwidth = 20
        mapheight = 30
        map = new Map(new Grid(map0, mapwidth, mapheight), new Grid(item0, mapwidth, mapheight))
