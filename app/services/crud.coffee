'use strict'

methodMap = {
	'create': 'POST'
	'update': 'PUT'
	'patch':  'PATCH'
	'delete': 'DELETE'
	'read':   'GET'
}

angular.module('services.crud', ['services.api'])

angular.module('services.crud').factory('crud', ['$rootScope','api'

	($rootScope, api) ->

		Model = (attributes, options) ->
			
			attr = attributes || {}

			@attributes = {}

			@set(attr)
			@initialize.apply(@, arguments)

		_.extend(Model.prototype, {

				initialize: () -> console.log "init"

				reset: () ->
					@attributes = {}

				sync: (method, url, options) ->
					api.sync(method, url, options)

				toJSON: () ->
					return _.clone(@attributes)

				set: (attr) ->
					_.extend(@attributes, attr)

				get: (attr) ->
					if _.isNull(attr) then return @attributes
					if _.isUndefined(@attributes[attr]) then return null
					return @attributes[attr]

				isNew: () ->
					_.isUndefined @attributes.id 

				id: () ->
					return @attributes.id

				fetch: (options) ->
					options = if options then _.clone(options) else {}
					success = options.success

					options.success = (data, status, headers, config) => 
						@set(data)
						if success then success(data, status, headers, config)

					@sync('GET', @url, options)

				save: (options) ->

					options = if options then _.clone(options) else {}
					success = options.success

					options.data = @toJSON()
					options.success = (data, status, headers, config) => 
						@set(data)
						if success then success(data, status, headers, config)

					method =  if @isNew() then 'POST' else 'UPDATE'
					url = if @isNew() then @url else @url + '/' + @id()

					@sync(method, url, options)

				destroy: (options) ->
					options = if options then _.clone(options) else {}
					success = options.success

					options.success = (data, status, headers, config) => 
						@set(data)
						if success then success(data, status, headers, config)

					url = if @isNew() then @url else @url + '/' + @id()

					@sync('DELETE', url, options)
			})

		return Model
])