Template.score.events(
  'touchstart .game-over, click .game-over': ->
    if currentGame()?.black > currentGame()?.white
      outcome = 'Black wins!'
    else if currentGame()?.white > currentGame()?.black
      outcome = 'White wins!'
    else
      outcome = "It's a tie!"
    console?.log "Games over! #{outcome}"
)

Template.score.events(
  'touchstart .inc-white, click .inc-white': -> MessageQueue.insert team: 'white', action: 'inc'
  'touchstart .dec-white, click .dec-white': -> MessageQueue.insert team: 'white', action: 'dec'
  'touchstart .inc-black, click .inc-black': -> MessageQueue.insert team: 'black', action: 'inc'
  'touchstart .dec-black, click .dec-black': -> MessageQueue.insert team: 'black', action: 'dec'
)

Template.black.score = ->
  currentGame()?.black_team.score

Template.black.players = ->
  currentGame()?.black_team.players

Template.white.score = ->
  currentGame()?.white_team.score

Template.white.players = ->
  currentGame()?.white_team.players