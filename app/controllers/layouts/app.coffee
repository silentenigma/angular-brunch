"use strict";

angular.module('app').controller('appController',[
	'$rootScope'
	'$scope'
	'requestContext'
	'crud'
	'auth'

	($rootScope, $scope, requestContext, crud, auth) ->

		renderContext = requestContext.getRenderContext('app')

		$scope.subview = renderContext.getNextSection()


		$scope.logout = () -> auth.logout()

		$scope.action = () ->
			task = new crud()
			task.url = 'tasks'
			$rootScope.user.set({token: 'sdfs443f'})
			task.fetch()
			console.log "D"

		$scope.$on('requestContextChanged',
			() ->
				if not renderContext.isChangeRelevant() then return

				$scope.subview = renderContext.getNextSection()

		)


])