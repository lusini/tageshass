'use strict';
var simplesmtp = require('simplesmtp')
  , util = require('util')
  , events = require('events')
  , mailparser = require('mailparser')
  , uuid = require('node-uuid')
  ;

function SMTPServer() {
  events.EventEmitter.call(this);
  this.smtp = simplesmtp.createServer();
}
util.inherits(SMTPServer, events.EventEmitter);

SMTPServer.prototype.getPort = function getPort() {
  return parseInt(this.smtp.SMTPServer._server.address().port, 10);
};

SMTPServer.prototype.start = function start() {
  var self = this;
  this.smtp.listen(0, function (err) {
    if (err) {
      process.exit(1);
    }

    self.smtp.on('startData', function (envelope) {
      envelope.parser = new mailparser.MailParser();
      envelope.parser.on('end', function (message) {
        delete envelope.parser;
        self.emit('message', {
          envelope: envelope,
          message: message
        });
      });
    });

    self.smtp.on('data', function (envelope, chunk) {
      envelope.parser.write(chunk);
    });

    self.smtp.on('dataReady', function (envelope, callback) {
      var queueId = uuid.v1();
      envelope.parser.end();
      callback(null, queueId);
    });

    console.log('Started SMTP server on ' + self.getPort());
  });
};

module.exports = SMTPServer;
