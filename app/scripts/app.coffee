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
    'ngSanitize',
    'ui.tree'
  ]
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      .when '/accounts',
        templateUrl: 'views/accounts.html',
        controller: 'AccountsCtrl'
      .otherwise
        redirectTo: '/'

