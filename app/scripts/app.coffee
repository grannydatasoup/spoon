'use strict'

###*
 # @ngdoc overview
 # @name thesoupApp
 # @description
 # # thesoupApp
 #
 # Main module of the application.
###
angular
  .module 'thesoupApp', [
    'ngRoute',
    'ngSanitize'
  ]
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'

