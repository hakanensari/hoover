util   = require 'util'
Hoover = require '../src/hoover'

req = new Hoover
  key:    process.env.AMAZON_KEY
  secret: process.env.AMAZON_SECRET
  tag:    process.env.AMAZON_TAG

req.build
  operation: 'ItemLookup'
  itemId:    '0816614024'

req.get (err, res) ->
  console.log util.inspect res.find('Item'), false, null
