var express = require('express');
var app =express();

app.get('/', function (req, res) {
    res.send('Hello world from fargate Cloud!');

});

app.listen(80, function(){
    console.log('App is listening on port 80!');
});