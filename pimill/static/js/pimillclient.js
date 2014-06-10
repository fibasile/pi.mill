var PiMillClient = function(){
	_this = {}
	_this.connect = function(){
		
	    var sock = new SockJS('/sockjs');
	    sock.onopen = function() {
	        console.log('open');
			_this.connected = true;
			_this.updateState();
	    };
	    sock.onmessage = function(e) {
	        console.log('message', e.data);
			_this.handleMessage(e.data);
	    };
	    sock.onclose = function() {
	        console.log('close');
			_this.connected = false;
			_this.updateState();
	    };
		
		_this.sock = sock;
	};
	
	_this.handleMessage = function(msg){
		window.app.gui.loadMillingInfo(msg);
	};
	
	
	_this.startMilling = function(){
		if (!_this.connected) {
			alert('Unable to send command');
			return;
		}
		_this.sock.send( JSON.stringify({ 'command' : 'startMilling'} ));		
		
		
	};
	
	_this.stopMilling = function(){
		if (!_this.connected) {
			alert('Unable to send command');
			return;
		}
		_this.sock.send( JSON.stringify({ 'command' : 'stopMilling'} ));		
		
	};
	
	_this.prepareMilling = function(serial){
		if (!_this.connected) {
			alert('Unable to send command');
			return;
		}
		_this.sock.send( JSON.stringify({ 'command' : 'prepareMilling', 'payload' : { 'serial' : serial} } ));		
	};
	
	
	_this.updateState = function(){
		var status = (_this.connected ? "is" : "isn't");
		console.log("PiMill " + status + " connected" );
		
	};
	
	
	return _this;
		
		
	
};