define([], function(){
  "use strict";
  // here we define all our resources.
  // how it works: essentially we define function calls to the load property.
  // e.g. {method: "image", resource: ['tilesheet', 'assets/img/tilesheet.png']}
  // is the same as: game.load.image('tilesheet', 'assets/img/tilesheet.png');

  var r = [
    {
      method: "tilemap",
      resource: ['riverpath', 'assets/map/riverpath.json', null, Phaser.Tilemap.TILED_JSON]
    },
    {
      method: "image",
      resource: ['tilesheet', 'assets/img/tilesheet.png']
    },
    {
      method: "spritesheet",
      resource: ['clotharmor', 'assets/img/clotharmor.png', 96, 96]
    }
  ];

  r.loadAll = function(game){
    for(var i = 0; i < r.length; i++){
      game.load[r[i].method].apply(game.load, r[i].resource);
    }
  };

  return r;
});