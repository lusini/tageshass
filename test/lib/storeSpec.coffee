Store = require('../../lib/store')
events = require('events')
sinon = require('sinon')
chai = require('chai')
chai.use(require('sinon-chai'))

expect = chai.expect

describe 'Store', ->
  messageEmitter = new events.EventEmitter()
  searchEmitter =
  store =

  beforeEach ->
    searchEmitter = new events.EventEmitter()
    store = new Store(messageEmitter, searchEmitter)

  describe 'receiveMessage()', ->
    it 'pushes a message to the messages array', ->
      theMessageObject = { envelope: {}, message: {} }
      messageEmitter.emit('message', theMessageObject)
      expect(store.messages).to.have.length(1)
      expect(store.messages[0]).to.equal(theMessageObject)

    it 'runs all waiting queries against the new message', ->
      sinon.stub(store, 'match')

      query1 = { to: 'harrihirsch@example.com' }
      query2 = { from: 'harrihirsch@example.com' }
      store.addQuery(query1)
      store.addQuery(query2)

      message = {}
      store.receiveMessage(message)

      expect(store.match).to.have.been.calledTwice
      expect(store.match).to.have.been.calledWith(query1, message)
      expect(store.match).to.have.been.calledWith(query2, message)

    it 'emits the message if a query matches', ->
      sinon.spy(searchEmitter, 'emit')
      sinon.stub(store, 'match').returns(true)

      queryId = 'myId'
      store.addQuery({ queryId: queryId })

      message = {}
      store.receiveMessage(message)

      eventName = 'result:'+queryId
      expect(searchEmitter.emit).to.have.been.calledOnce
      expect(searchEmitter.emit).to.have.been.calledWith(eventName, [message])


  it 'pushes a query to the queries array', ->
    theQuery = { to: 'foo@example.com' }
    searchEmitter.emit('query', theQuery)
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
