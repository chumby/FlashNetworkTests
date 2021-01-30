HTTP = require 'http'
URL = require 'url'
QueryString = require 'querystring'
FS = require 'fs'

class HTTPServer
	constructor:(@port=80)->
		@routes =
			get: []
			post: []
			put: []
			delete: []
		@name = @getName()
		@server = HTTP.createServer (request,response)=>
			console.log "#{@name}: received request"
			@dispatch request,response
		console.log "#{@name}: starting"
		@server.listen @port,=>
			console.log "#{@name} listening on port #{@port}"
			@
	
	getName:->"HTTPServer"

	_extend:(obj_dst, obj_src) ->
		for key, val of obj_src
			obj_dst[key] = val
		obj_dst
	
	_pushRoute:(pattern,handler,method)->
		params = null
		if typeof pattern is 'string'
			parsed = @_parsePattern pattern
			pattern = new RegExp "^#{parsed.pattern}$"
			params = parsed.params
		@routes[method].push {pattern:pattern, handler:handler,params:params}
		@routes[method].sort (r1,r2) -> r2.pattern.toString().length > r1.pattern.toString().length
		@
	
	_parsePattern:(pattern)->
		re = /\/:([A-Za-z0-9_]+)+/g
		m = pattern.match re
		if m
			params = (x.slice(2) for x in m)
			pattern = pattern.replace re, "/([A-Za-z0-9_\\-\\.\\,\\%\\{\\}\\:\\\"\\']+)"
		else
			params = null
		{pattern:pattern,params:params}
		
	_404:(req,res,pathName='') ->
		res.writeHead 404, {'Content-Type': 'text/html'}
		res.end """
						<html><head/><body>
						<h2>404 - Resource #{pathName} not found at this server</h2>
						<p style="text-align: center;"><button onclick='history.back();'>Back</button></p>
						</body></html>
						"""
		@

	get:(pattern,handler)->
		@_pushRoute pattern,handler,'get'
		@
	
	post:(pattern,handler)->
		@_pushRoute pattern,handler,'post'
		@
	
	put:(pattern,handler)->
		@_pushRoute pattern,handler,'put'
		@
	
	delete:(pattern,handler)->
		@_pushRoute pattern,handler,'delete'
		@

	file:(req,res,path,mimeType='application/octet-stream')->
		if FS.existsSync path
			res.writeHead 200,{'Content-Type' : mimeType}
			res.end FS.readFileSync path
		else
			@_404(res,res)
		@
	
	getPostBody:(req,callback)->
		body = ""
		req.setEncoding 'utf8'
		req.on 'data',(data)=>
			body += data
			@
		req.on 'end',=>
			callback body
			@
		@

	dispatch:(req,res,error = @_404)->
		parsed = URL.parse req.url
		pathName = parsed.pathname
		req.get = if parsed.query? then QueryString.parse parsed.query else {}
		req.body = @_extend {}, req.get
		method = req.method.toLowerCase()
		for route in @routes[method]
			m = pathName.match route.pattern
			if m isnt null
				if route.params
					req.params = {}
					args = m.slice 1
					for param,index in route.params
						req.params[param] = unescape args[index]
				return route.handler req,res
		error req,res,pathName

module.exports = HTTPServer
