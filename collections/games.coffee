@Games = new Meteor.Collection('games')

@Games.distributePoints = (game)->
  score = (players)->
    (_.reduce players, ((sum,p)-> sum + Players.findOne(p._id).score), 0) / players.length

  elo = (ra, rb, w, f = 150)->
    ra + Math.round(15*(w-(1/(1+Math.pow(10,(rb-ra)/f)))))

  if game.current?
    if game.blackTeam.score > game.whiteTeam.score
      winners = game.blackTeam
      losers  = game.whiteTeam
    else
      winners = game.whiteTeam
      losers  = game.blackTeam

    diffWinner = elo(score(winners.players), score(losers.players), 1) - score(winners.players)
    diffLoser  = elo(score(losers.players), score(winners.players), 0) - score(losers.players)

    _.each winners.players, (player)->
      score = Players.findOne(player._id).score + diffWinner
      Players.update player._id, $inc: { score: diffWinner, gamesWon: 1, goalsMade: winners.score, goalsAgainst: losers.score }, $push: { scoreHistory: score }

    _.each losers.players, (player)->
      score = Players.findOne(player._id).score + diffLoser
      Players.update player._id, $inc: { score: diffLoser, gamesLost: 1, goalsMade: losers.score, goalsAgainst: winners.score }, $push: { scoreHistory: score }

    if winners.players.length == 2
      for player in [0..1]
        buddy = (player + 1) % 2
        winner = Players.findOne(winners.players[player]._id)
        action = if winner.winningTeamBuddyCount[winners.players[buddy]._id]? then '$inc' else '$set'
        data = {}
        data[action] = {}
        data[action]["winningTeamBuddyCount.#{winners.players[buddy]._id}"] = 1
        Players.update winners.players[player]._id, data

    if losers.players.length == 2
      _.each losers.players, (loser)->
        loser = Players.findOne(loser._id)
        _.each winners.players, (winner)->
          action = if loser.lostAgainstCount[winner._id]? then '$inc' else '$set'
          data = {}
          data[action] = {}
          data[action]["lostAgainstCount.#{winner._id}"] = 1
          Players.update loser._id, data

    if game.blackTeam.score > game.whiteTeam.score
      Games.update game._id, $unset: { current: 1 }, $set: { 'whiteTeam.scoreDiff': diffLoser, 'blackTeam.scoreDiff': diffWinner }
    else
      Games.update game._id, $unset: { current: 1 }, $set: { 'whiteTeam.scoreDiff': diffWinner, 'blackTeam.scoreDiff': diffLoser }