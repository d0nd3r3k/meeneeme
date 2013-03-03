exports.load = (app) ->
  #Load in the controllers
  # Greatly Inspired by this link:
  # http://stackoverflow.com/questions/5778245/expressjs-how-to-structure-an-application
  ["home"].map (controllerName) ->
    controller = require "../controllers/" + controllerName
    controller.setup app
