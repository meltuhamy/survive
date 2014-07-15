function GameManager(){
  this.games = [];
}

GameManager.prototype.addGame = function(gameId){
  this.games.push(gameId);
};

exports.GameManager = GameManager;