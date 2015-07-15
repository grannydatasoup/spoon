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
    'ngResource',
    'ui.tree',
    'ui.bootstrap',
    'ui.select2'
  ]
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      .when '/accounts',
        templateUrl: 'views/accounts.html',
        controller: 'AccountsCtrl'
      .when '/portfolio',
        templateUrl: 'views/portfolio.html',
        controller: 'PortfolioCtrl'
      .otherwise
        redirectTo: '/'

