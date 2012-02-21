util   = require 'util'
Hoover = require '../src/hoover'

for locale in Object.keys Hoover::HOSTS
  new Hoover
    locale: locale
    key:    process.env.AMAZON_KEY
    secret: process.env.AMAZON_SECRET
    tag:    process.env.AMAZON_TAG
  .build
    operation: 'ItemLookup'
    itemId:    '0816614024'
  .get (err, res) ->
    console.log util.inspect res.find('Item'), false, null
