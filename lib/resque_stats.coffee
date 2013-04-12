{EventEmitter} = require 'events'
moment = require 'moment'

module.exports = class ResqueStats extends EventEmitter
  constructor: (@window) ->
    super()
    @measurements = []

  push: (time, lengths) =>
    @measurements.push timestamp: time, lengths: lengths
    @trimOldMeasurements(time)
    @emit 'data', @mostRecentStats()

  trimOldMeasurements: (timestamp) =>
    while @measurements.length > 0 && (@measurements[0].timestamp <= moment(timestamp).subtract('milliseconds', @window))
      @measurements.shift()

  mostRecentStats: =>
    lastMeasurement  = @measurements[@measurements.length - 1]
    firstMeasurement = @measurements[0]
    queues = Object.keys(lastMeasurement.lengths)

    stats = {}
    for queue in queues
      if @measurements.length > 1
        deltaMeasurement = lastMeasurement.lengths[queue] - firstMeasurement.lengths[queue]
        deltaTime = moment(lastMeasurement.timestamp).seconds() - moment(firstMeasurement.timestamp).seconds()
        delta = deltaMeasurement / deltaTime
      else
        delta = 0

      stats[queue] =
        currentLength: lastMeasurement.lengths[queue]
        averageDelta: delta

    stats
