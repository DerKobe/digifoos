Meteor.startup ->
  setupMessageQueueApi()
  startMessageQueueObserver()

  unless currentGame()?
    console.log 'No game were found. Creating one.'
    Games.insert(
      created_at: new Date(),
      white_team: {
        score: 0,
        players: [ {name: 'Adam'},{name: 'Eva'} ]
      },
      black_team: {
        score: 0,
        players: [ {name: 'Dick'},{name: 'Doof'} ]
      }
    )

#---------------------------------------------------------------------------------------
setupMessageQueueApi = ->
  collectionApi = new CollectionAPI(authToken: '123')
  collectionApi.addCollection(MessageQueue, 'message_queue', methods: ['POST'])
  collectionApi.start()

#---------------------------------------------------------------------------------------
startMessageQueueObserver = ->
  # listen for new messages on the queue
  MessageQueue.find().observe(
    added: (message)->
      invalidMessage = true # basic assumption: everything is bad
      gameId = currentGame()._id
      unless message.time?
        switch message.team
          when 'white'
            switch message.action
              when 'inc'
                Games.update _id: gameId, { $inc: { 'white_team.score': 1 } }
                invalidMessage = false
              when 'dec'
                if currentGame().white_team.score > 0
                  Games.update _id: gameId, { $inc: { 'white_team.score': -1 } }
                  invalidMessage = false

          when 'black'
            switch message.action
              when 'inc'
                Games.update _id: gameId, { $inc: { 'black_team.score': 1 } }
                invalidMessage = false
              when 'dec'
                if currentGame().black_team.score > 0
                  Games.update _id: gameId, { $inc: { 'black_team.score': -1 } }
                  invalidMessage = false

      if invalidMessage
        MessageQueue.remove message._id
      else
        MessageQueue.update _id: message._id, { $set: { game: gameId, time: new Date() } }
  )