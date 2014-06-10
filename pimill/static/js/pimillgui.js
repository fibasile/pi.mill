

var PiMillGui = function(){
	
	var _this = {};

        _this.preload = function(url,cb){
	 var imgPreload = new Image();
	    $(imgPreload).attr({
		src: url
	    });
            if (imgPreload.complete || imgPreload.readyState === 4) {
		    cb();
		//image loaded:
		//your code here to insert image into page

	    } else {
		//go fetch the image:
		$(imgPreload).load(function (response, status, xhr) {
		    if (status == 'error') {
			cb();
			//image could not be loaded:

		    } else {

			//image loaded:
			//your code here to insert image into page
			 cb();
		    }
		});
	    }
        };
	
	_this.uploadFile = function(ev){
		ev.preventDefault();
		console.log('posting file');
		_this.uploadForm.ajaxForm({
			iframe: true,
			clearForm: true,
			url: '/upload',
			type: 'post',
			dataType: 'json',
			success: function(response){
				console.log(response);
				_this.loadUploadedImage();
			}
		});
		_this.uploadForm.submit();
	};
	
	
	_this.loadPathImage = function(){
		_this.panelPathPreview.empty();
                var url = '/uploaded.path.png'+'?ts='+new Date().getTime();  
            _this.preload(url, function(){
		$('<img>').attr('src',url).appendTo(_this.panelPathPreview);
		var $tab = $('[data-toggle="tab"][href="#panel-path"]');
    	$tab.tab("show");
             });
	};
	
	_this.loadRmlImage = function(){
		_this.panelRmlPreview.empty();
		
		// $('<img>').attr('src','/uploaded.rml.png').appendTo(_this.panelRmlPreview);
		$.get('/uploaded.rml.png', function(data){
			$('<pre>').html(data).appendTo(_this.panelRmlPreview);
		});
		
		var $tab = $('[data-toggle="tab"][href="#panel-rml"]');
    	$tab.tab("show");
	};
	
	_this.loadUploadedImage = function(){
		_this.panelImagePreview.empty();
                var url = '/uploaded.png?ts='+new Date().getTime();
                _this.preload(url, function(){
			$('<img>').attr('src',url).appendTo(_this.panelImagePreview);
			$.get('/uploaded_info',function(data){
				console.log(data.info);
				if (data.info.length > 0){
					_this.selectedFile = true;
					_this.uploadInfo1.text(data.info[0]);
					_this.uploadInfo2.html(data.info[1] + '<br>' + data.info[2]);
				} else {
					_this.selectedFile = true;
					_this.uploadInfo2.text('No file selected');
					_this.uploadInfo2.html('n.a.');
				}
			});
                });
		
	};
	
	_this.loadSerials = function(){
		$.get('/api/serials', function(data){
			_this.serialsCombo.empty();
			for (var h in data.serials){
				var opt = $('<option>');
				 opt.val(data.serials[h]);
				 opt.text(data.serials[h]);
				_this.serialsCombo.append(opt);
				// console.log(opt);
			}
		});
	};
	
	
	_this.loadPresets = function(){
		$.get('/api/presets', function(data){
			_this.presetsCombo.empty();
			var presets = data.presets;
			for (var i in presets){
				var opt = $('<option/>');
				opt.text(presets[i].label);
				opt.val(i);
				_this.presetsCombo.append(opt);
			}
			_this.presets = presets;
			_this.loadPreset(0);
		});
	};
	
	
	_this.loadPreset = function(preset_index){
		console.log("Loading preset " + preset_index);
		var preset = _this.presets[preset_index];
		_this.settingSpeed.val(preset.speed);
		_this.settingJog.val(preset.zjog)
		_this.settingPathType.val(preset.path_type);
		_this.selectedPreset = preset_index;
		
	};
	
	_this.moveHead = function(){
		var x = _this.inputHeadX.val();
		var y = _this.inputHeadY.val();
		var serial = _this.serialsCombo.val()
		console.log('moving head to ' + x + ' '+ y);
		$.post('/api/move', {
			data: {
				'x': x,
				'y': y,
				'serial': serial
			},
			
		}).done(function(){});
	
	};
	
	_this.makePath = function(){
		if (!_this.selectedFile){
			alert('Please upload an image first');
			return;
		}
		var preset = _this.selectedPreset;
		$.post('/api/makepath', {
			timeout:180,
                        data: {
				'preset': preset,
			}
			}).done( function(data,status){
			        console.log(data); console.log(status);
                           	_this.loadPathImage();
			});
	
		
	};
	
	_this.makeRml = function(){
		if (!_this.selectedFile){
			alert('Please upload an image first');
			return;
		}
		var x = _this.inputHeadX.val();
		var y = _this.inputHeadY.val();
		$.post('/api/makerml', {
			data: {
				'x': x,
				'y': y
			},
			
		}).done(function(data,status){
				_this.loadRmlImage();
				_this.prepareMilling();
			});
	
		
	};
	
	_this.invert = function(){
		if (!_this.selectedFile){
			alert('Please upload an image first');
			return;
		}
		$.post('/api/invert', {
			}).done(function(){
				
				_this.loadUploadedImage();
			});	
		
		
		
	};
	
	_this.prepareMilling = function(){
		var serial = _this.serialsCombo.val()
		_this.client.prepareMilling(serial);
		
	};
	
	_this.startMilling = function(){
		
		_this.client.startMilling();
		
	};
	
	_this.stopMilling = function(){
		
		_this.client.stopMilling();		
		
	};
	
	_this.loadMillingInfo = function(msg){
		$('#millTotal').text(msg.payload.time);
                if (msg.payload.time != msg.payload.rem) {
		$('#millStatus').text('milling');
                } else {
		$('#millStatus').text('idle');
                }
		$('#millRem').text(msg.payload.rem);
                var valeur = msg.payload.perc;
                 $('.progress-bar').css('width', valeur+'%').attr('aria-valuenow', valeur);-
		$('#panel-status-body').collapse('show');
		
	};
	
	
	_this.doneMilling = function(msg){
	         var valeur=0;
	   	 $('#millStatus').text('idle');
                 $('#millRem').text($('#millTotal').text());
	         $('.progress-bar').css('width', valeur+'%').attr('aria-valuenow', valeur);
	};
	
	
	_this.init = function(){
		
		_this.client = window.app.socket;
		
		_this.serialsCombo = $('select[name="serials"]');
		_this.presetsCombo = $('select[name="presets"]');
		
		_this.settingSpeed = $('input[name="settings_speed"]');
		_this.settingOffset = $('input[name="settings_offset"]');
		_this.settingJog = $('input[name="settings_jog"]');
		_this.settingPathType = $('select[name="settings_path_type"]');
	
		_this.uploadForm = $('#uploadForm');
		_this.uploadButton = $('#uploadButton');
		_this.uploadButton.click(_this.uploadFile);
		_this.uploadInfo1 = $('#uploadInfo1');
		_this.uploadInfo2 = $('#uploadInfo2');
	
		_this.inputHeadX = $('input[name="head_x"]');
		_this.inputHeadY = $('input[name="head_y"]');
	
		_this.panelImagePreview = $('#panel-input-preview');
		_this.panelPathPreview = $('#panel-path-preview');
		_this.panelRmlPreview = $('#panel-rml-preview');
	
		_this.moveButton = $('#moveButton');
		_this.moveButton.click(_this.moveHead);
		_this.makePathButton = $('#makePathButton');
		_this.makePathButton.click(_this.makePath);
		_this.makeRmlButton = $('#makeRmlButton');
		_this.makeRmlButton.click(_this.makeRml);
		
		_this.invertButton = $('#invertButton');
		_this.invertButton.click(_this.invert);

                _this.beginMillingButton = $('#startMillingButton');
                _this.beginMillingButton.click(function(e){
                      e.preventDefault();
                      _this.startMilling();
                });

                _this.cancelMillingButton = $('#stopMillingButton');
                _this.cancelMillingButton.click(function(e){
                      e.preventDefault();
                      _this.stopMilling();
                });

	
		_this.loadSerials();
		_this.loadPresets();
		
		_this.presetsCombo.change(function() {
			_this.loadPreset(_this.presetsCombo.val());
		});
	};
	
	
	
	
	return _this;
};
