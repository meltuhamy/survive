define([], function(){

  var PlayerSprite = function (game, x, y, spriteresource) {
    Phaser.Sprite.call(this, game, x, y, spriteresource);


    this.moveSpeed = 200;
    this.direction = "down";

    this.anchor.setTo(0.5, 0.5);

    game.physics.enable(this);

    this.body.setSize(16, 16, 0, 16);
    this.body.collideWorldBounds = true;


    /*
     frames:
     5-8 : run right
     10-11: pause right
     20-23: run up
     25-26: pause up
     35-38: run down
     40-41: pause down
     */

    this.animations.add('moveright', [5, 6, 7, 8], 8, false);
    this.animations.add('waitright', [10, 11], 0.3, false);
    this.animations.add('waitleft', [10, 11], 0.3, false);
    this.animations.add('moveup', [20, 21, 22, 23], 8, false);
    this.animations.add('waitup', [25, 26], 0.3, false);
    this.animations.add('movedown', [35, 36, 37, 38], 8, false);
    this.animations.add('waitdown', [40, 41], 0.3, false);
  };

  PlayerSprite.prototype = Object.create(Phaser.Sprite.prototype);
  PlayerSprite.prototype.constructor = PlayerSprite;

  PlayerSprite.prototype.stopMoving = function(){
    this.body.velocity.x = 0;
    this.body.velocity.y = 0;

    if(this.animations.currentAnim.isFinished){
      this.animations.play("wait"+this.direction);
    }
  };

  PlayerSprite.prototype.moveUp = function(){
    this.body.velocity.y = -this.moveSpeed;
    this.animations.play('moveup');
    this.direction = "up";
  };

  PlayerSprite.prototype.moveDown = function(){
    this.body.velocity.y = this.moveSpeed;
    this.animations.play('movedown');
    this.direction = "down";
  };
  PlayerSprite.prototype.moveLeft = function(){
    this.body.velocity.x = -this.moveSpeed;
    this.scale.x = -1;
    this.animations.play('moveright');
    this.direction = "left";
  };
  PlayerSprite.prototype.moveRight = function(){
    this.body.velocity.x = this.moveSpeed;
    this.scale.x = 1;
    this.animations.play('moveright');
    this.direction = "right";
  };

  PlayerSprite.prototype.getTileX = function(){
    return game.map.floor.getTileX(this.x);
  };

  PlayerSprite.prototype.getTileY = function(){
    return game.map.floor.getTileY(this.y);
  };


  /**
   * Automatically called by World.update
   */
  PlayerSprite.prototype.update = function() {
  };

  return PlayerSprite;
});