angular.module('app').directive('forgot', ['$location', 'auth', 'api'
	($location, auth, api) ->
		templateUrl: 'views/forms/forgot-form.html'
		replace: true
		scope: true 
		restrict: 'E'

		link: (scope, elem, attr) ->

			scope.credentials = {
      	email: ''
      	password: ''
    	}

    	scope.isPending = false
			elem.validator({
				inputs:
					'email':
						required:
						  value: true,
						pattern: 
						  value: 'email'
						  error: 'This is not a valid email adress.'

				onSubmit: (valid) ->
					console.log valid
					if valid
						scope.$apply () -> scope.isPending = true;
						auth.remindPassword(scope.credentials.email)
						scope.errors = ''
				})	
				     

			scope.$on("error:#{api.code.user_not_exist}", () ->
				scope.isPending = false
				scope.errors = 'There is no email registered to your account.</br>We could not send your password'
			)

			scope.$on("success:remindPassword", ()->
				scope.success = 'We’ve emailed your password reset instructions.</br> Please check your email.'
			)

])