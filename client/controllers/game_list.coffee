Template.gamesList.games = -> Games.find()

Template.gamesList.whitePlayer1 = -> @whiteTeam.players[0].name
Template.gamesList.whitePlayer2 = -> @whiteTeam.players[1].name
Template.gamesList.blackPlayer1 = -> @blackTeam.players[0].name
Template.gamesList.blackPlayer2 = -> @blackTeam.players[1].name