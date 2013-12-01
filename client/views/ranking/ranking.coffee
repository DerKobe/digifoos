Template.ranking.players = ->
  players = []
  _.each Players.find({}, {sort: {score:-1, gamesWon: -1, gamesLost: 1, goalsMade: -1, goalsAgainst: 1}}).fetch(), (player, i)->
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
)

percentage = (x,sum)->
  if x == 0
      0
    else
      Math.round(x / (sum) * 1000) / 10