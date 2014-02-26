clickTitle = _.debounce(
  ->
    if document.location.pathname == '/new-game'
      newGame = Games.findOne({new: true}, {fields: {regularOrder: 1}})
      Games.update newGame._id, $set: { regularOrder: !newGame.regularOrder }

  ,250,true
)

Template.layout.events(
  'click .title, touchstart .title': clickTitle
)

startTheGame = _.debounce(
  ->
    game = Games.findOne(new: true)
    if game? && game.whiteTeam.players.length > 0 && game.blackTeam.players.length > 0
      Games.update(game._id, { $unset: {new: 1}, $set: {current: true}})
      Meteor.Router.to '/current-game'

  ,250, true
)

Template.newGame.events(
  'touchstart #start-the-game, click #start-the-game': startTheGame

  'click button': (event)->
    event.preventDefault()
    $button = $(event.currentTarget)
    game_id = Games.findOne({new: true}, {fields:{_id: true}})._id

    if game_id
      data = { $push: {} }
      data.$push["#{$button.data('team')}Team.players"] = {
        _id: $button.data('player_id'),
        name: $button.data('player_name')
      }
      Games.update(game_id, data)

  'click a[href="#remove"]': (event)->
    event.preventDefault()
    player_id = $(event.currentTarget).data('player_id')
    game_id = Games.findOne(new: true)._id
    if player_id && game_id
      Games.update(game_id, { $pull: {'whiteTeam.players': {_id: player_id} } } )
      Games.update(game_id, { $pull: {'blackTeam.players': {_id: player_id} } } )

  'click #scramble-players button': (event)->
    game = Games.findOne(new: true)

    playerPool = game.whiteTeam.players.concat(game.blackTeam.players)

    # shuffle
    for i in [0..Math.floor(Math.random() * 10)]
      playerPool = playerPool.sort -> (.5 - Math.random())

    Games.update(game._id, { $set: { 'whiteTeam.players': [playerPool[0],playerPool[1]], 'blackTeam.players': [playerPool[2],playerPool[3]] } } )
)

#===================================================================================
Template.newGame.newGame = ->
  if Games.findOne(current: true)?
    Meteor.Router.to '/current-game'
  else
    Meteor.call('newGame')
    Games.findOne new: true

Template.newGame.players = ->
  Players.find({}, {sort:{name:1}})

#===================================================================================
Template.newGame.helpers(
  notAlreadyOnATeam: ->
    game = Games.findOne(new: true)
    if game?
      white = game.whiteTeam.players
      black = game.blackTeam.players
      array = [black[0]?._id, black[1]?._id, white[0]?._id, white[1]?._id]
      array.indexOf(@_id) == -1
    else
      false

  teamIsFull: (team)->
    game = Games.findOne(new: true)
    if game?
      game["#{team}Team"].players.length == 2
    else
      true

  regularOrder: ->
    Games.findOne(new: true).regularOrder
)