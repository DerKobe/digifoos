Template.ranking.players = ->
  players = []
  _.each Players.find({$or: [{gamesWon:{$gt: 0}}, {gamesLost:{$gt:0}}]}, {sort: {score:-1, gamesWon: -1, gamesLost: 1, goalsMade: -1, goalsAgainst: 1}}).fetch(), (player, i)->
    player.rank = i + 1
    players.push player
  players

Template.ranking.helpers(
  percentageWon: ->
    percentage @gamesWon, (@gamesWon + @gamesLost)

  percentageLost: ->
    percentage @gamesLost, (@gamesWon + @gamesLost)

  gamesPlayer: ->
    @gamesWon + @gamesLost

  goalsMadePerGame: ->
    perGame @goalsMade, (@gamesWon + @gamesLost)

  goalsAgainstPerGame: ->
    perGame @goalsAgainst, (@gamesWon + @gamesLost)
)

percentage = (x,sum)->
  return 0 if x == 0
  Math.round(x / (sum) * 1000) / 10

perGame = (goals,games)->
  Math.round(goals / games * 10) / 10