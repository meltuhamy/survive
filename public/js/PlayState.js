define(['Map', 'PlayerSprite', 'PlayerSpotlight'], function (Map, PlayerSprite, PlayerSpotlight) {
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
    this.addControls();
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

    this.spotlight = new PlayerSpotlight(this.game, this.player);

  };


  PlayState.prototype.addControls = function () {
    this.cursors = game.input.keyboard.createCursorKeys();
  };


  PlayState.prototype.update = function () {
    this.map.collideWithSprite(this.player);
    this.map.update();

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