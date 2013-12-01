@Games = new Meteor.Collection('games')

@Games.distributePoints = (game)->
  score = (players)->
    (_.reduce players, ((sum,p)-> sum + Players.findOne(p._id).score), 0) / players.length

  elo = (ra, rb, k)->
    ra + Math.round(15*(k-(1/(1+Math.pow(10,(rb-ra)/400)))))

  if game.current?
    if game.blackTeam.score > game.whiteTeam.score
      winner = game.blackTeam
      loser  = game.whiteTeam
    else
      winner = game.whiteTeam
      loser  = game.blackTeam

    diffWinner = elo(score(winner.players), score(loser.players), 1) - score(winner.players)
    diffLoser  = elo(score(loser.players), score(winner.players), 0) - score(loser.players)

    _.each winner.players, (player)->
      Players.update player._id, $inc: { score: diffWinner, gamesWon: 1, goalsMade: winner.score, goalsAgainst: loser.score }

    _.each loser.players, (player)->
      Players.update player._id, $inc: { score: diffLoser, gamesLost: 1, goalsMade: loser.score, goalsAgainst: winner.score }

    if game.blackTeam.score > game.whiteTeam.score
      Games.update game._id, $unset: { current: 1 }, $set: { 'whiteTeam.scoreDiff': diffLoser, 'blackTeam.scoreDiff': diffWinner }
    else
      Games.update game._id, $unset: { current: 1 }, $set: { 'whiteTeam.scoreDiff': diffWinner, 'blackTeam.scoreDiff': diffLoser }