Template.gamesList.games = -> Games.find({new:{$ne:true}}, {sort: {created_at: -1}}).fetch()

Template.gamesList.whitePlayer1 = -> @whiteTeam.players[0]
Template.gamesList.whitePlayer2 = -> @whiteTeam.players[1]
Template.gamesList.blackPlayer1 = -> @blackTeam.players[0]
Template.gamesList.blackPlayer2 = -> @blackTeam.players[1]

Template.gamesList.blackWins = -> !@current && @blackTeam.score > @whiteTeam.score
Template.gamesList.whiteWins = -> !@current && @blackTeam.score < @whiteTeam.score

Template.gamesList.helpers(
  plusMinus: (score)-> if score > 0 then "+#{score}" else score
)