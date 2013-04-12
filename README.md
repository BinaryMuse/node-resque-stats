node-resque-stats
=================

[![Build Status](https://travis-ci.org/BinaryMuse/node-resque-stats.png?branch=master)](https://travis-ci.org/BinaryMuse/node-resque-stats)

node-resque-stats is a Node.js library that you can use to get aggregate statistical information about a Resque instance.

(Note: project is under construction)

Installation
============

    npm install resque-stats

Compatibility
=============

node-resque-stats is currently targeted at Resque 1.x. Version 2.0 support is planned after Resque 2.0 is released.

Usage
=====

node-resque-stats works with [node-resque-info](https://github.com/BinaryMuse/node-resque-info) to provide real-time updates and statistics on your Resque infrastructure.

```javascript
var info = require('resque-info');
var stats = require('resque-stats');

var stats = new stats.ResqueStats(poller, 5 * 1000);
stats.on('data', function(statistics) {
  console.log(statistics);
});
stats.push(date, lengths);
```

`ResqueStats`
-------------
