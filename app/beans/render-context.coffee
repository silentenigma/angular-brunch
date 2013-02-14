"use strict";


angular.module('app').value('renderContext',
	(requestContext, actionPrefix, paramNames) ->

		getNextSection = () ->
			return requestContext.getNextSection(actionPrefix)

		isChangeLocal = () ->
			return requestContext.startWith actionPrefix

		isChangeRelevant = () ->
			if not requestContext.startWith actionPrefix then return false

			if requestContext.hasActionChanged() then return true

			return paramNames.length and requestContext.haveParamsChanged paramNames



		# public API

		return {

			getNextSection: getNextSection
			isChangeLocal: isChangeLocal
			isChangeRelevant: isChangeRelevant

		}
)