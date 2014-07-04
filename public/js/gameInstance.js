define(['PlayerSprite'], function(PlayerSprite){

  var game = new Phaser.Game(800, 600, Phaser.CANVAS, 'survive-conquer', {
    preload: preload,
    create: create,
    update: update,
    render: render
  });

  function preload() {

    game.load.tilemap('riverpath', 'assets/map/riverpath.json', null, Phaser.Tilemap.TILED_JSON);
    game.load.image('tilesheet', 'assets/img/tilesheet.png');
    game.load.spritesheet('clotharmor', 'assets/img/clotharmor.png', 96, 96);


  }


  var map;
  var grassLayer;
  var layers = [];
  layers.grassLayer = grassLayer;

  var cursors;
  var player;

  function create() {

    game.physics.startSystem(Phaser.Physics.ARCADE);

    map = game.add.tilemap('riverpath');
    game.map = map;
    map.addTilesetImage('tilesheet', 'tilesheet');

    grassLayer = map.createLayer('grass-back');
    game.map.floor = grassLayer;
    var walkableLayer = map.createLayer('walkable');
    var waterLayer = map.createLayer('water');
    var woodLayer = map.createLayer('wood');
    var fireLayer = map.createLayer('fire');
    var wallsLayer = map.createLayer('walls');

    layers = [grassLayer, woodLayer, walkableLayer, waterLayer, fireLayer, wallsLayer];

    // grassLayer.resizeWorld();
    for (var i = 0; i < layers.length; i++) {
      layers[i].resizeWorld();
    }

    map.setCollisionByExclusion([], true, woodLayer);
    map.setCollisionByExclusion([], true, waterLayer);
    map.setCollisionByExclusion([], true, fireLayer);
    map.setCollisionByExclusion([], true, wallsLayer);

    player = new PlayerSprite(game, 450, 80, 'clotharmor');
    window.player = player;
    game.add.existing(player);
    game.camera.follow(player);
    cursors = game.input.keyboard.createCursorKeys();

  }


  function update() {
    for (var i = 0; i < layers.length; i++) {
      game.physics.arcade.collide(player, layers[i]);
    }

    // by default, player is stationary.
    player.stopMoving();

    if (cursors.up.isDown) {
      player.moveUp();
    } else if (cursors.down.isDown) {
      player.moveDown();
    } else if (cursors.left.isDown) {
      player.moveLeft();
    } else if (cursors.right.isDown) {
      player.moveRight();
    }

  }

  function render() {
    game.debug.text('Tile X: ' + player.getTileX(), 32, 32, 'rgb(0,0,0)');
    game.debug.text('Tile Y: ' + player.getTileY(), 32, 64, 'rgb(0,0,0)');

  }

  return {
    game: game,
    layers: layers,
    map: map
  };
});