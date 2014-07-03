var game = new Phaser.Game(800, 600, Phaser.CANVAS, 'phaser-example', { preload: preload, create: create, update: update, render: render });

var debug = new Phaser.Utils.Debug(game);

function preload() {

    game.load.tilemap('riverpath', 'assets/map/riverpath.json', null, Phaser.Tilemap.TILED_JSON);
    game.load.image('tilesheet', 'assets/img/tilesheet.png');
    game.load.spritesheet('clotharmor', 'assets/img/clotharmor.png', 96, 96);



}


var map;
var grassLayer;
var layers = [];

var cursors;
var sprite;

function create() {

    game.physics.startSystem(Phaser.Physics.ARCADE);

    map = game.add.tilemap('riverpath');

    map.addTilesetImage('tilesheet', 'tilesheet');

    grassLayer = map.createLayer('grass-back');
    walkableLayer = map.createLayer('walkable');
    waterLayer = map.createLayer('water');
    woodLayer = map.createLayer('wood');
    fireLayer = map.createLayer('fire');
    wallsLayer = map.createLayer('walls');

    layers = [grassLayer, woodLayer, walkableLayer, waterLayer, fireLayer, wallsLayer];

    // grassLayer.resizeWorld();
    for (var i = 0; i < layers.length; i++) {
        layers[i].resizeWorld();
    };

    map.setCollisionByExclusion([], true, woodLayer);
    map.setCollisionByExclusion([], true, waterLayer);
    map.setCollisionByExclusion([], true, fireLayer);
    map.setCollisionByExclusion([], true, wallsLayer);

    sprite = game.add.sprite(450, 80, 'clotharmor');

    sprite.anchor.setTo(0.5,0.5);

    game.physics.enable(sprite);

    sprite.body.setSize(16,16,0,16);


    game.camera.follow(sprite);

    cursors = game.input.keyboard.createCursorKeys();

    /*
    frames:
    5-8 : run right
    10-11: pause right
    20-23: run up
    25-26: pause up
    35-38: run down
    40-41: pause down
    */

    sprite.animations.add('moveright', [5,6,7,8], 8, false);
    sprite.animations.add('waitright', [10,11], 3, false);
    sprite.animations.add('moveup',    [20,21,22,23], 8, false);
    sprite.animations.add('waitup',    [26,26], 3, false);
    sprite.animations.add('movedown',  [35,36,37,38], 8, false);
    sprite.animations.add('waitdown',  [40,41], 3, false);


}



function update() {

    for (var i = 0; i < layers.length; i++) {
        game.physics.arcade.collide(sprite, layers[i]);
    };

    sprite.body.velocity.x = 0;
    sprite.body.velocity.y = 0;
    var moveSpeed = 200;
    
    if (cursors.up.isDown)
    {
        sprite.body.velocity.y = -moveSpeed;
        sprite.animations.play('moveup');
    }
    else if (cursors.down.isDown)
    {
        sprite.body.velocity.y = moveSpeed;
        sprite.animations.play('movedown');

    }

    if (cursors.left.isDown)
    {
        sprite.body.velocity.x = -moveSpeed;
        sprite.scale.x = -1;
        sprite.animations.play('moveright');

    }
    else if (cursors.right.isDown)
    {
        sprite.body.velocity.x = moveSpeed;
        sprite.scale.x = 1;
        sprite.animations.play('moveright');

    }

}

function render() {
    game.debug.text('Tile X: ' + grassLayer.getTileX(sprite.x), 32, 32, 'rgb(0,0,0)');
    game.debug.text('Tile Y: ' + grassLayer.getTileY(sprite.y), 32, 64, 'rgb(0,0,0)');

}