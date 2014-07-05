define([], function(){
  function MainMenuState(){

  }
  MainMenuState.prototype = Object.create(Phaser.State.prototype);
  MainMenuState.prototype.constructor = MainMenuState;


  MainMenuState.prototype.create = function(){
    this.startGame();
  };

  MainMenuState.prototype.startGame = function(){
    this.game.state.start('PlayState', true, false);
  };

  MainMenuState.prototype.render = function(){
    this.game.debug.text('Loading...', 32, 32, 'rgb(255,255,255)');
  };



  return MainMenuState;
});