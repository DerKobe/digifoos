#======================================================================================
Template.currentGame.events
  'touchstart .inc-white, click .inc-white': -> MessageQueue.insert team: 'white', action: 'inc'
  'touchstart .dec-white, click .dec-white': -> MessageQueue.insert team: 'white', action: 'dec'
  'touchstart .inc-black, click .inc-black': -> MessageQueue.insert team: 'black', action: 'inc'
  'touchstart .dec-black, click .dec-black': -> MessageQueue.insert team: 'black', action: 'dec'

  'touchstart #vs, click #vs': ->
    game = Games.findOne(current: true)
    bs = game.blackTeam.score
    ws = game.whiteTeam.score

    # win by difference of 2, or 7 total
    if (bs >= 5 || ws >= 5) && (bs > ws+1 || ws > bs+1) || (ws == 7 || bs == 7)
      Games.distributePoints(game)
      Meteor.Router.to '/'

#======================================================================================
Template.currentGame.helpers
  game: ->
    game = Games.findOne current: true
    Meteor.Router.to '/new-game' unless game?
    game