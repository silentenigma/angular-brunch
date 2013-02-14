
## AppCtrl

angular.module('app').controller('mainController', [
  '$scope'
  '$route'
  '$routeParams'
  '$location'
  'notification'
  'requestContext'
  'auth'

($scope, $route, $routeParams, $location, notification, requestContext, auth) ->

  # keep track of notifications
  $scope.notifications = notification;
  $scope.removeNotification = (notificationToRemove) ->
  	notification.remove(notificationToRemove)


  isRouteRedirect = ( route ) ->
  	return not route.current.action

  onRouteChange = ()->

    if isRouteRedirect($route) or not auth.isFetchUser() then return

    requestContext.setContext $route.current.action, $routeParams

    $scope.$broadcast 'requestContextChanged', requestContext

  $scope.getInstanceTime = () ->
  	now = new Date()
  	timeString = now.toTimeString()
  	instanceTime = timeString.match( /\d+:\d+\d+/i )
  	return instanceTime [0]

  renderContext = requestContext.getRenderContext()

  $scope.windowTitle = "Default title"

  $scope.subview = renderContext.getNextSection()

  
  # initial fetch user from server
  auth.fetchUser()

  # render context on route change after user fetch
  $scope.$on('fetchUser', () -> 
    
    onRouteChange()
  
  )

  $scope.$on 'requestContextChanged', () ->
  	if not renderContext.isChangeRelevant() then return

  	$scope.subview = renderContext.getNextSection()

  $scope.$on '$routeChangeSuccess', (event) ->
    onRouteChange()

])