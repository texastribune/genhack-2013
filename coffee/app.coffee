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
    $canvas.empty().attr('class', '')
    @currentRound = @rounds[@idx]
    @currentRound.display()
    $canvas.find('.tile')
    .on 'mousedown.game', ->
      self.down = this
    .on 'mouseup.game', (e) ->
      if this == self.down
        return
      $(this).addClass('active')
      $(self.down).addClass('active')
      self.down = undefined
      self.check(e)

  check: (e) ->
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
      $tiles.off('.game').not('.active').addClass('end')

      # look for free spot to shift correct answers to
      apos0 = $active.filter('.pos-0').length
      apos1 = $active.filter('.pos-1').length
      apos2 = $active.filter('.pos-2').length
      apos3 = $active.filter('.pos-3').length
      lookup = "" + apos0 + apos1 + apos2 + apos3
      free = [2, 3]
      if apos2
        free.shift()
      if apos3
        free.pop()
      switch lookup
        when "1100"
          $active.addClass('shiftS')
        when "1010"
          $active.filter('.pos-0').addClass('shiftSE')
        when "1001"
          $active.filter('.pos-0').addClass('shiftS')
        when "0110"
          $active.filter('.pos-1').addClass('shiftS')
        when "0101"
          $active.filter('.pos-1').addClass('shiftSW')

      # puzzle solved correctly?
      if $correct.not('.active').length == 0
        $canvas.addClass('correct')
        @showSuccess()
      else
        @showFailure()
      e.stopPropagation()
      $(document).one 'click', ->
        self.next()
        return
      return
      # setTimeout(->
      #   , 5000)

  showSuccess: ->
    msg = @currentRound.success
    url = @currentRound.url
    content = "<div class='notice success'>
      <a href='#{url}' rel='nofollow' target='_blank'>#{msg}</a>
      <a href='#{url}' rel='nofollow' target='_blank' class='permalink'><i class='icon-share-alt'></i> full story</a>
      </div>
    "
    $(content).appendTo($canvas).on('click', (e) ->
      e.stopPropagation()
    )

  showFailure: ->
    @showSuccess()  # TODO


# A round of the game
class Round
  constructor: (data) ->
    @tiles = data.tiles
    @correct = data.correct
    @success = data.success
    @url = data.url

  click: (e) ->
    $elem = $(this)
    $elem.toggleClass('active')
    g.check(e)

  display: ->
    for tile, idx in @tiles
      $tile = $("<div class='tile'><img src='#{tile}'></div>")
      $tile
        .find('img')[0].draggable = false
      if @correct.indexOf(idx) != -1
        $tile.addClass('correct')
      $tile.on('click.game', @click)
      if Math.random() > 0.5
        $tile.appendTo($canvas)
      else
        # $tile.appendTo($canvas)
        $tile.prependTo($canvas)

    $canvas.find('.tile').each((idx)->
      $(this).addClass("start pos-#{idx}")
    )
    setTimeout(->
      $canvas.find('.tile').removeClass('start')
      return
    , 1)


$canvas = $('#canvas')
g = null  # scope hack

main = ->
  g = new Game()

  for round in rounds
    r = new Round(round)
    g.addRound(r)

  g.next()

$ main
