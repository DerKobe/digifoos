Meteor.publish 'games', -> Games.find()
Meteor.publish 'players', -> Players.find()