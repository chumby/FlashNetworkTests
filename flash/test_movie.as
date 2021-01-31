this.onLoad = function () {
	xml_response.text = "Press a button";

	xml_load_button.onRelease = function() {
	xml_response.text = "hit XML load button";
	x = new XML();
	x.onLoad = function(success) {
		if (success) {
			xml_response.text = this.toString();
		} else {
			xml_response.text = "failed XML.load";
		}
	}
	host = host_input.text;
	x.load("http://"+host+":8080/xml/load");
}

xml_send_and_load_button.onRelease = function() {
	xml_response.text = "hit XML send_and_load button";
	x = new XML('<translate text="Hello, world!"/>');
	y = new XML();
	y.onLoad = function(success) {
		if (success) {
			xml_response.text = y.toString();
		} else {
			xml_response.text = "failed XML.sendAndLoad";
		}
	}
	host = host_input.text
	x.sendAndLoad("http://"+host+":8080/xml/send_and_load",y);
}

loadvars_load_button.onRelease = function() {
	xml_response.text = "hit LoadVars load button";
	l = new LoadVars()
	l.onLoad = function(success) {
		if (success) {
			xml_response.text = l.response
		} else {
			xml_response.text ="failed LoadVars.load";
		}
	}
	host = host_input.text
	l.load("http://"+host+":8080/loadvars/load");
}

loadvars_send_and_load_button.onRelease = function() {
	xml_response.text = "hit LoadVars send_and_load button";
	l = new LoadVars()
	l.test = "Twas bryllyg and ye slythy toves Did gyre and gymble in ye wabe All mimsy were ye borogoves And ye mome raths outgrabe.";
	ll = new LoadVars();
	ll.onLoad = function(success) {
		if (success) {
			xml_response.text = ll.esttay
		} else {
			xml_response.text ="failed LoadVars.sendAndLoad";
		}
	}
	host = host_input.text
	l.sendAndLoad("http://"+host+":8080/loadvars/send_and_load",ll);
}

//
// create xml_socket client for echo
//
xml_socket_echo = new XMLSocket();
xml_socket_echo.onXML = function(xml) {
	//trace("got echo response "+xml.toString())
	xml_response.text = xml.toString();
}
xml_socket_echo.onConnect = function(success) {
	if (success) {
		//trace("connected xml_socket_echo");
	} else {
		trace("failed to connect to xml_socket_echo")
	}
}
xml_socket_echo.connect(host_input.text,4000);

//
// create cxml_socket_client for pig latin
//
xml_socket_pig_latin = new XMLSocket();
xml_socket_pig_latin.onXML = function(xml) {
	//trace("got pig latin response "+xml.toString())
	xml_response.text = xml.toString();
}
xml_socket_pig_latin.onConnect = function(success) {
	if (success) {
		//trace("connected xml_socket_pig_latin");
	} else {
		trace("failed to connect to xml_socket_pig_latin")
	}
}
xml_socket_pig_latin.connect(host_input.text,4001);

xml_socket_echo_button.onRelease = function() {
	xml_response.text = "sending to echo XMLSocket"
	xml = new XML('<test type="echo"/>');
	xml_socket_echo.send(xml);
}

xml_socket_pig_latin_button.onRelease = function() {
	xml_response.text = "sending to pig latin XMLSocket"
	xml = new XML('<test type="no matter where you go there you are"/>');
	xml_socket_pig_latin.send(xml);
}
}