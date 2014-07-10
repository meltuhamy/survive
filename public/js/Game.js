define(['BootState', 'PreloaderState', 'MainMenuState', 'PlayState'],
    function(BootState, PreloaderState, MainMenuState, PlayState){
  function Game(element, width, height){
    Phaser.Game.call(this, width, height, Phaser.CANVAS, element, null);

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