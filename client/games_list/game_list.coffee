Template.gamesList.games = -> Games.find({}, {sort: {created_at: -1}})

Template.gamesList.whitePlayer1 = -> @whiteTeam.players[0].name
Template.gamesList.whitePlayer2 = -> @whiteTeam.players[1].name
Template.gamesList.blackPlayer1 = -> @blackTeam.players[0].name
Template.gamesList.blackPlayer2 = -> @blackTeam.players[1].name

Template.gamesList.blackWins = -> !@current && @blackTeam.score > @whiteTeam.score
Template.gamesList.whiteWins = -> !@current && @blackTeam.score < @whiteTeam.score