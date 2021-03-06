should = require('should')
expect = require('expect')
RequestBuilder = require('../lib/request_builder')
Order = require('../lib/requests/create_order')
Endpoint = require('../lib/endpoint')

describe 'RequestBuilder', ->
  builder = new RequestBuilder()

  it 'should be exported as a single class', ->
    RequestBuilder.should.be.type 'function'
    RequestBuilder.name.should.equal 'RequestBuilder'

  describe 'initialization', ->
    it 'should default to version 1 and sandbox', ->
      builder.version.should.equal('v1')
      builder.endpoint.should.equal(Endpoint.defaults.sandbox)

  describe 'requests', ->
    it 'should be able to build a request based on endpoint', ->
      req = builder.buildRequest('GET', 'some/api/path')
      req.method.should.equal 'GET'
      req.url.should.equal 'https://sandbox.buttercoin.com/v1/some/api/path'
      req.strictSSL.should.equal true

      localEndpoint = new Endpoint(protocol: 'http', port: 9003, host: 'localhost')
      localBuilder = new RequestBuilder(localEndpoint, 'v2')
      req = localBuilder.buildRequest('POST', 'do/a/thing')
      req.method.should.equal 'POST'
      req.url.should.equal 'http://localhost:9003/v2/do/a/thing'
      req.strictSSL.should.equal false
      req._auth.should.equal true

    it 'should work with a leading slash on the path', ->
      req = builder.buildRequest('GET', '/some/api/path')
      req.url.should.equal 'https://sandbox.buttercoin.com/v1/some/api/path'

    it 'should be able to specify auth options', ->
      req = builder.buildRequest('GET', 'some/api/path', auth: false)
      req._auth.should.equal false

    it 'should create a querystring for get requests', ->
      query = {foo: 'bar', x: 2}
      builder.buildRequest('GET', '', qs: query).qs.should.equal query
      builder.buildRequest('GET', '', query: query).qs.should.equal query
      builder.buildRequest('GET', '', body: query).qs.should.equal query

