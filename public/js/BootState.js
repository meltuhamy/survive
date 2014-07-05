define([], function(){
  function BootState(){
    Phaser.State.apply(this, arguments);
  }

  BootState.prototype = Object.create(Phaser.State.prototype);
  BootState.prototype.constructor = BootState;


  BootState.prototype.preload = function(){
    this.load.image('preloadBar', 'assets/img/loader.png');
  };

  BootState.prototype.create = function(){
    this.input.maxPointers = 1;

    //  Phaser will automatically pause if the browser tab the game is in loses focus. You can disable that here:
//    this.stage.disableVisibilityChange = true;

    if (this.game.device.desktop) {
      //  If you have any desktop specific settings, they can go in here
      this.stage.scale.pageAlignHorizontally = true;
    } else {
      //  Same goes for mobile settings.
    }

    this.game.state.start('PreloaderState', true, false);
  };



  return BootState;
});