class Game
  constructor: ->
    @rounds = []
    @idx = -1

  addRound: (round) ->
    round.game = this
    @rounds.push(round)

  next: ->
    @idx = (@idx + 1) % @rounds.length
    @currentRound = @rounds[@idx]
    @currentRound.display()

  showSuccess: ->
    msg = @currentRound.success
    $("<div class='notice success'>#{msg}</div>").appendTo($canvas)

  showFailure: ->
    msg = @currentRound.success
    $("<div class='notice failure'>NOPE! #{msg}</div>").appendTo($canvas)


# A round of the game
class Round
  constructor: (data) ->
    @tiles = data.tiles
    @correct = data.correct
    @success = data.success

  click: (e) ->
    $elem = $(this)
    $elem.toggleClass('active')
    $tiles = $canvas.find('.tile')
    $correct = $tiles.filter('.correct')
    $active = $tiles.filter('.active')
    if $correct.length == $active.length
      # disable all click handlers
      $tiles.off('click')
      if $correct.not('.active').length == 0
        g.showSuccess()
      else
        g.showFailure()
      setTimeout(->
          g.next()
        , 5000)


  display: ->
    $canvas.empty()
    for tile, idx in @tiles
      $tile = $("<div class='tile'><img src='#{tile}'></div>")
      if @correct.indexOf(idx) != -1
        $tile.addClass('correct')
      $tile.on('click', @click)
      if Math.random() > 0.5
        $tile.appendTo($canvas)
      else
        # $tile.appendTo($canvas)
        $tile.prependTo($canvas)
      console.log tile, idx


$canvas = $('#canvas')
g = null  # scope hack

main = ->
  g = new Game()

  for round in rounds
    r = new Round(round)
    g.addRound(r)

  g.next()

$ main
