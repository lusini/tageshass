'use strict';
var SMTPServer = require('./lib/smtp')
  , smtpServer = new SMTPServer();
smtpServer.start(function (err) {
  if (err) {
    console.log('Failed to start SMTP Server:' + err);
    process.exit(1);
  }
  console.log('Started SMTP server on ' + smtpServer.getPort());
});
