xml_load_button.onPress = function() {
	xml_response.text = "hit XML load button";
	x = new XML();
	x.onLoad = function(success) {
		if (success) {
			xml_response.text = this.toString();
		} else {
			xml_response.text = "failed XML.load";
		}
	}
	x.load("http://localhost:8080/xml/load");
}

xml_send_and_load_button.onPress = function() {
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
	x.sendAndLoad("http://localhost:8080/xml/send_and_load",y);
}
