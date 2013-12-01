Template.layout.helpers
  navClasses: (path)->
    classes = ''

    if window.location.pathname == path
      classes = 'active'

    currentGame = Games.findOne(current: true)?
    if path == '/new-game' && currentGame
      classes = "#{classes} hide"
    else if path == '/current-game' && !currentGame
      classes = "#{classes} hide"

    classes
