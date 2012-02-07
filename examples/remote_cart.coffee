util   = require 'util'
Hoover = require '../src/hoover'

req = new Hoover
  key:    process.env.AMAZON_KEY
  secret: process.env.AMAZON_SECRET
  tag:    process.env.AMAZON_TAG

req
  .add
    operation:     'ItemLookup'
    itemId:        '0816614024'
    responseGroup: 'Offers'
  .get (res) ->
    id = res.find('OfferListingId')[0]
    req
      .reset()
      .add
        operation:               'CartCreate'
        'Item.1.OfferListingId': id
        'Item.1.Quantity':       1

      req.get (res) ->
        console.log util.inspect res.find('Cart'), false, null
