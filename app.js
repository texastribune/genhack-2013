// Generated by CoffeeScript 1.4.0
(function() {
  var $canvas, Game, Round, g, main, rounds;

  rounds = [
    {
      tiles: ['http://i.imgur.com/ICn6oM3b.jpg', 'http://i.imgur.com/9JdVHQOb.jpg', 'http://i.imgur.com/FIUY1Fjb.jpg', 'http://i.imgur.com/8yxtHpvb.jpg'],
      correct: [0, 2],
      success: 'You won!'
    }, {
      tiles: ['http://i.imgur.com/MRrUKW1b.jpg', 'http://i.imgur.com/V5hfU33b.jpg', 'http://i.imgur.com/WTPh4N9b.jpg', 'http://i.imgur.com/5Or8VyWb.jpg'],
      correct: [0, 2],
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
      this.idx = (this.idx + 1) % this.rounds.length;
      this.currentRound = this.rounds[this.idx];
      return this.currentRound.display();
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
      var $active, $correct, $elem;
      $elem = $(this);
      $elem.toggleClass('active');
      $correct = $canvas.find('.correct');
      $active = $canvas.find('.active');
      if ($correct.length === $active.length) {
        if ($correct.not('.active').length === 0) {
          console.log('yay');
        } else {
          console.log('boooo');
        }
        return g.next();
      }
    };

    Round.prototype.display = function() {
      var $tile, idx, tile, _i, _len, _ref, _results;
      $canvas.empty();
      _ref = this.tiles;
      _results = [];
      for (idx = _i = 0, _len = _ref.length; _i < _len; idx = ++_i) {
        tile = _ref[idx];
        $tile = $("<img src='" + tile + "'>");
        if (this.correct.indexOf(idx) !== -1) {
          $tile.addClass('correct');
        }
        $tile.on('click', this.click).appendTo($canvas);
        _results.push(console.log(tile, idx));
      }
      return _results;
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
