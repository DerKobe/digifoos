unless Players.findOne() || Games.findOne()
  p1 = Players.insert name: 'Philip',    gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0
  p2 = Players.insert name: 'Christoph', gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0
  p3 = Players.insert name: 'Axel',      gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0
  p4 = Players.insert name: 'Ben',       gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0
  p5 = Players.insert name: 'Oli',       gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0
  p6 = Players.insert name: 'Pan',       gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0
  p7 = Players.insert name: 'Daniel',    gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0
  p8 = Players.insert name: 'Roman',     gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0

#  Games.insert(
#    current: true,
#    whiteTeam: {
#      players: [
#        { _id: p1, name: 'Philip' }
#        { _id: p2, name: 'Christoph' }
#      ]
#      score: 0
#    }
#    blackTeam: {
#      players: [
#        { _id: p3, name: 'Axel' }
#        { _id: p4, name: 'Ben' }
#      ]
#      score: 0
#    }
#    created_at: new Date()
#  )
#
#  Games.insert(
#    whiteTeam: {
#      players: [
#        { _id: p5, name: 'Oli' }
#        { _id: p6, name: 'Pan' }
#      ]
#      score: 0
#    }
#    blackTeam: {
#      players: [
#        { _id: p7, name: 'Daniel' }
#        { _id: p8, name: 'Roman' }
#      ]
#      score: 0
#    }
#    created_at: new Date()
#  )