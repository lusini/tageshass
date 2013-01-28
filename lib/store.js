'use strict';
var sinon = require('sinon');

function Store(mailEmitter, searchEmitter) {
  this.messages = [];
  this.queries = [];
  mailEmitter.on('message', this.receiveMessage.bind(this));
  searchEmitter.on('query', this.addQuery.bind(this));
}

Store.prototype.receiveMessage = function receiveMessage(message) {
  this.messages.push(message);
};

Store.prototype.addQuery = function addQuery(query) {
  this.queries.push(query);
};

Store.prototype.match = function match(query, message) {
  var sinonQuery = {
    envelope: {
    },
    message: {}
  };
  if (query.hasOwnProperty('to')) {
    sinonQuery.envelope.to = { address: query.to };
  }
  if (query.hasOwnProperty('from')) {
    sinonQuery.envelope.from = { address: query.from };
  }
  return sinon.match(sinonQuery).test(message);
};

module.exports = Store;
