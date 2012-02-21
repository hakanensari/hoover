Hoover = require '../src/hoover'

req = new Hoover
  key:    process.env.AMAZON_KEY
  secret: process.env.AMAZON_SECRET
  tag:    process.env.AMAZON_TAG

req.build
  operation:   'ItemSearch'
  keywords:    'Deleuze'
  searchIndex: 'All'

req.get (err, res) ->
  res.find 'Item', (item) ->
    console.log item['ItemAttributes']['Title']
