@currentGame = ->
  game = Games.findOne( {}, { sort: { created_at: -1 } } )
  document.title = "#{game.black_team.score}:#{game.white_team.score} Digifoos" if game? && Meteor.isClient
  game