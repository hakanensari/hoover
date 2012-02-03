Vacuum = require '../lib/vacuum'

describe 'Vacuum', ->
  it 'returns a request', ->
    req = new Vacuum
    expect(typeof req).toBe 'object'
