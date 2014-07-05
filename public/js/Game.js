define(['BootState', 'PreloaderState', 'MainMenuState', 'PlayState'],
    function(BootState, PreloaderState, MainMenuState, PlayState){
  function Game(){
    Phaser.Game.call(this, 800, 600, Phaser.CANVAS, 'survive-conquer', null);

    this.state.add('BootState', BootState, false);
    this.state.add('PreloaderState', PreloaderState, false);
    this.state.add('MainMenuState', MainMenuState, false);
    this.state.add('PlayState', PlayState, false);

    this.state.start('BootState');


  }

  Game.prototype = Object.create(Phaser.Game.prototype);
  Game.prototype.constructor = Game;


  return Game;
});