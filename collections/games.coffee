@Games = new Meteor.Collection('games')

@Games.distributePoints = (game)->
  if game.current?
    Games.update game._id, { $unset: { current: 1 } }

    winners = (players, goalsMade, goalsAgainst)->
      _.each players, (player)->
        _.each [{ score: 10 }, { gamesWon: 1 }, { goalsMade: goalsMade }, { goalsAgainst: goalsAgainst }], (obj)->
          Players.update player._id, $inc: obj

    losers = (players, goalsMade, goalsAgainst)->
      _.each players, (player)->
        _.each [{ score: -10 }, { gamesLost: 1 }, { goalsMade: goalsMade }, { goalsAgainst: goalsAgainst }], (obj)->
          Players.update player._id, $inc: obj

    if game.blackTeam.score > game.whiteTeam.score
      winners game.blackTeam.players, game.blackTeam.score, game.whiteTeam.score
      losers  game.whiteTeam.players, game.whiteTeam.score, game.blackTeam.score
    else
      winners game.whiteTeam.players, game.whiteTeam.score, game.blackTeam.score
      losers  game.blackTeam.players, game.blackTeam.score, game.whiteTeam.score