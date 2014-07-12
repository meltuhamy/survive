define([], function(){
  function Item(game, frame){
    if(typeof frame === "string"){
      frame = this.frameNamesMap[frame];
    }
    Phaser.Sprite.call(this, game, 0, 0, 'items', frame);
    this.scale.setTo(32/34,32/34);
  }

  Item.prototype = Object.create(Phaser.Sprite.prototype);
  Item.prototype.constructor = Item;

  Item.prototype.frameNamesMap = {
    fish: 24,
    healthLarge: 28,
    waterLarge: 31,
    emptyLarge: 50
  };

  Item.prototype.addToMap = function(tileX, tileY){
    this.moveToTile(tileX, tileY);
    this.game.add.existing(this);
  };

  Item.prototype.moveToTile = function(tileX, tileY){
    this.x = tileX*16;
    this.y = tileY*16;
  };

  return Item;
});