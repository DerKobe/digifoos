if(!Players.findOne() && !Games.findOne()) {
  Players.insert({name: 'Philip',    gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Christoph', gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Axel',      gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Ben',       gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Oli',       gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Pan',       gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Daniel',    gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Roman',     gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
}