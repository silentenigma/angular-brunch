angular.module('app').directive('reset', ['$location', '$route', 'auth', 'api'
	($location, $route, auth, api) ->
		templateUrl: 'views/forms/resetpassword-form.html'
		replace: true
		scope: true 
		restrict: 'E'

		link: (scope, elem, attr) ->

			scope.credentials = {
      	password: ''
      }

      scope.credentials.id = $route.current.params.id
      scope.credentials.token = $route.current.params.token

      scope.errors = ''
      scope.isPending = false
      elem.validator({
        inputs:
          'password':
            required:
              value: true
            rangeLength: 
              value:[5,30],
              error: 'Password must be beetwen 5 and 30 characters.'
          'vpassword':
            equal:
              value: 'password'
              error: 'Password must be equal'

        onSubmit: (valid) ->
          if valid
            scope.$apply () -> scope.isPending = true;
            auth.resetPassword(scope.credentials);
      })

      scope.$on "success:resetPassword", () ->
      	scope.success= "Pasword has beeen changed. Feel free to sign in.";

    	scope.$on "error:#{api.code.reset_link_expired}", () ->
        scope.isPending = false 
        scope.errors = "Password reset failed - the password reset link has expired."

])

