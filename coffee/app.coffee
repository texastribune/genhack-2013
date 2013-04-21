class Game
  constructor: ->
    @rounds = []
    @idx = -1

  addRound: (round) ->
    round.game = this
    @rounds.push(round)

  next: ->
    self = this
    @idx = (@idx + 1) % @rounds.length
    @currentRound = @rounds[@idx]
    @currentRound.display()
    $canvas.find('.tile')
    .on('mousedown', ->
      self.down = this)
    .on 'mouseup', ->
      if this == self.down
        return
      $(this).addClass('active')
      $(self.down).addClass('active')
      self.down = undefined
      self.check()

  check: ->
    self = this
    $tiles = $canvas.find('.tile')
    $correct = $tiles.filter('.correct')
    $active = $tiles.filter('.active')
    if $active.length == 0
      return
    if $active.length > @.currentRound.correct.length
      $active.removeClass('active')
      return
    if $correct.length == $active.length
      # disable all click handlers
      $tiles.off('click').not('.active').addClass('inactive')
      if $correct.not('.active').length == 0
        @showSuccess()
      else
        @showFailure()
      setTimeout(->
          self.next()
        , 5000)

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
    g.check()

  display: ->
    $canvas.empty()
    for tile, idx in @tiles
      $tile = $("<div class='tile'><img src='#{tile}'></div>")
      $tile
        .find('img')[0].draggable = false
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
