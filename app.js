// Generated by CoffeeScript 1.4.0
(function() {
  var $canvas, Game, Round, g, main, rounds;

  rounds = [
    {
      tiles: ['http://i.imgur.com/Zbkx6tFb.jpg', 'http://i.imgur.com/ICn6oM3b.jpg', 'http://i.imgur.com/cdXotPXb.jpg', 'http://i.imgur.com/49701U7b.jpg'],
      correct: [0, 2],
      success: 'You won!'
    }, {
      tiles: ['http://i.imgur.com/iIlPkLsb.jpg', 'http://i.imgur.com/vE34d4Lb.jpg', 'http://i.imgur.com/RNMrLbHb.jpg', 'http://i.imgur.com/nNeCLSWb.jpg'],
      correct: [1, 3],
      success: 'You won!'
    }
  ];

  Game = (function() {

    function Game() {
      this.rounds = [];
      this.idx = -1;
    }

    Game.prototype.addRound = function(round) {
      round.game = this;
      return this.rounds.push(round);
    };

    Game.prototype.next = function() {
      var self;
      self = this;
      this.idx = (this.idx + 1) % this.rounds.length;
      $canvas.empty().attr('class', '');
      this.currentRound = this.rounds[this.idx];
      this.currentRound.display();
      return $canvas.find('.tile').on('mousedown.game', function() {
        return self.down = this;
      }).on('mouseup.game', function() {
        if (this === self.down) {
          return;
        }
        $(this).addClass('active');
        $(self.down).addClass('active');
        self.down = void 0;
        return self.check();
      });
    };

    Game.prototype.check = function() {
      var $active, $correct, $tiles, self;
      self = this;
      $tiles = $canvas.find('.tile');
      $correct = $tiles.filter('.correct');
      $active = $tiles.filter('.active');
      if ($active.length === 0) {
        return;
      }
      if ($active.length > this.currentRound.correct.length) {
        $active.removeClass('active');
        return;
      }
      if ($correct.length === $active.length) {
        $tiles.off('.game').not('.active').addClass('inactive');
        if ($correct.not('.active').length === 0) {
          $canvas.addClass('correct');
          this.showSuccess();
        } else {
          this.showFailure();
        }
        return setTimeout(function() {
          return self.next();
        }, 5000);
      }
    };

    Game.prototype.showSuccess = function() {
      var msg;
      msg = this.currentRound.success;
      return $("<div class='notice success'>" + msg + "</div>").appendTo($canvas);
    };

    Game.prototype.showFailure = function() {
      var msg;
      msg = this.currentRound.success;
      return $("<div class='notice failure'>NOPE! " + msg + "</div>").appendTo($canvas);
    };

    return Game;

  })();

  Round = (function() {

    function Round(data) {
      this.tiles = data.tiles;
      this.correct = data.correct;
      this.success = data.success;
    }

    Round.prototype.click = function(e) {
      var $elem;
      $elem = $(this);
      $elem.toggleClass('active');
      return g.check();
    };

    Round.prototype.display = function() {
      var $tile, idx, tile, _i, _len, _ref;
      _ref = this.tiles;
      for (idx = _i = 0, _len = _ref.length; _i < _len; idx = ++_i) {
        tile = _ref[idx];
        $tile = $("<div class='tile'><img src='" + tile + "'></div>");
        $tile.find('img')[0].draggable = false;
        if (this.correct.indexOf(idx) !== -1) {
          $tile.addClass('correct');
        }
        $tile.on('click.game', this.click);
        if (Math.random() > 0.5) {
          $tile.appendTo($canvas);
        } else {
          $tile.prependTo($canvas);
        }
      }
      $canvas.find('.tile').each(function(idx) {
        return $(this).addClass("start pos-" + idx);
      });
      return setTimeout(function() {
        $canvas.find('.tile').removeClass('start');
      }, 1);
    };

    return Round;

  })();

  $canvas = $('#canvas');

  g = null;

  main = function() {
    var r, round, _i, _len;
    g = new Game();
    for (_i = 0, _len = rounds.length; _i < _len; _i++) {
      round = rounds[_i];
      r = new Round(round);
      g.addRound(r);
    }
    return g.next();
  };

  $(main);

}).call(this);
