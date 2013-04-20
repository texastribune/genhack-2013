class Game
  constructor: ->
    @rounds = []

  addRound: (round) ->
    @rounds.push(round)


# A round of the game
class Round
  constructor: (data) ->
    @tiles = data.tiles
    @success = data.success

  display: ->
    console.log @tiles, @success


main = ->
  g = new Game()

  for round in rounds
    r = new Round(round)
    g.addRound(r)
    r.display()

$ main
