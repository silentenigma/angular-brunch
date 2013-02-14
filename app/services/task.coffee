angular.module('model.task', ['services.crud'])

angular.module('model.task').factory('Task', ['crud'
	(crud) ->

		class Task extends crud
			url: "tasks"
			
])
