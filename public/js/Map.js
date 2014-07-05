define([], function () {
  function Map(game, key) {
    Phaser.Tilemap.call(this, game, key);
    game.map = this;

    this.addTilesetImage('tilesheet', 'tilesheet');

    this.addLayers();
    this.setCollisionLayers();
  }

  Map.prototype = Object.create(Phaser.Tilemap.prototype);
  Map.prototype.constructor = Map;



  Map.prototype.addLayers = function(){
    this.layerObjects = {
      "grass": this.createLayer('grass-back'),
      "walkable": this.createLayer('walkable'),
      "water": this.createLayer('water'),
      "wood": this.createLayer('wood'),
      "fire": this.createLayer('fire'),
      "walls": this.createLayer('walls')
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
    if(this.layerObjects != undefined){
      this.setCollisionByExclusion([], true, this.layerObjects.grass);
      this.setCollisionByExclusion([], true, this.layerObjects.water);
      this.setCollisionByExclusion([], true, this.layerObjects.fire);
      this.setCollisionByExclusion([], true, this.layerObjects.walls);
    }
  };

  Map.prototype.collideWithSprite = function(sprite){
    for(var k in this.layerObjects){
      if(this.layerObjects.hasOwnProperty(k)){
        game.physics.arcade.collide(sprite, this.layerObjects[k]);
      }
    }
  };

  Map.prototype.collideWithSprites = function(sprites){
    for(var i = 0; i < sprites.length; i++){
      this.collideWithSprite(sprites[i]);
    }
  };

  return Map;

});