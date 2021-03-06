util   = require 'util'
Hoover = require '../src/hoover'

req = new Hoover
  key:    process.env.AMAZON_KEY
  secret: process.env.AMAZON_SECRET
  tag:    process.env.AMAZON_TAG

req
  .build
    operation:     'ItemLookup'
    itemId:        '0816614024'
    responseGroup: 'Offers'
  .get (err, res) ->
    id = res.find('OfferListingId')[0]
    req
      .reset()
      .build
        'operation':             'CartCreate'
        'Item.1.OfferListingId': id
        'Item.1.Quantity':       1

      req.get (err, res) ->
        console.log inspect res.find('Cart'), false, null
