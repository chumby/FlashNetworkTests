Net = require 'net'
FS = require 'fs'

class XMLSocketPolicyServer
	constructor:(@host='localhost',@port=843,@path='./xml_socket_policy.xml')->
		@policy = FS.readFileSync @path
		@server = Net.createServer (stream)=>
			stream.setEncoding 'utf8'
			stream.setTimeout 3000
			console.log "XMLSocketPolicyServer: started on port #{@port}"
			stream.on 'connect',=>
				console.log "XMLSocketPolicyServer: got connection from #{stream.remoteAddress}"
				@
			stream.on 'data',(data)=>
				if data=="<policy=file-request/>\0"
					console.log "XMLocketPolicyServer: got socket policy request from #{stream.remoteAddress}"
					stream.end "#{@policy}\0"
				else
					console.log "XMLSocketPolicyServer: bad request from #{stream.remoteAddress}: #{data}"
					stream.end()
				@
			stream.on 'end',=>
				stream.end()
				@
			stream.on 'error',(error)=>
				console.log "XMLSocketPolicyServer: error #{error}"
				@
			stream.on 'timeout',=>
				console.log "XMLSocketPolicyServer: timed out request from #{stream.remoteAddress}"
				stream.end()
				@
		console.log "XMLSocketPolicyServer: starting"
		@server.listen @port,@host,=>
			console.log "XMLSocketPolicyServer: listening on #{@host}:#{@port}"
			@

module.exports = XMLSocketPolicyServer