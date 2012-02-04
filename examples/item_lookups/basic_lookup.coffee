Vacuum = require '../../lib/vacuum'

req = new Vacuum
  key:    process.env.AMAZON_KEY
  secret: process.env.AMAZON_SECRET
  tag:    process.env.AMAZON_TAG

req.add
  operation: 'ItemLookup'
  itemId:    '0816614024'

req.get (res) ->
  console.dir res.data
