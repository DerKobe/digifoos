Meteor.startup ->
  setupMessageQueueApi()
  startMessageQueueObserver()

  unless Games.findOne()
    console.log 'No game were found. Creating one.'
    Games.insert(
      created_at: new Date()
      current: true
      whiteTeam:
        score: 0
        players: [ {name: 'Adam'},{name: 'Eva'} ]
      blackTeam:
        score: 0
        players: [ {name: 'Dick'},{name: 'Doof'} ]
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
      currentGame = Games.findOne current: true

      if currentGame && !message.time?
        switch message.team
          when 'white'
            switch message.action
              when 'inc'
                Games.update _id: currentGame._id, { $inc: { 'whiteTeam.score': 1 } }
                invalidMessage = false
              when 'dec'
                if currentGame.whiteTeam.score > 0
                  Games.update _id: currentGame._id, { $inc: { 'whiteTeam.score': -1 } }
                  invalidMessage = false

          when 'black'
            switch message.action
              when 'inc'
                Games.update _id: currentGame._id, { $inc: { 'blackTeam.score': 1 } }
                invalidMessage = false
              when 'dec'
                if currentGame.blackTeam.score > 0
                  Games.update _id: currentGame._id, { $inc: { 'blackTeam.score': -1 } }
                  invalidMessage = false

      if invalidMessage
        MessageQueue.remove message._id
      else
        MessageQueue.update _id: message._id, { $set: { game: currentGame._id, time: new Date() } }
  )