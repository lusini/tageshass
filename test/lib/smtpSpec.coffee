SMTPServer = require('../../lib/smtp')
sinon = require('sinon')
chai = require('chai')
chai.use(require('sinon-chai'))

expect = chai.expect
simplesmtp = require('simplesmtp')

describe 'SMTP server', ->
  server =

  beforeEach ->
    server = new SMTPServer()
    server.start()

  sendMail = (from, to, done) ->
    client = simplesmtp.connect(server.getPort())
    client.once 'idle', ->
      client.useEnvelope {
        from: from,
        to: to
      }

    client.on 'message', ->
      client.write('From: ' + from + '\n')
      client.write('To: ' + to + '\n')
      client.write('Subject: ' + 'My Subject' + '\n')
      client.write('\n')
      client.end('body')

    client.on 'ready', (success, response) ->
      if (success)
        return done(null)
      return done(success)


  it 'emits exactly one event with the message', (done) ->
    sinon.stub(server, 'emit')
    sender = 'sender@test.de'
    recipient = 'receiver@test.de'
    sendMail sender, [recipient], (err) ->
      expect(err).to.equal(null)
      expect(server.emit).to.have.been.calledOnce
      expect(server.emit).to.have.been.calledWith('message', sinon.match({
        envelope: {
          from: sender,
          to: [recipient]
        },
        message: {
          text: 'body'
        }
      }))
      done()

  it 'exposes its port', ->
    expect(server.getPort()).to.be.a('Number')
    expect(server.getPort()).to.be.greaterThan(0)

