clickTitle = _.debounce(
  ->
    if document.location.pathname == '/current-game'
      newGame = Games.findOne({current: true}, {fields: {regularOrder: 1}})
      Games.update newGame._id, $set: { regularOrder: !newGame.regularOrder }

  ,250,true
)

Template.layout.events(
  'click .title, touchstart .title': clickTitle
)

incWhite = _.debounce((-> MessageQueue.insert(team: 'white', action: 'inc')), 250, true)
decWhite = _.debounce((-> MessageQueue.insert(team: 'white', action: 'dec')), 250, true)
incBlack = _.debounce((-> MessageQueue.insert(team: 'black', action: 'inc')), 250, true)
decBlack = _.debounce((-> MessageQueue.insert(team: 'black', action: 'dec')), 250, true)

clickVs = _.debounce(
  ->
    game = Games.findOne(current: true)
    bs = game.blackTeam.score
    ws = game.whiteTeam.score

    # win by difference of 2, or 7 total
    if (bs >= 5 || ws >= 5) && (bs > ws+1 || ws > bs+1) || (ws == 7 || bs == 7)
      Games.distributePoints(game)
      Meteor.Router.to '/'

,250,true
)

Template.currentGame.events(
  'touchstart .inc-white, click .inc-white': incWhite
  'touchstart .dec-white, click .dec-white': decWhite
  'touchstart .inc-black, click .inc-black': incBlack
  'touchstart .dec-black, click .dec-black': decBlack
  'touchstart #vs, click #vs': clickVs

)

#======================================================================================
Template.currentGame.helpers
  game: ->
    game = Games.findOne current: true
    Meteor.Router.to '/new-game' unless game?
    game