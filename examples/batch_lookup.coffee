util   = require 'util'
Hoover = require '../src/hoover'

asins = [
  '0816614024',  '0143105825',  '0485113600',  '0816616779',  '0942299078',
  '0816614008',  '144006654X',  '0486400360',  '0486417670',  '087220474X',
  '0486454398',  '0268018359',  '1604246014',  '184467598X',  '0312427182',
  '1844674282',  '0745640974',  '0745646441',  '0826489540',  '1844672972'
]

req = new Hoover
  key:    process.env.AMAZON_KEY
  secret: process.env.AMAZON_SECRET
  tag:    process.env.AMAZON_TAG

req.add
  operation:                         'ItemLookup'
  version:                           '2010-11-01'
  'ItemLookup.Shared.IdType':        'ASIN'
  'ItemLookup.Shared.Condition':     'All'
  'ItemLookup.Shared.MerchantId':    'All'
  'ItemLookup.Shared.ResponseGroup': ['OfferFull', 'ItemAttributes']
  'ItemLookup.1.ItemId':             asins[0..9]
  'ItemLookup.2.ItemId':             asins[10..19]

req.get (err, res) ->
  console.log util.inspect res.toObject(), false, null
