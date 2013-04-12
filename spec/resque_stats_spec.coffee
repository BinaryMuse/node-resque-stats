{EventEmitter} = require 'events'
sinon = require 'sinon'
chai = require 'chai'
should = chai.should()
sinonChai = require 'sinon-chai'
moment = require 'moment'
helpers = require './spec_helper'

ResqueStats = require '../lib/resque_stats'

chai.use(sinonChai)

describe 'ResqueStats', ->
  it 'computes average queue length delta over the given window', (done) ->
    stats  = new ResqueStats(3 * 1000)

    time = moment()
    secondsAgo = (n) ->
      moment(time).subtract('seconds', n)

    dataFromInfo = [
      { timestamp: secondsAgo(4), lengths: { mailer: 10, adder: 0  } }
      { timestamp: secondsAgo(3), lengths: { mailer: 9,  adder: 10 } }
      { timestamp: secondsAgo(2), lengths: { mailer: 8,  adder: 20 } }
      { timestamp: secondsAgo(1), lengths: { mailer: 7,  adder: 30 } }
      { timestamp: secondsAgo(0), lengths: { mailer: 6,  adder: 40 } }
    ]

    events = 0
    stats.on 'data', (statistics) ->
      if ++events == dataFromInfo.length
        statistics.should.deep.eql
          mailer:
            currentLength: 6
            averageDelta: -1
          adder:
            currentLength: 40
            averageDelta: 10
        done()

    stats.push(data.timestamp, data.lengths) for data in dataFromInfo
