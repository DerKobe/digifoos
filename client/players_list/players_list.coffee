Template.playersList.players = ->
  Players.find({},{sort:{name: 1}})