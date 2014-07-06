define([], function(){
  function PlayerSpotlight(game, targetSprite){
    this.target = targetSprite;

    this.spotlightBitmap = game.add.bitmapData(game.camera.width, game.camera.height);
    Phaser.Sprite.call(this, game, 0, 0, this.spotlightBitmap);
    this.fixedToCamera = true;

    this.innerRadius = Math.abs(this.target.width);

    game.add.existing(this);

  }

  PlayerSpotlight.prototype = Object.create(Phaser.Sprite.prototype);
  PlayerSpotlight.prototype.constructor = PlayerSpotlight;


  PlayerSpotlight.prototype.update = function(){
    var c = this.game.camera;
    var radius = this.target.viewRadius || 10;
    var x = this.target.x - c.x;
    var y = this.target.y - c.y;
    var grd = this.spotlightBitmap.context.createRadialGradient(x, y, this.innerRadius, x, y, 16+radius*16);
    grd.addColorStop(0.177, "rgba(0, 0, 0, 0)");
    grd.addColorStop(0.8, "rgba(0, 0, 0, 0.7)");

    this.spotlightBitmap.clear();
    this.spotlightBitmap.context.fillStyle = grd;
    this.spotlightBitmap.context.fillRect(0, 0, this.width, this.height);
  };

  return PlayerSpotlight;
});