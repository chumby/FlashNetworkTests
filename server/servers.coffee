XMLSocketPolicyServer = require './xml_socket_policy_server'
XMLSocketServer = require './xml_socket_server'
HTTPServer = require './http_server'
PigLatin = require './pig_latin'

#
# just echo the incoming XML data
#
class XMLSocketEchoServer extends XMLSocketServer
	getName:->"XMLSocketEchoServer"
	onData:(stream,data)->
		@emitData stream,data

#
# translates all XML text, attributes, node and attribute names to pig latin.
#
# <translate text="some text"/>  ----> <anslatetray exttay="omesay exttay"/>
#

class XMLSocketPigLatinServer extends XMLSocketServer
	getName:->"XMLSocketPigLatinServer"
	onData:(stream,data)->
		@emitData stream,PigLatin.translate data

#
# simple routing HTTP server to handle some common Flash requests
#
class HTTPFlashServer extends HTTPServer
	constructor:(port=80)->
		super port
		@get "/crossdomain.xml",(req,res)=>
			console.log "#{@name}: request fro crossdomain.xml"
			@file req,res,"crossdomain.xml","application/xml"
		@get "/loadvars/load",(req,res)=>@file req,res,"loadvars_load.txt","application/x-www-form-urlencoded"
		@post "/loadvars/send_and_load",(req,res)=>@loadvars_send_and_load req,res # used by standalone player
		@post "/loadvars/send_and_load",(req,res)=>@loadvars_send_and_load req,res # used by browser plugin and Flash Lite
		@get "/xml/load",(req,res)=>@file req,res,"xml_load.xml","application/xml"
		@get "/xml/send_and_load",(req,res)=>@xml_send_and_load req,res # used by standalone player
		@post "/xml/send_and_load",(req,res)=>@xml_send_and_load req,res # used by browser plugin and FlashvLite
	
	loadvars_send_and_load:(req,res)->
		@getPostBody req,(data)=>
			res.writeHead 200,{'Content-Type' : 'x-www-form-urlencoded'}
			res.end PigLatin.translate data
			@

	xml_send_and_load:(req,res)->
		@getPostBody req,(data)=>
			res.writeHead 200,{'Content-Type' : 'application/xml'}
			res.end PigLatin.translate data
			@
		@

	getName:->"HTTPFlashServer"

#
# all the servers
#
class Servers
	constructor:(@host)->
		@xmlSocketPolicyServer = new XMLSocketPolicyServer @host
		@xmlSocketEchoServer = new XMLSocketEchoServer @host,4000
		@xmlSocketPigLatinServer = new XMLSocketPigLatinServer @host,4001
		@httpFlashServer = new HTTPFlashServer 8080
	
new Servers('0.0.0.0')
