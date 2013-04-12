{EventEmitter} = require 'events'
moment = require 'moment'

module.exports = class ResqueStats extends EventEmitter
  constructor: (@poller, @window) ->
    super()
    @events = []
    @poller.on 'data', @onData
    @poller.on 'end', @onEnd

  onData: (event) =>
    @events.push event
    @trimOldEvents(event.timestamp)
    @emit 'data', @mostRecentStats()

  onEnd: (event) =>
    @onData(event) if event?
    @emit 'end'

  trimOldEvents: (timestamp) =>
    while @events.length > 0 && (@events[0].timestamp <= moment(timestamp).subtract('milliseconds', @window))
      @events.shift()

  mostRecentStats: =>
    # console.log 'events', @events
    lastEvent  = @events[@events.length - 1]
    firstEvent = @events[0]
    queues = Object.keys(lastEvent.lengths)

    stats = {}
    for queue in queues
      if @events.length > 1
        delta = (lastEvent.lengths[queue] - firstEvent.lengths[queue]) / (moment(lastEvent.timestamp).seconds() - moment(firstEvent.timestamp).seconds())
      else
        delta = 0

      stats[queue] =
        currentLength: lastEvent.lengths[queue]
        averageDelta: delta

    stats
