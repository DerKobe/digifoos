if(!Players.findOne()) {
  Players.insert({name: 'Kobe',        gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Christoph',   gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Aggel',       gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Benni',       gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Hundefrisör', gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Oli',         gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Pan',         gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Daniel',      gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
  Players.insert({name: 'Roman',       gamesWon: 0, gamesLost: 0, score: 0, goalsMade: 0, goalsAgainst: 0, scoreHistory: []});
}