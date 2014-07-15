var GameManager = require('../../lib/GameManager').GameManager;

describe('GameManager', function(){
  it("should allow adding games", function(){
    var gm = new GameManager();
    gm.addGame("gameId");
    expect(gm.games.length).toBe(1);
  })
});