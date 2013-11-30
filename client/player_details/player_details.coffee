Template.playerDetails.helpers(
  currentPlayer: ->
    Players.findOne(Session.get('currentPlayerId'))

  percentageWon: ->
    percentage @gamesWon, (@gamesWon + @gamesLost)

  percentageLost: ->
    percentage @gamesLost, (@gamesWon + @gamesLost)

  rank: ->
    players = Players.find({}, {sort: {score:-1}})
    rank = 'N/A'
    _.each players.fetch(), (player,i)->
      rank = i + 1 if player._id == Session.get('currentPlayerId')
    rank
)

percentage = (x,sum)->
  if x == 0
      0
    else
      Math.round(x / (sum) * 1000) / 10