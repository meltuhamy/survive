define([], function () {
  "use strict";

  var PlayerSprite = function (game, x, y, spriteresource) {

    Phaser.Sprite.call(this, game, x, y, spriteresource);


    this.moveSpeed = 200;
    this.viewRadius = 10;
    this.tweenSpeed = this.moveSpeed / 3;
    this.moving = false;

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

    game.add.existing(this);
  };

  PlayerSprite.prototype = Object.create(Phaser.Sprite.prototype);
  PlayerSprite.prototype.constructor = PlayerSprite;

  PlayerSprite.prototype.stopMoving = function () {
    this.body.velocity.x = 0;
    this.body.velocity.y = 0;
    this.moving = false;
    this.playStationaryAnimation();
  };

  PlayerSprite.prototype.moveUp = function () {
    this.moving = true;
    this.body.velocity.y = -this.moveSpeed;
  };

  PlayerSprite.prototype.moveDown = function () {
    this.moving = true;
    this.body.velocity.y = this.moveSpeed;
  };

  PlayerSprite.prototype.moveLeft = function () {
    this.moving = true;
    this.body.velocity.x = -this.moveSpeed;
  };

  PlayerSprite.prototype.moveRight = function () {
    this.moving = true;
    this.body.velocity.x = this.moveSpeed;
  };

  PlayerSprite.prototype.playStationaryAnimation = function () {
    if (this.animations.currentAnim && this.animations.currentAnim.isFinished) {
      switch (this.body.facing) {
        case Phaser.RIGHT:
          this.scale.x = 1;
          this.animations.play('waitright');
          break;

        case Phaser.LEFT:
          this.scale.x = -1;
          this.animations.play('waitright');
          break;

        case Phaser.UP:
          this.animations.play('waitup');
          break;

        case Phaser.DOWN:
          this.animations.play('waitdown');
          break;
      }
    }
  };

  PlayerSprite.prototype.playMovingAnimation = function () {
    switch (this.body.facing) {
      case Phaser.RIGHT:
        this.scale.x = 1;
        this.animations.play('moveright');
        break;

      case Phaser.LEFT:
        this.scale.x = -1;
        this.animations.play('moveright');
        break;

      case Phaser.UP:
        this.animations.play('moveup');
        break;

      case Phaser.DOWN:
        this.animations.play('movedown');
        break;
    }
  };

  PlayerSprite.prototype.runTween = function (tween) {
    var stepCoo = this.path[this.currPathStep++];

    return stepCoo ? this.runTween(tween.to({
      x: stepCoo.x * 16,
      y: stepCoo.y * 16
    }, this.tweenSpeed, Phaser.Easing.Linear.None, true)) : tween;
  };

  PlayerSprite.prototype.moveTo = function (path) {
    this.currPathStep = 0;
    this.path = path;
    this.tween = this.game.add.tween(this.body);

    this.runTween(this.tween).start();

    // Tween timer
    this.tweenActive = true;
    if (this.tweenTimer) clearTimeout(this.tweenTimer);
    var thisRef = this;
    this.tweenTimer = setTimeout(function () {
      thisRef.tweenActive = false;
    }, this.tweenSpeed * path.length);
  };


  PlayerSprite.prototype.getTileX = function () {
    return game.map.layerObjects.grass.getTileX(this.x);
  };

  PlayerSprite.prototype.getTileY = function () {
    return game.map.layerObjects.grass.getTileY(this.y);
  };


  /**
   * Automatically called by World.update
   */
  PlayerSprite.prototype.update = function () {
    this.playStationaryAnimation();

    if(this.moving || this.tweenActive){
      this.playMovingAnimation();
    }
  };

  return PlayerSprite;
});