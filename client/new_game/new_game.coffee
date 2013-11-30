Template.newGame.events(
  'touchstart #start-the-game, click #start-the-game': ->
    game = Games.findOne(new: true)
    if game? && game.whiteTeam.players.length > 0 &&  game.blackTeam.players.length > 0
      Games.update(game._id, { '$unset': {new: 1}, '$set': {current: true}})
      Meteor.Router.to '/current-game'

  'click button': (event)->
    event.preventDefault()
    $button = $(event.currentTarget)
    game_id = Games.findOne({new: true}, {fields:{_id: true}})._id

    if game_id
      data = { '$push': {} }
      data['$push']["#{$button.data('team')}Team.players"] = {
        _id: $button.data('player_id'),
        name: $button.data('player_name')
      }
      Games.update(game_id, data)

  'click a[href="#remove"]': (event)->
    event.preventDefault()
    player_id = $(event.currentTarget).data('player_id')
    game_id = Games.findOne(new: true)._id
    if player_id && game_id
      Games.update(game_id, { '$pull': {'whiteTeam.players': {_id: player_id} } } )
      Games.update(game_id, { '$pull': {'blackTeam.players': {_id: player_id} } } )
)

Template.newGame.newGame = ->
  Games.findOne new: true

Template.newGame.players = ->
  Players.find({}, {sort:{name:1}})

Template.newGame.helpers(
  'notAlreadyOnATeam': ->
    game = Games.findOne(new: true)
    if game?
      white = game.whiteTeam.players
      black = game.blackTeam.players
      array = [black[0]?._id, black[1]?._id, white[0]?._id, white[1]?._id]
      array.indexOf(@_id) == -1
    else
      false

  'teamIsFull': (team)->
    game = Games.findOne(new: true)
    if game?
      game["#{team}Team"].players.length == 2
    else
      true
)