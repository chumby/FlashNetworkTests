This repository contains a nodejs-based server that implements a subset of Adobe Flash network capabilities, and a simple AVM1/AS1-based Flash 9 movie to test them.

The server is written with Coffeescript, a terse dialect of Javascript.  Install a copy of the lastest version of node and npm, then install coffeescript globally with:

`npm install --global coffeescript`

To run the server...

    cd server
    sudo coffee servers.coffee

The server provides the following services:

* An HTTP server on port 8080 that provides the following services:
  * a wildcard `crossdomain.xml` file on `/crossdomain.xml`
  * a `LoadVars.load()` GET endpoint at `/loadvars/load`
  * a `LoadVars.sendAndLoad()` GET and POST endpoint at `/loadvars/send_and_load`
  * a `XML.load()` GET endpoint at `/xml/load`
  * a `XML.sendAndLoad()` GET and POST endpoint at `/xml/send_and_load`
* An XMLSocket policy server on port 843 that serves a wildcard policy
* An XMLSocket on port 4000 that just echoes its input
* An XMLSocket on port 4001 that translates XML into Pig Latin.

The `load()` responses and policies are in static files and can be modified to taste.

Note that Flash `sendAndLoad()` operations behave differently between the standalone player and the browser plugin.
The browser plugin and Flash Lite players use POST, but the desktop standalone player uses GET, despite putting data in the body of the request like a POST.

In the Flash directory is a simple Flash Movie with SWF and FLA created in Flash CS3 that displays network results and buttons to initiate transactions with the server.
All of the Actionscript AVM1/AS1 source code is in a separate file which is simply `#include`'d on the first frame of the movie.
