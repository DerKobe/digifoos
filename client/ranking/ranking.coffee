Template.ranking.players = ->
  players = []
  _.each Players.find({}, {sort: {score:-1}}).fetch(), (player, i)->
    player.rank = i + 1
    players.push player
  players

Template.ranking.helpers(
  percentageWon: ->
    percentage @gamesWon, (@gamesWon + @gamesLost)

  percentageLost: ->
    percentage @gamesLost, (@gamesWon + @gamesLost)
)

percentage = (x,sum)->
  if x == 0
      0
    else
      Math.round(x / (sum) * 1000) / 10