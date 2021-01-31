Net = require 'net'

class XMLSocketServer
	constructor:(@host='localhost',@port=3030)->
		@name = @getName()
		@streams = []
		@server = Net.createServer (stream)=>
			@streams.push stream
			stream.setTimeout 0
			stream.setEncoding 'utf8'
			console.log "#{@name}: started on port #{@port}"
			stream.on 'connect',=>
				console.log "#{@name}: client connected from #{stream.remoteAddress}"
				@emitData stream,"<connected/>"
				@
			stream.on 'end',=>
				console.log "#{@name}: ending connection" #" from #{stream.remoteAddress}"
				#@streams.delete stream ### DSM should fix this
				@
			stream.on 'error',(error)=>
				console.log "#{@name}: error #{error} from #{stream.remoteAddress}"
				@
			stream.on 'data',(data)=>
				data = data.slice 0,-1 # remove trailing null
				@onData stream,data
				@
		console.log "#{@name}: starting"
		@server.listen @port,@host,()=>
			console.log "#{@name}: listening on #{@host}:#{@port}"
			@
	
	getName:-> "XMLSocketServer"

	onData:(stream,data)->
		console.log "#{@name}: got data from #{stream.remoteAddress}"
		console.log data
		@

	emitData:(stream,data)->
		stream.write data+"\0"
		
	emitDataToAll:(data)->
		@emitData stream,data for stream in @streams
		@
		
module.exports = XMLSocketServer
