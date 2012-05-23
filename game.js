var Tile, canvasHeight, canvasWidth, currentFile, files, fullHeight, fullWidth, gridIndex, main, map0, mouseSquarex, mouseSquarey, mousex, mousey, numcols, numrows, render, scrollAccConst, scrollRegion, scrollx, scrollxacc, scrollxvel, scrolly, scrollyacc, scrollyvel, then_, tileArray, update, updateScroll, _ref;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
map0 = [0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 2, 2, 2, 2, 2, 4, 0, 0, 0, 0, 2, 1, 4, 4, 4, 2, 0, 0, 0, 0, 2, 2, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 4, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 2, 2, 2, 2, 2, 4, 0, 0, 0, 0, 2, 1, 4, 4, 4, 2, 0, 0, 0, 0, 2, 2, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 4, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 2, 2, 2, 2, 2, 4, 0, 0, 0, 0, 2, 1, 4, 4, 4, 2, 0, 0, 0, 0, 2, 2, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 4, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 2, 2, 2, 2, 2, 4, 0, 0, 0, 0, 2, 1, 4, 4, 4, 2, 0, 0, 0, 0, 2, 2, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 4, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 0, 0, 0, 2, 2, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 4, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0, 3, 0, 0, 0, 0, 3, 0, 4, 0, 0];
numrows = 15;
numcols = 30;
canvasWidth = 400;
canvasHeight = 400;
fullWidth = 25 * numcols;
fullHeight = 25 * numrows;
mousex = 0;
mousey = 0;
mouseSquarex = 0;
mouseSquarey = 0;
scrollx = 0.0;
scrollxvel = 0.0;
scrollxacc = 0.0;
scrolly = 0.0;
scrollyvel = 0.0;
scrollyacc = 0.0;
scrollRegion = 0.15;
scrollAccConst = 0.12;
gridIndex = function(x, y) {
  return y * numcols + x;
};
/*
Initialisation events
*/
$(document).ready(function() {
  return $('#container').mousemove(function(evt) {
    var offset;
    offset = $(this).offset();
    mousex = Math.floor(evt.pageX - offset.left);
    mousey = Math.floor(evt.pageY - offset.top);
    return console.log("x,y : " + mousex + "," + mousey);
  });
});
window.onload = function() {
  window.stage = new Kinetic.Stage({
    container: "container",
    width: canvasWidth,
    height: canvasHeight
  });
  window.mapLayer = new Kinetic.Layer();
  return window.stage.add(mapLayer);
};
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
/*
Drawing to canvas
*/
render = function() {
  var mapContext, x, y, _results;
  mapContext = window.mapLayer.getContext();
  mapContext.fillStyle = "#000000";
  mapContext.fillRect(0, 0, canvasWidth, canvasHeight);
  _results = [];
  for (y = 0; 0 <= numrows ? y < numrows : y > numrows; 0 <= numrows ? y++ : y--) {
    _results.push((function() {
      var _results2;
      _results2 = [];
      for (x = 0; 0 <= numcols ? x < numcols : x > numcols; 0 <= numcols ? x++ : x--) {
        _results2.push(tileArray[map0[gridIndex(x, y)]].tileReady ? mapContext.drawImage(tileArray[map0[gridIndex(x, y)]].tileImage, x * 25 - scrollx, y * 25 - scrolly) : void 0);
      }
      return _results2;
    })());
  }
  return _results;
};
/*
Updating game logic
*/
update = function(modifier) {
  return updateScroll();
};
updateScroll = function() {
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
  mouseSquarex = Math.floor((scrollx + mousex) / 25);
  return mouseSquarey = Math.floor((scrolly + mousey) / 25);
};
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
