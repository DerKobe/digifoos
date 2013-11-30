Template.playerDetails.helpers
  currentPlayer: ->
    Players.findOne(Session.get('currentPlayerId'))