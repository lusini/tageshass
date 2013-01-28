'use strict';

function Store(mailEmitter) {
  this.messages = [];
  mailEmitter.on('message', this.receiveMessage.bind(this));
}

Store.prototype.receiveMessage = function receiveMessage(message) {
  this.messages.push(message);
};

module.exports = Store;
