angular.module('services.notification', [])

angular.module('services.notification').factory('notification',['$rootScope',
	($rootScope) ->
		notifications = 
			'STICKY' : []
			'ROUTE_CURRENT': []
			'ROUTE_NEXT': []

		notify = {}

		$rootScope.$on('$routeChangeSuccess', () ->
    		notifications.ROUTE_CURRENT.length = 0
    		notifications.ROUTE_CURRENT = angular.copy(notifications.ROUTE_NEXT)
    		notifications.ROUTE_NEXT.length = 0
    )

    makeNotification = (msg, type, options) ->
    	return _.extend({ message: msg, type: type }, options)

		addNotification = (array, notification) ->
			array.push(notification)
			return notification

		notify.get = () ->
			return [].concat(notifications.STICKY, notifications.ROUTE_CURRENT)

		notify.pushSticky = (msg, type, options) ->
			return addNotification(notifications.STICKY, makeNotification(msg, type, options))

		notify.pushCurrentRoute = (msg, type, options) ->
			return addNotification(notifications.ROUTE_CURRENT, makeNotification(msg, type, options))

		notify.pushNextRoute = (msg, type, options) ->
			return addNotification(notifications.ROUTE_NEXT, makeNotification(msg, type, options))

		notify.remove = (n) ->
			_.each(notifications, (type) -> 
					idx = type.indexOf(n)
					if idx > -1 then type.splice(idx, 1)
				)

		notify.removeAll = () ->
			_.each(notifications, (type) =>
					type.length = 0
			)

		return notify

])