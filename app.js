var express = require('express');
var request = require('request');

var app = express();


var MemoryStore = express.session.MemoryStore;
var sessionStore = new MemoryStore();


//Configure Server.
app.configure(function(){
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.static(__dirname+'/public'));
    app.use(express.cookieParser());

    app.use(express.session({
        store: sessionStore,
        secret: 'secret', 
        key: 'express.sid'
    }));
    app.use(express.errorHandler({
        dumpExceptions: true, 
        showStack: true
    })); //Show errors in development
    app.use(app.router);
    
});

var config = {
    'secrets' : {
        'clientId' : 'DRXCDIDVDYWKOZO5ZT5RKANJVDRUSFEZT1CJ0U2VJDUI1YYU',
        'clientSecret' : 'BU4HWLOWGHTDJEF1DF0DTL3Q22PQ3S15M5DUY4IJOB3OINXV',
        'redirectUrl' : 'http://localhost:8080/callback'
    }
}

var Foursquare = require('node-foursquare')(config);

app.get('/login', function(req, res) {
    res.writeHead(303, {
        'location': Foursquare.getAuthClientRedirectUrl()
    });
    res.end();
});


app.get('/callback', function (req, res) {
    Foursquare.getAccessToken({
        code: req.query.code
    }, function (error, accessToken) {
        if(error) {
            res.send('An error was thrown: ' + error.message);
        }
        else {
            // Save the accessToken and redirect.
                
            res.redirect('/meeneeme');
        }
    });
});

app.get('/meeneeme', function(req,res){
    res.send("hello");
    console.log(req.session);
});
app.listen(8080);

