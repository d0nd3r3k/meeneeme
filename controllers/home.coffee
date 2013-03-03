request = require 'request'
path = require("path")

get_checkings = (req, res) ->
  if req.session.accessToken?
    SINGLY_BASE = 'https://api.singly.com/services/foursquare/checkins'
    TOKEN = '?access_token='
    URL = SINGLY_BASE + TOKEN + req.session.accessToken
    request URL, (err, response, body) ->
      body = JSON.parse body
      data = {
        id: body[0].id
        venue: body[0].data.venue.categories[0].parents[0]
      }
      res.send data
  else
    res.redirect "/"

exports.setup = (app) ->
  app.get "/", (req, res) ->
    if req.session.accessToken?
      res.sendfile(path.join(__dirname, "../public/index.html"))
    else
      res.render "index",
        env: "staging"

  app.get "/checkins", (req, res) ->
    get_checkings(req, res)
