Meteor.startup ->
  setupMessageQueueApi()
  startMessageQueueObserver()

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
      game = Games.findOne current: true

      if game && !message.time?
        switch message.team
          when 'white'
            switch message.action
              when 'inc'
                Games.update _id: game._id, { $inc: { 'whiteTeam.score': 1 } }
                invalidMessage = false
              when 'dec'
                if game.whiteTeam.score > 0
                  Games.update _id: game._id, { $inc: { 'whiteTeam.score': -1 } }
                  invalidMessage = false

          when 'black'
            switch message.action
              when 'inc'
                Games.update _id: game._id, { $inc: { 'blackTeam.score': 1 } }
                invalidMessage = false
              when 'dec'
                if game.blackTeam.score > 0
                  Games.update _id: game._id, { $inc: { 'blackTeam.score': -1 } }
                  invalidMessage = false

      if invalidMessage
        MessageQueue.remove message._id
      else
        MessageQueue.update _id: message._id, { $set: { game: game._id, time: new Date() } }
  )