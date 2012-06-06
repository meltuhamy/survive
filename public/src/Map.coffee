class Grid
        constructor: (@mapArray, @numrows, @numcols) ->
        mapArray: []
        numrows: 0
        numcols: 0

        gridIndex: (x,y) -> y*@numcols + x
        getElement: (row,col) -> @mapArray[@gridIndex(row,col)]
        setElement: (row,col,item) -> @mapArray[@gridIndex(row,col)] = item

class Map
        tileArray: [new GrassTile(), new FireTile(), new HillTile(), new ShallowWaterTile(), new DeepWaterTile(), 
                    new TreeTile() , new HoleTrapTile(), new BoobyTrapTile(), new PoisonWaterTile(), new PoisonDeepWaterTile()]
        itemArray: [0, new GreenHelm(), new WaterBottle(), new Shovel(), new Log(), new Axe(), new Torch(), new Poison()]
        constructor: (@tileGrid, @itemGrid) ->
                @tileGridOriginal = new Grid([],@tileGrid.numrows,@tileGrid.numcols)
                @itemGridOriginal = new Grid([],@itemGrid.numrows,@itemGrid.numcols)
                @tileGridOriginal.mapArray = []
                @tileGridOriginal.mapArray.push arrayitem for arrayitem in @tileGrid.mapArray
                @itemGridOriginal.mapArray = []
                @itemGridOriginal.mapArray.push arrayitem for arrayitem in @itemGrid.mapArray
                if @tileGrid.numrows != @itemGrid.numrows or @tileGrid.numcols != @itemGrid.numcols then console.log 'Sizes of grids dont match'
        getTileElement: (row, col) -> @tileGrid.getElement(row,col)
        getItemElement: (row, col) -> @itemGrid.getElement(row,col)

        setTileElement: (row, col, tile, broadcast) -> 
                @tileGrid.setElement(row,col,tile)
                if !broadcast? || (broadcast? && broadcast)
                        sendTileData {id: player.id, roomNumber:player.roomNumber, tilex: row, tiley: col, tileNumber: tile}

        setItemElement: (row, col, item, broadcast) -> 
                @itemGrid.setElement(row,col,item)
                if !broadcast? || (broadcast? && broadcast)
                        sendItemData {id: player.id, roomNumber:player.roomNumber, tilex: row, tiley: col, itemNumber: item}

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
                @tileGrid.mapArray = []
                @tileGrid.mapArray.push arrayitem for arrayitem in @tileGridOriginal.mapArray
                @itemGrid.mapArray = []
                @itemGrid.mapArray.push arrayitem for arrayitem in @itemGridOriginal.mapArray

map0 =  [0, 1, 2, 3, 4, 5, 6, 7, 8, 5, 6, 7, 8, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 0, 0, 0, 0, 0, 0, 2, 4, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 2, 2, 3, 3, 2, 2, 3, 3, 4, 4, 4, 0, 0, 0, 2, 2, 2, 4, 4, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 2, 2, 2, 2, 2, 4, 4, 4, 4, 2, 2, 2, 2, 4, 4, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 0, 0, 0, 0, 3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 0, 0, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 4, 4, 4, 4, 4, 4, 0, 2, 2, 3, 3, 2, 2, 1, 2, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 2, 2, 3, 3, 2, 2, 1, 0, 2, 2, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 2, 3, 3, 2, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 2, 2, 2, 2, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2]

item0 = [0, 1, 3, 5, 4, 5, 6, 7, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

map = new Map(new Grid(map0, 20, 30), new Grid(item0, 20, 30))
