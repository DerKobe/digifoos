Meteor.methods(
  'newGame': ->
    game = Games.findOne new: true
    unless game
      Games.insert(
        new: true,
        whiteTeam: {
          players: []
          score: 0
        }
        blackTeam: {
          players: []
          score: 0
        }
        created_at: new Date()
      )
)