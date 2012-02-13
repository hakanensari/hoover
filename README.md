# Hoover

[![Build Status] [status]] [travis]

![hoover] [hoover]

## Description

Hoover is a Node.js wrapper to the [Amazon Product Advertising API] [amazon].

The API gives you access to the Amazon product catalogues in the [US] [us],
[UK] [uk], [Germany] [germany], [Canada] [canada], [France] [france],
[Japan] [japan], [Italy] [italy], [Spain] [spain], and [China] [china].

## Installation

```bash
npm install hoover
```

## Usage

```coffee
Hoover = require 'hoover'

req = new Hoover
  key:    'key'
  secret: 'secret'
  tag:    'tag'
  locale: 'uk'

req
  .add
    operation:   'ItemSearch'
    keywords:    'Deleuze'
    searchIndex: 'All'
  .get (err, res) ->
    # res.toJS()
    res.find 'Item', (item) ->
      console.dir item
```

## Further Reading

* [Examples] [examples]
* [Amazon API docs] [api]
* [Annotated source] [source]

[status]: https://secure.travis-ci.org/hakanensari/hoover.png
[travis]: http://travis-ci.org/hakanensari/hoover
[hoover]: http://f.cl.ly/items/1Q3W372A0H3M0w2H1e0W/hoover.jpeg
[amazon]: https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html
[us]: http://www.amazon.com
[uk]: http://www.amazon.co.uk
[germany]: http://www.amazon.de
[canada]: http://www.amazon.ca
[france]: http://www.amazon.fr
[japan]: http://www.amazon.co.jp
[italy]: http://www.amazon.it
[spain]: http://www.amazon.es
[china]: http://www.amazon.cn
[examples]: https://github.com/hakanensari/hoover/tree/master/examples
[api]: http://aws.amazon.com/archives/Product%20Advertising%20API
[source]: http://hakanensari.com/hoover/index.html
