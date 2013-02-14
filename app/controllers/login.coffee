angular.module('app').controller('loginController', ['$scope', 'notification', 'auth', 'api', 'requestContext'
  ($scope, notification, auth, api, requestContext) ->

    renderContext = requestContext.getRenderContext('front.login')
    $scope.subview = renderContext.getNextSection()

    $scope.$on('requestContextChanged', ()->
    	if not renderContext.isChangeRelevant() then return
    	$scope.subview = renderContext.getNextSection()
    )

])
