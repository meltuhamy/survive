define(['Map', 'PlayerSprite'], function (Map, PlayerSprite) {
  "use strict";

  function PlayState() {
    Phaser.State.apply(this, arguments);
  }

  PlayState.prototype = Object.create(Phaser.State.prototype);
  PlayState.prototype.constructor = PlayState;


  PlayState.prototype.preload = function () {
  };

  PlayState.prototype.create = function () {
    this.startPhysics();
    this.addMap();
    this.addPlayer();
    this.addSpotlight();
    this.updateSpotlight();
    this.addControls();
  };

  PlayState.prototype.addSpotlight = function () {
    this.playerSpotlight = {};
    this.playerSpotlight.bmp = this.game.add.bitmapData(800, 600);
    this.playerSpotlight.sprite = this.game.add.sprite(0, 0, this.playerSpotlight.bmp);
    this.playerSpotlight.sprite.fixedToCamera = true;
  };

  PlayState.prototype.updateSpotlight = function () {
    var c = this.game.camera;
    this.playerSpotlight.grd = this.playerSpotlight.bmp.context.createRadialGradient(this.player.x - c.x, this.player.y - c.y, 10, this.player.x - c.x, this.player.y - c.y, 200);
    this.playerSpotlight.grd.addColorStop(0.177, "rgba(0, 0, 0, 0)");
    this.playerSpotlight.grd.addColorStop(0.8, "rgba(0, 0, 0, 0.7)");

    this.playerSpotlight.bmp.clear();
    this.playerSpotlight.bmp.context.fillStyle = this.playerSpotlight.grd;
    this.playerSpotlight.bmp.context.fillRect(0, 0, 800, 600);
  };

  PlayState.prototype.startPhysics = function () {
    this.physics.startSystem(Phaser.Physics.ARCADE);
  };


  PlayState.prototype.addMap = function () {
    this.map = new Map(game, "riverpath");
    this.map.resizeLayerWorlds();
  };

  PlayState.prototype.addPlayer = function () {
    this.player = new PlayerSprite(this.game, 450, 80, 'clotharmor');
    this.camera.follow(this.player);
    window.player = this.player;
  };


  PlayState.prototype.addControls = function () {
    this.cursors = game.input.keyboard.createCursorKeys();
  };


  PlayState.prototype.update = function () {
    this.updateSpotlight();
    this.map.collideWithSprite(this.player);

    // by default, player is stationary.
    this.player.stopMoving();

    if (this.cursors.up.isDown) {
      this.player.moveUp();
    } else if (this.cursors.down.isDown) {
      this.player.moveDown();
    } else if (this.cursors.left.isDown) {
      this.player.moveLeft();
    } else if (this.cursors.right.isDown) {
      this.player.moveRight();
    }

  };

  PlayState.prototype.render = function () {
    this.game.debug.text('Tile X: ' + this.player.getTileX(), 32, 32, 'rgb(0,0,0)');
    this.game.debug.text('Tile Y: ' + this.player.getTileY(), 32, 64, 'rgb(0,0,0)');

  };


  return PlayState;
});