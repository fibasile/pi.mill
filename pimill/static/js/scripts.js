$(document).ready(function () {
    "use strict";

    var fn = {

        // Launch Functions
        Launch: function () {
            window.app = {};
			fn.App();
			fn.Gui();
        },
		
		Gui: function() {
			// init gui in a clear state
			window.app.gui = PiMillGui();
			window.app.gui.init();
			
		},
		
		App: function() {
			
			window.app.socket = PiMillClient();
			window.app.socket.connect();
			
		}

	};
	
	
    $(document).ready(function () {
        fn.Launch();
    });

});