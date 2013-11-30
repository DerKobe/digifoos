Meteor.Router.add
  '/': 'gamesList'

  '/current-game': 'currentGame'

  '/new-game'     :
    to: 'newGame'
    and: -> Meteor.call('newGame')

  '/ranking': 'ranking'

  '/players': 'playersList'

  '/players/:_id':
    to: 'playerDetails'
    and: (id)-> Session.set('currentPlayerId', id)