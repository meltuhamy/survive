define(['Resources'], function(Resources){
  function PreloaderState(){
    Phaser.State.apply(this, arguments);

  }

  PreloaderState.prototype = Object.create(Phaser.State.prototype);
  PreloaderState.prototype.constructor = PreloaderState;



  PreloaderState.prototype.preload = function(){
    this.preloadBar = this.add.sprite(200, 250, 'preloadBar');
    Resources.loadAll(this);
    this.load.setPreloadSprite(this.preloadBar);
  };

  PreloaderState.prototype.create = function(){
    var tween = this.add.tween(this.preloadBar).to({ alpha: 0 }, 1000, Phaser.Easing.Linear.None, true);
    tween.onComplete.add(this.startMainMenu, this);
  };

  PreloaderState.prototype.startMainMenu = function(){
    this.game.state.start('MainMenuState', true, false);
  };


  return PreloaderState;
});