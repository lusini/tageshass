Store = require('../../lib/store')
events = require('events')
sinon = require('sinon')
chai = require('chai')
chai.use(require('sinon-chai'))

expect = chai.expect

describe 'Store', ->
  emitter = new events.EventEmitter()
  store =

  beforeEach ->
    store = new Store(emitter)

  it 'pushes a message to the messages array', ->
    theMessageObject = { envelope: {}, message: {} }
    emitter.emit('message', theMessageObject)
    expect(store.messages).to.have.length(1)
    expect(store.messages[0]).to.equal(theMessageObject)
