Games = new Meteor.Collection('games')
MessageQueue = new Meteor.Collection('message_queue')

# ===================
# --- C L I E N T ---
# ===================

currentGame = ->
  game = Games.findOne( {}, { sort: { created_at: -1 } } )
  document.title = "#{game.black}:#{game.white} Digifoos" if game? && Meteor.isClient
  game

if Meteor.isClient

  triggerGameOver = ->
    if currentGame()?.black > currentGame()?.white
      outcome = 'Black wins!'
    else if currentGame()?.white > currentGame()?.black
      outcome = 'White wins!'
    else
      outcome = "It's a tie!"
    console.log "Games over! #{outcome}"

  Template.score.events(
    'click      .game-over': triggerGameOver
    'touchstart .game-over': triggerGameOver
  )

  Template.score.events(
    'click .inc-white': -> MessageQueue.insert team: 'white', action: 'inc'
    'click .dec-white': -> MessageQueue.insert team: 'white', action: 'dec'
    'click .inc-black': -> MessageQueue.insert team: 'black', action: 'inc'
    'click .dec-black': -> MessageQueue.insert team: 'black', action: 'dec'

    'touchstart .inc-white': -> MessageQueue.insert team: 'white', action: 'inc'
    'touchstart .dec-white': -> MessageQueue.insert team: 'white', action: 'dec'
    'touchstart .inc-black': -> MessageQueue.insert team: 'black', action: 'inc'
    'touchstart .dec-black': -> MessageQueue.insert team: 'black', action: 'dec'
  )

  Template.black.score = ->
    currentGame()?.black

  Template.white.score = ->
    currentGame()?.white

# ===================
# --- S E R V E R ---
# ===================
if Meteor.isServer
  Meteor.startup ->
    collectionApi = new CollectionAPI(authToken: '123')
    collectionApi.addCollection(MessageQueue, 'message_queue')
    collectionApi.start()

    game = currentGame()
    unless game?
      console.log 'No game were found. Creating one.'
      Games.insert created_at: new Date(), white: 0, black: 0

    # listen for new messages on the queue
    MessageQueue.find().observe(
      added: (message)->
        gameId = currentGame()._id
        unless message.time?
          switch message.team
            when 'white'
              switch message.action
                when 'inc'
                  Games.update _id: gameId, { $inc: { white: 1 } }
                when 'dec'
                  if currentGame().white > 0
                    Games.update _id: gameId, { $inc: { white: -1 } }

            when 'black'
              switch message.action
                when 'inc'
                  Games.update _id: gameId, { $inc: { black: 1 } }
                when 'dec'
                  if currentGame().black > 0
                    Games.update _id: gameId, { $inc: { black: -1 } }

        MessageQueue.update _id: message._id, { $set: { game: gameId, time: new Date() } }
    )