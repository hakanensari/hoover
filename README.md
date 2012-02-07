# Hoover

[![Build Status](https://secure.travis-ci.org/hakanensari/hoover.png)](http://travis-ci.org/hakanensari/hoover)

## Description

Hoover is a Node.js wrapper to the [Amazon Product Advertising API] [amazon].

The API gives you access to Amazon's product catalogues in eight countries.

![vacuum] [vacuum]

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
  .get (res) ->
    for item in res.find 'Item'
      console.dir item
```

For further reading, check the examples or [read the API docs] [api].

## Afterword

![hoover] [hoover]

[vacuum]: http://f.cl.ly/items/2B3x363M3B3m3X0W2K3i/vacuum.png
[amazon]: https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html
[api]: http://aws.amazon.com/archives/Product%20Advertising%20API
[hoover]: http://f.cl.ly/items/1Q3W372A0H3M0w2H1e0W/hoover.jpeg
