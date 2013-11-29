#======================================================================================
Template.currentGame.events
  'touchstart .inc-white, click .inc-white': -> MessageQueue.insert team: 'white', action: 'inc'
  'touchstart .dec-white, click .dec-white': -> MessageQueue.insert team: 'white', action: 'dec'
  'touchstart .inc-black, click .inc-black': -> MessageQueue.insert team: 'black', action: 'inc'
  'touchstart .dec-black, click .dec-black': -> MessageQueue.insert team: 'black', action: 'dec'

  'touchstart #vs, click #vs': ->
    id = Games.findOne(current: true)._id
    Games.update id, { '$unset': { current: 1 } }
    Meteor.Router.to '/'

#======================================================================================
Template.currentGame.helpers
  game: ->
    Games.findOne current: true