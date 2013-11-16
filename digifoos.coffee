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

  Template.score.events(
    'click button.takeBackLastGoal': ->
      console.log 'The last goal did not count!'
  )

  Template.score.events(
    'click .inc-white': -> MessageQueue.insert team: 'white', action: 'inc'
    'click .dec-white': -> MessageQueue.insert team: 'white', action: 'dec'
    'click .inc-black': -> MessageQueue.insert team: 'black', action: 'inc'
    'click .dec-black': -> MessageQueue.insert team: 'black', action: 'dec'
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