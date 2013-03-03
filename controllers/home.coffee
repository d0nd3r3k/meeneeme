request = require 'request'
path = require("path")

get_checkings = (req, res) ->
  SINGLY_BASE = 'https://api.singly.com/services/foursquare/checkins'
  TOKEN = '?access_token='
  URL = SINGLY_BASE + TOKEN + req.session.accessToken
  console.log URL
  request URL, (err, response, body) ->
    res.send body

exports.setup = (app) ->
  app.get "/", (req, res) ->
    if req.session.accessToken?
      res.sendfile(path.join(__dirname, "../public/index.html"))
    else
      res.render "index",
        env: "staging"

  app.get "/checkins", (req, res) ->
    get_checkings(req, res)
