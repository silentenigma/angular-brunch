angular.module('app').directive('register', ['$location', 'auth', 'api'
	($location, auth, api) ->
		templateUrl: 'views/forms/register-form.html'
		replace: true
		scope: true 
		restrict: 'E'

		link: (scope, elem, attr) ->

			scope.credentials = 
				username: ''
				email: ''
				password: ''


			scope.errors = ''
			scope.success = false

			scope.isPending = false;
			elem.validator({
				inputs:
					'email':
						required:
							value: true,
						pattern: 
							value: 'email'
							error: 'This field must be valid adress email'
						ajax:
							value: 'api/1/user/unique'
							error: 'This email is already teaken.'
					'username':
						required:
							value: true,
							error: 'This field is required'
						pattern:
							value: /^[a-zA-z0-9.]+$/
							error: "Username should contain only letter characters or numbers"
					'password':
						required:
							value: true
						rangeLength: 
							value:[5,30],
							error: 'Password must be beetwen 5 and 30 characters.'

				onSubmit: (valid) ->
					console.log "submit"
					if valid
						scope.$apply () -> scope.isPending = true;
						auth.registerUser(scope.credentials);
			})

			scope.$on("success:register", ()->
				scope.success = 'You create an account'
			)

])