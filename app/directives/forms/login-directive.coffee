angular.module('app').directive('login', ['$location', 'auth', 'api'
	($location, auth, api) ->
		templateUrl: 'views/forms/login-form.html'
		replace: true
		scope: true 
		restrict: 'E'

		link: (scope, elem, attr) ->

			scope.credentials = {
      	email: ''
      	password: ''

      }

      scope.errors = ''
      scope.isPending = false;

      elem.validator({
        inputs:
          'email':
            required:
              value: true
            pattern: 
              value: 'email'
              error: 'This field must be valid adress email'
          'password':
            required:
              value: true

        onSubmit: (valid) ->
          if valid
            scope.$apply () -> scope.isPending = true;
            auth.login(scope.credentials)
      })

      scope.$on "error:#{api.code.invalid_credentials}", () ->
        scope.isPending = false;
        scope.errors = 'Invalid userneme or password'
  ])