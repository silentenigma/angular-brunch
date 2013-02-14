"use strict";

angular.module('services.requestContext',[])

angular.module('services.requestContext').factory('requestContext', ['renderContext',

	(renderContext)->

		action = ""
		sections = []
		params = {}

		previousAction = ""
		previousParams = {}

		getAction = () -> return action

		getNextSection = (prefix) ->

			if not startWith(prefix)  then return(null)

			if prefix is "" then return sections[0]

			depth = prefix.split(".").length

			if depth is sections.length then return null

			return sections[ depth ]

		getParam = (name, defaultValue) ->

			if angular.isUndefined(defaultValue) then defaultValue = null

			return params[ name ] || defaultValue

		getParamAsInt = (name, defaultValue) ->

			valueAsInt = getParam(name, defaultValue || 0) * 1

			if isNaN(valueAsInt)
				return defaultValue || 0
			else
				return valueAsInt

		getRenderContext = (requestActionLocation, paramNames) ->
			requestActionLocation = requestActionLocation || ""
			paramNames = paramNames || []

			if not angular.isArray(paramNames) then paramNames = [paramNames]

			return new renderContext(@, requestActionLocation, paramNames)


		hasActionChanged = () ->
			return action isnt previousAction

		hasParamChanged = (paramName, paramValue) ->
			if(not angular.isUndefined(paramValue)) then return not isParam(paramName, paramValue)

			if ( not previousParams.hasOwnProperty(paramName) and not params.hasOwnProperty(paramName) )
				return true
			else 
				if (previousParams.hasOwnProperty(paramName) && not params.hasOwnProperty(paramName))
					return true

			return previousParams[paramName] isnt params[paramValue]

		haveParamsChanged = (paramNames) ->
			for param in paramNames
				if hasParamChanged(param) then return true

			return false

		isParam = (paramName, paramValue) ->
			if (params.hasOwnProperty(paramName) and params[paramName] is paramValue)
				return true
			else
				return false


		setContext = (newAction, newRouteParams) ->
			previousAction = action
			previousParams = params

			action = newAction

			sections = action.split(".")

			params = angular.copy(newRouteParams)


		startWith = (prefix) ->

			if( not prefix.length or action is prefix or action.indexOf(prefix+"." is 0))
					return true
			else
				return false


		# Return public API
		return {
			getNextSection: getNextSection
			getParam: getParam
			getParamAsInt: getParamAsInt
			getRenderContext: getRenderContext
			hasActionChanged: hasActionChanged
			hasParamChanged: hasParamChanged
			haveParamsChanged: haveParamsChanged
			isParam: isParam
			setContext: setContext
			startWith: startWith
		}
])