class Game
  constructor: ->
    @rounds = []

  addRound: (round) ->
    @rounds.push(round)


# A round of the game
class Round
  constructor: (data) ->
    @tiles = data.tiles
    @correct = data.correct
    @success = data.success

  click: (e) ->
    $elem = $(this)
    $elem.toggleClass('active')
    $correct = $canvas.find('.correct')
    $active = $canvas.find('.active')
    if $correct.length == $active.length
      if $correct.not('.active').length == 0
        console.log 'yay'
      else
        console.log 'boooo'

  display: ->
    $canvas.empty()
    for tile, idx in @tiles
      $tile = $("<img src='#{tile}'>")
      if @correct.indexOf(idx) != -1
        $tile.addClass('correct')
      $tile.on('click', @click).appendTo($canvas)
      console.log tile, idx


$canvas = $('#canvas')

main = ->
  g = new Game()

  for round in rounds
    r = new Round(round)
    g.addRound(r)
    r.display()

$ main
