var Player, Tile, canvasHeight, canvasWidth, currentFile, files, fullHeight, fullWidth, gridIndex, main, map0, mouseSquarex, mouseSquarey, mousex, mousey, numcols, numrows, player, playerMovingDown, playerMovingLeft, playerMovingRight, playerMovingUp, playerx, playery, render, scrollAccConst, scrollRegion, scrollx, scrollxacc, scrollxvel, scrolly, scrollyacc, scrollyvel, then_, tileArray, update, updateScroll, _ref;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
map0 = [0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 2, 2, 2, 2, 2, 4, 0, 0, 0, 0, 2, 1, 4, 4, 4, 2, 0, 0, 0, 0, 2, 2, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 4, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 2, 2, 2, 2, 2, 4, 0, 0, 0, 0, 2, 1, 4, 4, 4, 2, 0, 0, 0, 0, 2, 2, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 4, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 2, 2, 2, 2, 2, 4, 0, 0, 0, 0, 2, 1, 4, 4, 4, 2, 0, 0, 0, 0, 2, 2, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 4, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 2, 2, 2, 2, 2, 4, 0, 0, 0, 0, 2, 1, 4, 4, 4, 2, 0, 0, 0, 0, 2, 2, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 4, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 0, 0, 0, 2, 2, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 4, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0];
numrows = 15;
numcols = 30;
canvasWidth = 400;
canvasHeight = 200;
fullWidth = 25 * numcols;
fullHeight = 25 * numrows;
mousex = 0;
mousey = 0;
mouseSquarex = 0;
mouseSquarey = 0;
playerx = 0;
playery = 0;
scrollx = 0.0;
scrollxvel = 0.0;
scrollxacc = 0.0;
scrolly = 0.0;
scrollyvel = 0.0;
scrollyacc = 0.0;
scrollRegion = 0.15;
scrollAccConst = 0.12;
playerMovingLeft = false;
playerMovingUp = false;
playerMovingRight = false;
playerMovingDown = false;
gridIndex = function(x, y) {
  return y * numcols + x;
};
/*
Initialisation events
*/
$(document).ready(function() {
  $('#container').mousemove(function(evt) {
    var offset;
    offset = $(this).offset();
    mousex = Math.floor(evt.pageX - offset.left);
    return mousey = Math.floor(evt.pageY - offset.top);
  });
  $('#container').keyup(function(evt) {
    if (evt.keyCode === 37) {
      playerMovingLeft = false;
    }
    if (evt.keyCode === 38) {
      playerMovingUp = false;
    }
    if (evt.keyCode === 39) {
      playerMovingRight = false;
    }
    if (evt.keyCode === 40) {
      return playerMovingDown = false;
    }
  });
  return $('#container').keydown(function(evt) {
    if (evt.keyCode === 37) {
      playerMovingUp = false;
      playerMovingRight = false;
      playerMovingDown = false;
    }
    if (evt.keyCode === 38) {
      playerMovingLeft = false;
      playerMovingRight = false;
      playerMovingDown = false;
    }
    if (evt.keyCode === 39) {
      playerMovingLeft = false;
      playerMovingUp = false;
      playerMovingDown = false;
    }
    if (evt.keyCode === 40) {
      playerMovingLeft = false;
      playerMovingUp = false;
      return playerMovingRight = false;
    }
  });
});
window.onload = __bind(function() {
  window.stage = new Kinetic.Stage({
    container: "container",
    width: canvasWidth,
    height: canvasHeight
  });
  window.mapLayer = new Kinetic.Layer();
  window.hoverSelectLayer = new Kinetic.Layer();
  window.hoverSelectBox = new Kinetic.Rect({
    fill: 'yellow',
    width: 25,
    height: 25,
    alpha: 0.6
  });
  window.hoverSelectLayer.add(window.hoverSelectBox);
  window.stage.add(window.mapLayer);
  return window.stage.add(window.hoverSelectLayer);
}, this);
/*
Loading resources
*/
files = ["grass.png", "fire.png", "hill.png", "stone.png", "water.png"];
Tile = (function() {
  function Tile(src) {
    this.tileImage = new Image();
    this.tileImage.onload = __bind(function() {
      return this.tileReady = true;
    }, this);
    this.tileImage.src = src;
  }
  Tile.prototype.tileReady = false;
  return Tile;
})();
tileArray = {};
for (currentFile = 0, _ref = files.length; 0 <= _ref ? currentFile < _ref : currentFile > _ref; 0 <= _ref ? currentFile++ : currentFile--) {
  tileArray[currentFile] = new Tile(files[currentFile]);
}
Player = (function() {
  function Player() {
    this.playerImage = new Image();
    this.playerImage.onload = __bind(function() {
      return this.imgReady = true;
    }, this);
    this.playerImage.src = "sprite.png";
  }
  Player.prototype.imgReady = false;
  return Player;
})();
player = new Player();
/*
Drawing to canvas
*/
render = __bind(function() {
  var mapContext, x, y;
  mapContext = window.mapLayer.getContext();
  mapContext.fillStyle = "#000000";
  mapContext.fillRect(0, 0, canvasWidth, canvasHeight);
  for (y = 0; 0 <= numrows ? y < numrows : y > numrows; 0 <= numrows ? y++ : y--) {
    for (x = 0; 0 <= numcols ? x < numcols : x > numcols; 0 <= numcols ? x++ : x--) {
      if (tileArray[map0[gridIndex(x, y)]].tileReady) {
        mapContext.drawImage(tileArray[map0[gridIndex(x, y)]].tileImage, x * 25 - scrollx, y * 25 - scrolly);
      }
    }
  }
  window.hoverSelectBox.setX(Math.floor((scrollx + mousex) / 25) * 25 - Math.floor(scrollx));
  window.hoverSelectBox.setY(Math.floor((scrolly + mousey) / 25) * 25 - Math.floor(scrolly));
  window.hoverSelectLayer.draw();
  if (player.imgReady) {
    mapContext.drawImage(player.playerImage, playerx - scrollx, playery - scrolly);
  }
  if (playerMovingLeft) {
    playerx = playerx - 0.1;
  }
  if (playerMovingRight) {
    playerx = playerx + 0.1;
  }
  if (playerMovingUp) {
    playery = playery - 0.1;
  }
  if (playerMovingDown) {
    return playery = playery + 0.1;
  }
}, this);
/*
Updating game logic
*/
update = function(modifier) {
  return updateScroll();
};
updateScroll = __bind(function() {
  scrollxvel = scrollxvel * 0.92;
  scrollyvel = scrollyvel * 0.92;
  scrollx += scrollxvel;
  scrollxvel += scrollxacc;
  scrolly += scrollyvel;
  scrollyvel += scrollyacc;
  if (canvasWidth < fullWidth) {
    if (scrollx < 0) {
      scrollx = 0;
      scrollxvel = 0;
      scrollxacc = 0;
    } else if (mousex < canvasWidth * scrollRegion) {
      scrollxacc = -scrollAccConst;
    } else if (scrollx > fullWidth - canvasWidth) {
      scrollx = fullWidth - canvasWidth;
      scrollxvel = 0;
      scrollxacc = 0;
    } else if (mousex > canvasWidth * (1 - scrollRegion)) {
      scrollxacc = scrollAccConst;
    } else {
      scrollxacc = 0;
    }
  } else {
    scrollx = -(canvasWidth - fullWidth) / 2;
  }
  if (canvasHeight < fullHeight) {
    if (scrolly < 0) {
      scrolly = 0;
      scrollyvel = 0;
      scrollyacc = 0;
    } else if (mousey < canvasHeight * scrollRegion) {
      scrollyacc = -scrollAccConst;
    } else if (scrolly > fullHeight - canvasHeight) {
      scrolly = fullHeight - canvasHeight;
      scrollyvel = 0;
      scrollyacc = 0;
    } else if (mousey > canvasHeight * (1 - scrollRegion)) {
      scrollyacc = scrollAccConst;
    } else {
      scrollyacc = 0;
    }
  } else {
    scrolly = -(canvasHeight - fullHeight) / 2;
  }
  mouseSquarex = Math.floor(mousex / 25);
  return mouseSquarey = Math.floor(mousey / 25);
}, this);
/*
Main method
*/
main = function() {
  var delta, now, then_;
  now = Date.now();
  delta = now - then_;
  update(delta / 1000);
  render();
  return then_ = now;
};
then_ = Date.now();
setInterval(main, 1);
