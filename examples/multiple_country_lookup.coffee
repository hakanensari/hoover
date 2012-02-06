util   = require 'util'
Vacuum = require '../src/vacuum'

for locale in Object.keys Vacuum::HOSTS
  new Vacuum
    locale: locale
    key:    process.env.AMAZON_KEY
    secret: process.env.AMAZON_SECRET
    tag:    process.env.AMAZON_TAG
  .add
    operation: 'ItemLookup'
    itemId:    '0816614024'
  .get (res) ->
    console.log util.inspect res.find('Item'), false, null
