define([], function () {
  function Map(game, key) {
    Phaser.Tilemap.call(this, game, key);
    this.pathFinder = game.plugins.add(Phaser.Plugin.PathFinderPlugin);

    game.map = this;

    this.addTilesetImage('tilesheet', 'tilesheet');
    this.addLayers();
    this.setCollisionLayers();

    this.cellMarker = this.game.add.graphics();
    this.cellMarker.lineStyle(1, 0xffffff, 1);
    this.cellMarker.drawRect(0, 0, 30, 30);
  }

  Map.prototype = Object.create(Phaser.Tilemap.prototype);
  Map.prototype.constructor = Map;


  Map.prototype.update = function(){
    this.cellMarker.x = this.tileFromWorldX(this.game.input.activePointer.worldX) * 16;
    this.cellMarker.y = this.tileFromWorldY(this.game.input.activePointer.worldY) * 16;
  };

  Map.prototype.tileFromWorldX = function(x){
    return this.layerObjects.grass.getTileX(x);
  };

  Map.prototype.tileFromWorldY = function(y){
    return this.layerObjects.grass.getTileY(y);
  };


  Map.prototype.addLayers = function(){
    this.layerObjects = {
      "grass": this.createLayer('grass-back'),
      "walkable": this.createLayer('walkable'),
      "water": this.createLayer('water'),
      "wood": this.createLayer('wood'),
      "fire": this.createLayer('fire'),
      "walls": this.createLayer('walls'),
      "collisions":  this.createLayer('collisions')
    };
  };

  Map.prototype.resizeLayerWorlds = function(){
    for(var k in this.layerObjects){
      if(this.layerObjects.hasOwnProperty(k)){
        this.layerObjects[k].resizeWorld();
      }
    }
  };

  Map.prototype.setCollisionLayers = function(){
    this.collisionIndices = {
      walkable: [17641],
      blocked: [17642]
    };

    this.pathFinder.setGrid(this.layers[this.getLayer('collisions')].data, this.collisionIndices.walkable);


    if(this.layerObjects != undefined){
      this.setCollision(this.collisionIndices.blocked, true, this.layerObjects.collisions);
    }
  };

  Map.prototype.collideWithSprite = function(sprite){
    this.game.physics.arcade.collide(sprite, this.layerObjects.collisions);
  };

  Map.prototype.collideWithSprites = function(sprites){
    for(var i = 0; i < sprites.length; i++){
      this.collideWithSprite(sprites[i]);
    }
  };



  return Map;

});