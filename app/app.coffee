'use strict'

# Declare app level module which depends on filters, and services
App = angular.module('app', [
  'ngCookies'
  'services.notification'
  'services.requestContext'
  'services.auth'
])

App.run(
  ($templateCache, $http, auth) ->
    $http.get('views/notification.html', {cache: $templateCache })
    $http.get('views/home.html', {cache: $templateCache })
    $http.get('views/login.html', {cache: $templateCache })
    $http.get('views/nav.html', {cache: $templateCache })
    $http.get('views/app.html', {cache: $templateCache })
    $http.get('views/layouts/app.html', {cache: $templateCache })
    $http.get('views/layouts/front.html', {cache: $templateCache })
    $http.get('views/login-form.html', {cache: $templateCache })
)

App.constant('code',
  {
    ok:                   0
    invalid_credentials:  103

  }
)

App.config( 
  ($routeProvider, $locationProvider, $httpProvider) ->

    # auth: true  -> routes av only for auth users
    # auth: false -> routes av only for non auth users
    #             -> routes av for all users 

    $routeProvider
      .when('/',      { action:     'app', auth:true })
      .when('/home',  { action:     'front.home', auth: false })
      .when('/login', { action:     'front.login.default', auth: false  })
      .when('/register', { action:  'front.login.register', auth: false  })
      .when('/forgot', { action:    'front.login.forgot', auth: false  })
      .when('/reset/:id/:token', { action:    'front.login.reset', auth: false  })


      .otherwise({redirectTo: '/'})

    $locationProvider.html5Mode(false)
)
