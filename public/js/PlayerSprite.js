define([], function () {
  "use strict";

  var PlayerSprite = function (game, x, y, spriteresource) {

    Phaser.Sprite.call(this, game, x, y, spriteresource);


    this.levels = {
      stamina: 100,
      health: 100,
      water: 100,
      food: 100
    };

    this.levelsSignal = new Phaser.Signal();

    this.moveSpeed = 200;
    this.viewRadius = 10;
    this.tweenSpeed = this.moveSpeed / 3;
    this.moving = false;
    this.movingToPath = false;

    this.moveMarker = game.add.graphics();
    this.moveMarker.lineStyle(1, 0xffffff, 1);
    this.moveMarker.drawRect(0, 0, 32, 32);

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

  PlayerSprite.prototype.increase = function(property, value){
    this.levels[property] += value;
    if(this.levels[property] < 0){
      this.levels[property] = 0;
    } else if(this.levels[property] > 100){
      this.levels[property] = 100;
    }

    this.levelsSignal.dispatch(property, this.levels[property]);

    return this.levels[property];
  };

  PlayerSprite.prototype.decrease = function (property, value) {
    return this.increase(property, -value)
  };

  PlayerSprite.prototype.setLevel = function (property, value){
    if(value >= 0 && value <= 100){
      this.levels[property] = value;
    }
    this.levelsSignal.dispatch(property, value);

    return this[property];
  };

  PlayerSprite.prototype.stopMoving = function () {
    this.body.velocity.x = 0;
    this.body.velocity.y = 0;
    this.moving = false;
    this.playStationaryAnimation();
  };

  PlayerSprite.prototype.stopMovingToPath = function(){
    if(this.tween){
      this.tween.runningTween.stop();
      this.tween.stop();
      this.moveMarker.alpha = 0;
      this.movingToPath = false;
    }
  };

  PlayerSprite.prototype.setMoveFlags = function(){
    this.stopMovingToPath();
    this.moving = true;
  };

  PlayerSprite.prototype.moveUp = function () {
    this.setMoveFlags();
    this.body.velocity.y = -this.moveSpeed;
  };

  PlayerSprite.prototype.moveDown = function () {
    this.setMoveFlags();
    this.body.velocity.y = this.moveSpeed;
  };

  PlayerSprite.prototype.moveLeft = function () {
    this.setMoveFlags();
    this.body.velocity.x = -this.moveSpeed;
  };

  PlayerSprite.prototype.moveRight = function () {
    this.setMoveFlags();
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

  PlayerSprite.prototype.pathToTween = function (path) {
    var sprite = this;
    var tween = game.add.tween(this.body);
    tween.onStart.add(function(){
      tween.runningTween = tween;
    });

    for(var i = 0; i < path.length; i++){
      var coords = {x: path[i].x * 16, y: path[i].y * 16};
      tween.to(coords, this.tweenSpeed);
    }

    tween.chained = [];
    var getChainedTweens = function(t){
      if(t._chainedTweens && t._chainedTweens.length > 0){
        tween.chained.push(t._chainedTweens[0]);
        t.onStart.add(function(){
          tween.runningTween = t;
          sprite.movingToPath = true;
        });
        return getChainedTweens(t._chainedTweens[0]);
      } else {
        return t;
      }
    };

    getChainedTweens(tween);

    tween.lastTween = tween.chained[tween.chained.length-1];
    return tween;
  };

  PlayerSprite.prototype.moveTo = function (path) {
    // stop any previous tweens, THEN start tween.
    if(this.tween){
      this.tween.runningTween.stop();
    }

    this.tween = this.pathToTween(path);
    var sprite = this;
    this.tween.onStart.add(function(){
      sprite.moveMarker.x = sprite.game.map.tileFromWorldX(sprite.game.input.activePointer.worldX) * 16 - 8;
      sprite.moveMarker.y = sprite.game.map.tileFromWorldY(sprite.game.input.activePointer.worldY) * 16 - 8;
      sprite.moveMarker.alpha = 1;
      sprite.movingToPath = true;
    });

    this.tween.lastTween.onComplete.add(function(){
      sprite.moveMarker.alpha = 0;
      sprite.movingToPath = false;
    });

    this.tween.start();
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
    if(this.moving || this.movingToPath){
      this.playMovingAnimation();
    } else {
      this.playStationaryAnimation();
    }
  };

  return PlayerSprite;
});