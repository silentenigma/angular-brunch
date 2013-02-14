angular.module('content-mocks',['ngMockE2E'])
  .run(
    ($httpBackend) ->

      responde = (code, res) ->
        return {code:code, response: res}

      fakeData = [
        id:0
        name:"John"
      ,
        id:1
        name:"Anna"
      ,
        id:2
        name:"Bob" 
      ]

      $httpBackend.whenGET('api/1/tasks').respond(
        (method, url, data) ->
          return [200, responde(0, fakeData[1]) ]
      )

      $httpBackend.whenPOST('api/1/tasks').respond(
        (method, url, data) ->
          console.log data
          return [200, responde(0, {id: 10}) ]
      )
      $httpBackend.whenGET(/.*/).passThrough()
  )