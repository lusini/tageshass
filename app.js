'use strict';
var events = require('events')
  , SMTPServer = require('./lib/smtp')
  , Store = require('./lib/store')
  , smtpServer = new SMTPServer()
  , queryEmitter = new events.EventEmitter() // TODO: dummy
  , store = new Store(smtpServer, queryEmitter)
  ;

/*jshint unused:false */ //TODO: store is not used yet
smtpServer.start(function (err) {
  if (err) {
    console.log('Failed to start SMTP Server:' + err);
    process.exit(1);
  }
  console.log('Started SMTP server on ' + smtpServer.getPort());
});
