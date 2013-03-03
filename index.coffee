#===================#
# Module Dependency
#===================#
http = require("http")
path = require("path")

#===================#
# The App itself
#===================#
express = require("express")
request = require("request")
app = express()
server = require("http").createServer(app)

#===================#
# Express config
#===================#
# Your client ID and secret from http://dev.singly.com/apps
clientId = "8e426d7c4a7d9e715f9035541766dc9c"
clientSecret = "14835b5b2b35ff7a4c8cee8589524358"
port = process.env.PORT or 8080
hostBaseUrl = (process.env.HOST or "http://localhost:" + port)

apiBaseUrl = process.env.SINGLY_API_HOST or "https://api.singly.com"

# Require and initialize the singly module
expressSingly = require("express-singly")(app, clientId, clientSecret, hostBaseUrl, hostBaseUrl + "/callback")

app.configure ->
  app.set "port", process.env.PORT or 8080
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.compress()
  app.use express.logger("dev")
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.session(
    store: new express.session.MemoryStore()
    secret: "NoXZp0SV"
    key: "wCX8FEXH"
  )
  expressSingly.configuration()
  app.use app.router
  app.use express.static(path.join(__dirname, "/public"))
expressSingly.routes()


app.configure "development", ->
  app.use express.errorHandler()

controller_loader = require "./lib/controller_loader"
controller_loader.load(app)

# -- Start da serva!
server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

app.get "/", (req, res) ->
  # Render out views/index.ejs, passing in the session
  res.render "index",
    session: req.session
