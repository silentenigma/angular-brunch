<!DOCTYPE html>
<html lang="en" ng-controller="mainController">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width" initial-scale="1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <title ng-bind="windowTitle">Title</title>

    {{HTML::style('css/vendor.css')}}
    {{HTML::style('css/app.css')}}

    <!--[if lte IE 7]>
    <script src="http://cdnjs.cloudflare.com/ajax/libs/json2/20110223/json2.js"></script><![endif]--><!--[if lte IE 8]>
    <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->

    <script>
      window.brunch = window.brunch || {};
      window.brunch['auto-reload'] = {
        enabled: true
      };
    </script>

    {{ HTML::script('js/vendor.js')}}
    {{ HTML::script('js/app.js')}}
  
  </head>

  <body>
    
    <div class="pending-request" ng-show="processingRequest"><div><i class="icon-spinner icon-spin icon-large"></i><span style="padding-left: 6px">Loading...</span></div></div>

    <div class="wrapper">
      <div class="container notifications" >
        <div ng-include=" 'views/notification.html' "></div>
      </div>

      <div ng-switch="subview" class="">

        <!-- Loading info -->
        <div ng-switch-when="loading"><p>Loading...</p></div>

        <!-- Layouts -->
        <div ng-switch-when="front" ng-include="'views/layouts/front.html'"></div>
        <div ng-switch-when="app"   ng-include="'views/layouts/app.html'"></div>

      </div>

    </div>

  </body>

</html>