'use strict'

angular.module('services.api', [])


angular.module('services.api').factory('api', ['$rootScope', '$http', '$location', '$injector', 'notification'
	($rootScope, $http, $location, $injector, notification) ->

		apiUrl = 'api/1/'

		$rootScope.processingRequest = false

		code = {
			ok: 0
			invalid_request: 1
			authorization_required: 101
			invalid_token: 102
			invalid_credentials: 103
			user_exist: 104
			user_not_exist: 105
			reset_link_expired: 106

			page_not_found: 404
			server_error: 500

		}

		pendingRequest = (state) ->
			if state
				$('input').attr('disabled', true).addClass('disabled')
				$('button').attr('disabled', true);
			else
				$('input').removeAttr('disabled').removeClass('disabled')
				$('button').removeAttr('disabled').removeClass('disabled')

			$rootScope.processingRequest = state;

		sync = (method, url, options) ->

			options = options || {}

			if $rootScope.processingRequest is true then return;

			# silent prevent to disabled inputs
			if not options.silent then pendingRequest(true);

			
			options.method = method;
			options.url  = apiUrl + url
			options.data = options.data;

			success = options.success
			options.success = (data, status, headers, config) ->
				pendingRequest(false);
				
				if data.code == code.page_not_found
					notification.pushCurrentRoute("Page not found.We couldn't find the page you requested on our servers. We're really sorry
				about that. It's our fault, not yours. We'll work hard to get this page
				back online as soon as possible.", "error")

				if data.code == code.invalid_request
					notification.pushCurrentRoute("Request invalid");

				if data.code is code.invalid_token
					$rootScope.$broadcast('logout')

				if success then success(data.response, data.code)
				
			error = options.error
			options.error = (data, status, headers, config) ->
				pendingRequest(false)

				if status == code.server_error then notification.pushCurrentRoute("Something went wrong on our servers while we were processing your request.
				We're really sorry about this, and will work hard to get this resolved as
				soon as possible.", "error")

				if error then error(data, status, headers, config) 

			$http(
					method: options.method,
					url: options.url
					data: options.data
					headers:
						Token: $rootScope.user.get('token')
				)
				.success(options.success)
				.error(options.error)

		# public API
		return {
			sync: sync
			code: code

		}
])

