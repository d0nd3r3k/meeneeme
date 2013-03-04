request = require 'request'
path = require("path")

test = (req, res) ->
  if req.session.accessToken?
    SINGLY_BASE = 'https://api.singly.com/services/foursquare/checkins'
    TOKEN = '?access_token='
    URL = SINGLY_BASE + TOKEN + req.session.accessToken
    request URL, (err, response, body) ->
      body = JSON.parse body
      res.send body[0]
  else
    res.redirect "/"


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
      if data.id != req.session.last_id
        res.send data
        req.session.last_id = data.id
      else
        res.send null
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

  app.get "/test", (req, res) ->
    test(req, res)