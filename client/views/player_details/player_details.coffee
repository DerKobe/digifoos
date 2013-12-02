Template.playerDetails.helpers(
  currentPlayer: ->
    Players.findOne(Session.get('currentPlayerId'))

  percentageWon: ->
    percentage @gamesWon, (@gamesWon + @gamesLost)

  percentageLost: ->
    percentage @gamesLost, (@gamesWon + @gamesLost)

  gamesPlayed: ->
    @gamesWon + @gamesLost

  rank: ->
    players = Players.find({$or: [{gamesWon:{$gt: 0}}, {gamesLost:{$gt:0}}]}, {sort: {score:-1}})
    rank = 'N/A'
    _.each players.fetch(), (player,i)->
      rank = i + 1 if player._id == Session.get('currentPlayerId')
    rank

  scoreHistory: ->
    JSON.stringify(@scoreHistory)
)

#===================================================================
percentage = (x,sum)->
  if sum == 0
    0
  else
    Math.round((x / sum) * 1000) / 10

#===================================================================
Template.playerDetails.rendered = ->
  data = {
    labels : []
    datasets: [
      {
        fillColor : "rgba(151,187,205,0.5)"
        strokeColor : "rgba(151,187,205,1)"
        pointColor : "rgba(151,187,205,1)"
        pointStrokeColor : "#fff"
        data : []
      }
    ]
  }

  options = {
    bezierCurve: false
    scaleFontSize: 18
    scaleFontStyle: '100'
    scaleFontColor: "white"
    scaleFontFamily: '"Helvetica Neue", Helvetica, Arial, sans-serif'
    scaleShowGridLines: false
    animation: false
    scaleLineColor: "none"
  }

  canvas = $('#player-chart').get(0)
  if canvas?
    canvas = canvas.getContext('2d')
    y = $('#player-chart').data('score-history')
    x = _.map y, -> ''
    data.datasets[0].data = y
    data.labels = x
    new Chart(canvas).Line(data, options)