Store = require('../../lib/store')
events = require('events')
sinon = require('sinon')
chai = require('chai')
chai.use(require('sinon-chai'))

expect = chai.expect

describe 'Store', ->
  messageEmitter = new events.EventEmitter()
  queryEmitter = new events.EventEmitter()
  store =

  beforeEach ->
    store = new Store(messageEmitter, queryEmitter)

  it 'pushes a message to the messages array', ->
    theMessageObject = { envelope: {}, message: {} }
    messageEmitter.emit('message', theMessageObject)
    expect(store.messages).to.have.length(1)
    expect(store.messages[0]).to.equal(theMessageObject)


  it 'pushes a query to the queries array', ->
    theQuery = { to: 'foo@example.com' }
    queryEmitter.emit('query', theQuery)
    expect(store.queries).to.have.length(1)
    expect(store.queries[0]).to.equal(theQuery)

  describe 'match()', ->
    message =

    beforeEach ->
      message = {
        envelope: { from: {}, to: {} },
        message: {}
      }

    describe 'to: filter', ->
      recipient = 'recipient@example.com'

      beforeEach ->
        message = {
          envelope: { to: { address: recipient } },
          message: {}
        }

      it 'returns false for to: query with other recipient', ->
        query = { to: 'someone@else.com' }
        expect(store.match(query, message)).to.equal(false)

      it 'returns true for to: query', ->
        query = { to: recipient }
        expect(store.match(query, message)).to.equal(true)

    describe 'from: filter', ->
      sender = 'sender@example.com'

      beforeEach ->
        message = {
          envelope: { from: { address: sender } },
          message: {}
        }

      it 'returns false for from: query with other sender', ->
        query = { from: 'someone@else.com' }
        expect(store.match(query, message)).to.equal(false)

      it 'returns true for matching from: query', ->
        query = { from: sender }
        expect(store.match(query, message)).to.equal(true)

    describe 'combining to: and from: filter', ->
      recipient = 'recipient@example.com'
      sender = 'sender@example.com'

      beforeEach ->
        message = {
          envelope: {
            to: { address: recipient },
            from: { address: sender }
          },
          message: {}
        }

      it 'returns false if from is wrong', ->
        query = { to: recipient, from: 'someoneelse@exmaple.com' }
        expect(store.match(query, message)).to.equal(false)

      it 'returns false if to is wrong', ->
        query = { to: 'someoneelse@example.com', from: sender }
        expect(store.match(query, message)).to.equal(false)

      it 'returns true if both match', ->
        query = { to: recipient, from: sender }
        expect(store.match(query, message)).to.equal(true)
