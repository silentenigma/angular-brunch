"use strict";

angular.module('app').controller('frontController',[
	'$scope'
	'requestContext'

	($scope, requestContext) ->

		renderContext = requestContext.getRenderContext('front')

		$scope.subview = renderContext.getNextSection()


		$scope.$on('requestContextChanged',
			() ->
				if not renderContext.isChangeRelevant() then return

				$scope.subview = renderContext.getNextSection()

		)


])