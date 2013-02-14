# services.auth Module
#
# @abstract Description
#
angular.module 'services.auth', ['services.crud']

angular.module('services.auth').constant('paths',
	{
		loginPage: '/login'
		homePage:  '/home'
		homeAuthPage: '/'
		afterLogin : '/'
		afterLogout : '/home'
	}
)

angular.module('services.auth').factory('auth', ['$rootScope', '$route', '$location', 'crud','paths', 'code', 'api'
	($rootScope, $route, $location, crud, paths, code, api) ->

		isUserFetch = false

		# create blank user model
		$rootScope.user = new crud()
		$rootScope.user.url = 'user'

		# create blank session model
		session = new crud()
		session.url = 'auth'

		$rootScope.$on('$routeChangeSuccess', () ->
			redirect()
		)

		$rootScope.$on('logout', () ->
			logout()
		)

		$rootScope.$on('success:login', () ->
			$location.path(paths.afterLogin)
		)

		$rootScope.$on('fetchUser', () =>
			isUserFetch = true;
			redirect()
		)


		#
		# redirect depends on paths
		#
		redirect = () ->

			if not isUserFetch then return

			path = $location.path()

			auth = $route.current.auth


			if not isUserAuth() and auth is true then $location.path( paths.homePage )

			if auth is false and isUserAuth() then $location.path( paths.homeAuthPage )


		#
		# get paths
		#
		getPaths = () -> return paths

		#
		# get user model
		#
		getUser = () -> return $rootScope.user

		#
		# get user token
		#
		getUserToken = () -> return $rootScope.user.get('token')

		#
		# check if user is auth
		#
		isUserAuth = () -> return Boolean($rootScope.user.get('token'))

		#
		# is user email exist
		#
		isEmailUnique = (email, success) ->
			api.sync("POST", "#{$rootScope.user.url}/unique",
				{
					data: { email: email }
					success: success
					silent: true	
				})

		#
		# create new user
		#
		registerUser = (credentials) ->
			$rootScope.user.set(credentials);
			$rootScope.user.save(
				success: (response, status) ->
					switch status
						when api.code.ok
							$rootScope.user.set(response);
							$rootScope.$broadcast('success:login');
						when api.code.user_exist then console.log("user exist");
			);

		#
		# send email with reset password link
		#
		remindPassword = (email) ->
			api.sync("POST", "#{$rootScope.user.url}/forgot", 
				{
					data: { email: email }
					success: (response, status) ->
						switch status
							when api.code.ok then $rootScope.$broadcast("success:remindPassword")
							when api.code.user_not_exist then $rootScope.$broadcast("error:#{api.code.user_not_exist}")
				})

		#
		# update user password
		# 	credentials.id -> user id
		# 	credentials.password -> user.password
		#
		resetPassword = (credentials) ->
			api.sync("POST", "#{$rootScope.user.url}/reset", 
			{
					data: credentials
					success: (response, status) ->
						switch status
							when api.code.ok then $rootScope.$broadcast("success:resetPassword")
							when api.code.reset_link_expired then $rootScope.$broadcast("error:#{api.code.reset_link_expired}")
			})


		#	
		# delete user if he asked for
		#
		deleteUser = () ->

		#
		# Is user is checked on server
		#
		isFetchUser = () -> return isUserFetch


		#
		# Ask server for user
		#
		fetchUser = () ->
			session.fetch(
				success: (response, status)->
					$rootScope.user.set(response)
					$rootScope.$broadcast('fetchUser')
			)


		#
		# Try to login user
		#
		login = (credentials) ->

			session.set(credentials)

			session.save(
				success: (response, status) ->

					switch status
						when api.code.ok
							$rootScope.user.set(response)
							$rootScope.$broadcast('success:login')
						when api.code.invalid_credentials then $rootScope.$broadcast("error:#{api.code.invalid_credentials}")
			)

		#
		# logout user and destroy session
		#
		logout = () ->
		
			session.reset();

			session.destroy({success: () ->
				$rootScope.user.reset()
				$location.path(paths.afterLogout)
			})

			
		# public API
		return {
			login: login
			logout: logout
			fetchUser: fetchUser
			isFetchUser: isFetchUser
			registerUser: registerUser
			isEmailUnique: isEmailUnique
			getPaths: getPaths
			getUser: getUser
			getUserToken: getUserToken
			remindPassword: remindPassword
			resetPassword: resetPassword
		}

])
