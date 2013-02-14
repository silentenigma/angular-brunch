/*
	
	Simple setVisibility plugin

*/

(function($){

	$.fn.setVisibility = function(visible){
		return this.each(function(){
			$this = $(this);
			$this[visible ? 'show' : 'hide']();
		});
	};

})(jQuery);



/*

	Simple valid jQuery plugin

	require _.underscorejs library

*/


var typewatch = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  }; 
})();

(function($) {
	var settings, validators, methods, errors, patterns;

	settings = {
		error: "tak",
		onEvent: 'keyup' 
	};

	errors = {
		required: 'This filed is required',
		pattern: 'This filed must be valid'
	};

	patterns = {
    	// Matches any digit(s) (i.e. 0-9)
    	digits: /^\d+$/,

    	// Matched any number (e.g. 100.000)
    	number: /^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/,

    	// Matches a valid email address (e.g. mail@example.com)
    	email: /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i,

    	// Mathes any valid url (e.g. http://www.xample.com)
    	url: /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i
	};

	function _result(valid, error, obj){	
		obj.isValid &= valid;
		if(!valid) obj.errors.push(error);
		return obj;
	}

	validators = {
		pattern: function(obj){
			var pattern = patterns[obj.validator.pattern.args.value] || obj.validator.pattern.args.value;
			var valid = pattern.test( obj.value );
			var error = obj.validator.pattern.args.error || errors.pattern;

			return _result(valid, error, obj);

		},
		required: function(obj){
			var valid = _isValue(obj.value);
			var error = obj.validator.required.args.error || errors.required;

			return _result(valid, error, obj);
			
		},

		rangeLength: function(obj){
			var r1 = obj.validator.rangeLength.args.value[0];
			var r2 = obj.validator.rangeLength.args.value[1];
			var error = obj.validator.rangeLength.args.error || errors.required;
      		var valid = ( _isValue(obj.value) && $.trim(obj.value).length > r1 && $.trim(obj.value).length < r2);
      		return _result(valid, error, obj);
      	},

      	equal: function(obj){
      		var error = obj.validator.equal.args.error || errors.equal;
      		var name = obj.validator.equal.args.value;

      		var valid  = ($('input[name=' + name + ']').val() === obj.value) ? true : false;

      		return _result(valid,error, obj); 
      	},

		ajax: function(obj){
			console.log("ajax");

			var dfd = $.Deferred();
			$.ajax({
			  type: "POST",
			  url: obj.validator.ajax.args.value,
			  data: { data: obj.value}, 
			  dataType: 'json'
			})
			.done(function(valid){
				dfd.resolve(_result(valid, obj.validator.ajax.args.error, obj));
			})
			.fail(function(){ $.event("Server error during ajax request"); });
		
			return dfd.promise();
		}
	};

	function _isValue(value){
		return !( _.isNull(value) || _.isUndefined(value) || ( _.isString(value) && value === '' ));
	}

	function _evalExpression(expression){
		return jQuery.parseJSON(''+expression+'');
	}

	function _validateElement(obj){		

		var dfd = $.Deferred();

		obj.errors = [];
		obj.isValid = true;
		obj.isChecked = false;

		var onProcessing = settings.onProcessing || _onProcessing;
		var processing = {};
		processing[obj.name] = true;
		onProcessing(processing);

		var promises = [];

		_.each(obj.validator, function(validator, name, i){
			fn = validator.fn;

			// prev ajax is still processing
			if(name === 'ajax' && obj.isPending) {
				obj.queueRequest = true;
				return;
			}

			if(name === 'ajax'){
				obj.isPending = true;
			}
			
			promises.push( fn(obj) );

		});

		$.when.apply($, promises).done(function(){

			obj.isPending = false;
			//var args = Array.prototype.slice.apply(arguments);
			if (obj.queueRequest ){
				obj.queueRequest = false;
				_validateElement(obj);
			} else {

				var error = {};
				error[obj.name] = obj.errors;

				var valid = {};
				valid[obj.name] = obj.isValid;
				
				_onValid = settings.onValid || _onValid;
				_onValid({
					valid: valid,
					error: error
				});

				dfd.resolve();
			}
		});

		return dfd.promise();

	}

	function _makeValidatorObject(inputs){

		var validatorObj = {
		};	

		_.each(inputs, function(input, name){

			var expression, validator;

			validator = {};

			_.each(input, function(args, fn){
				
				var validatorFn, validatorArgs;

				validatorFn = validators[fn] || {};
				if( ! _.isFunction(validatorFn)) 
					$.error('['+fn+'] is unknow validator function.');

				validatorArgs = args;
				if( _.isEmpty(args) || !args.hasOwnProperty('value') )
					$.error('Validator [' + fn + '] has not a property: [value] ');

				validator[fn] = {
					fn: validatorFn,
					args: validatorArgs,
					valid: false
				};
			});	

			validatorObj[name] = {
				validator: validator,
				errors: [],
				isValid: '1',
				isPending: false,
				queueRequest: false,
				name: name,
				value: ''
			};

		});
		return validatorObj;

	}

	function _validEvent(event, validatorObj){

		var name = $(event.target).attr('name');
		var value = $(event.target).val();

		var oldValue = validatorObj[name].value || '';
		validatorObj[name].value = value;

		if( event.type === 'keyup' && oldValue === value) return;

		_validateElement(validatorObj[name]);
	}

	function _bindValidationEvent(elements, validatorObj){

		_.each(elements, function(element){
			element.on(settings.onEvent, function(event){
				typewatch(function(){
					_validEvent(event, validatorObj);
				}, 750);

			}).on('blur', function(event){
				_validEvent(event, validatorObj);
			});
		});		
	}


	function _trigger(obj){

		var promises = [];
		_.each(obj, function(validator){
			//if (validator.isValid === '1')
				promises.push(_validateElement(validator));
		});

		return promises;
	}

	function _doValidOnSubmit(obj){
	
		
		$.when.apply($, _trigger(obj)).done(function(){

			var isValid = true;	


			_.each(obj, function(validator){
				console.log(validator);
				isValid &= validator.isValid;
			});

			var _onSubmit = settings.onSubmit || _onSubmit;
			_onSubmit(isValid);

		});


	}

	var _onProcessing = function(obj){

		var name = _.keys(obj);
		var input = $('input[name=' + name + ']');

		var validIcons = '' +
		'<span class="valid-icon">' +
          '<i  class="icon-spinner icon-spin"></i>' +
          '<i  class="icon-ok success-text"></i>' +
          '<i  class="icon-remove error-text"></i>' +
        '</span>';

        var validErrors = '' +
        '<span class="valid-error"></span>';

        if(!(input.parent().next('.valid-icon').length))
			input.parent().after(validIcons);

		var icons = input.parent().siblings('.valid-icon');
		var errors = input.parent().siblings('.valid-error');

		icons.find('.icon-spinner').setVisibility(true);
		icons.find('.icon-ok').setVisibility(false);
		icons.find('.icon-remove').setVisibility(false);
	};

	//
	//	obj = {
	//		error:
	//			inputName: Array[]	
	//		valid:
	//			inputName: true/false	
	//	}
	//
	//
	var _onValid = function (obj) {
		console.log("Default onValid function. You shoud definitlly override this");

		var name = _.keys(obj.valid);
		var input = $('input[name=' + name + ']');


		var icons = input.parent().siblings('.valid-icon');
		var errors = input.parent().siblings('.valid-error');

		errors.html( obj.error[name][0] || '' );

		icons.find('.icon-spinner').setVisibility(false);
		icons.find('.icon-ok').setVisibility(obj.valid[name]);
		icons.find('.icon-remove').setVisibility(!obj.valid[name]);

	};
	var _onSubmit = function() {
		console.log("Default onSumbit function. You shoud definitlly override this");
	};
	

	methods = {
		init: function(options){

			settings = $.extend(settings, options);

			return this.each(function(){
				var $this, data;

				//store this pointer
				$this = $(this);	
				//store plugin state and data
				data = $this.data('valid');

				// if first run
				if(!data){

					var elements, validatorObj, inputs;

					inputs = settings.inputs || {};
					if (_.isEmpty(inputs)) 
						$.error("There is no any validators defined");

					inputs = _.keys(inputs);

					elements = [];
					_.each(inputs, function(inputName){
						elements.push( $this.find('input[name='+inputName+']') );
					}); 
					

					validatorObj = _makeValidatorObject(settings.inputs);

					_bindValidationEvent.call(this, elements, validatorObj);


					$(this).data('valid',{
						target: $this,
						obj: validatorObj
					});

					$this.on('submit', function(e){
						
						_doValidOnSubmit(validatorObj);
						
						return false;
					});		

				}
			
			});
		},

		isValid: function(){
			data =  $(this).data('valid');
			if ( _.isUndefined(data) ) return;
			return data.obj.isValid;
		},

		// trigger manual validation on all validator
		trigger: function(){

		}
	};

	$.fn.validator = function(method){
		if ( methods[method] ) {
			return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if ( typeof method === 'object' || ! method ) {
			return methods.init.apply( this, arguments );
		} else {
			$.error( 'Method ' +  method + ' does not exist on this plugin' );
		} 
	};

})(jQuery);