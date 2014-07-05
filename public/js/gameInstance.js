define(['PlayerSprite', 'Map'], function(PlayerSprite, Map){

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

  var cursors;
  var player;

  function create() {
    startPhysics();
    addMap();
    addPlayer();
    addControls();
  }

  function startPhysics(){
    game.physics.startSystem(Phaser.Physics.ARCADE);
  }

  function addPlayer(){
    player = new PlayerSprite(game, 450, 80, 'clotharmor');
    window.player = player;
    game.add.existing(player);
    game.camera.follow(player);
  }

  function addControls(){
    cursors = game.input.keyboard.createCursorKeys();
  }

  function addMap(){
    map = new Map(game, "riverpath");
    map.resizeLayerWorlds();
  }


  function update() {
    map.collideWithSprite(player);

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
    map: map
  };
});