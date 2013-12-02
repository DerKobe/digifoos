Meteor.Router.add
  '/': 'gamesList'

  '/current-game': 'currentGame'

  '/new-game': 'newGame'

  '/ranking': 'ranking'

  '/players': 'playersList'

  '/players/:_id':
    to: 'playerDetails'
    and: (id)-> Session.set('currentPlayerId', id)