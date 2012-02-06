# Hoover

[![Build Status](https://secure.travis-ci.org/hakanensari/hoover-js.png)](http://travis-ci.org/hakanensari/hoover-js)

## Description

Hoover is a Node.js wrapper to the [Amazon Product Advertising API] [amazon].

![hoover] [hoover]

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
    console.dir res.toObject()
    console.dir res.find 'Item'

[hoover]: http://f.cl.ly/items/2B3x363M3B3m3X0W2K3i/vacuum.png
[amazon]: https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html
