'use strict'

angular.module('underscore', [])
  .factory('_', ['$window', ($window) ->
    $window._
  ])

angular.module('google', [])
  .factory('charts', ['$q', ($q) ->
    google.load('visualization', '1.0', {
      'packages': ['corechart'],
      'callback': () ->
        ret.resolve(google.visualization)
    });

    ret = $q.defer()
    ret.promise
  ])


angular
  .module 'thesoupApp', [
    'ngRoute',
    'ngSanitize',
    'ngResource',
    'ui.tree',
    'ui.bootstrap',
    'ui.select2',
    'xeditable',
    'angular-loading-bar',
    'flash',
    'ngTable',
    'underscore',
    'google'
  ]
  .config ($routeProvider, $httpProvider) ->
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
      .when '/status',
        templateUrl: 'views/status.html'
      .when '/performance',
        templateUrl: 'views/performance.html'
      .otherwise
        redirectTo: '/'

    $httpProvider.interceptors.push ($location) ->
      response: (r) ->
        if r.status==202
          $location.url('/status')
        r


  .run (editableOptions, editableThemes) ->
    editableOptions.theme = 'bs3'
    editableThemes.bs3.buttonsClass = 'btn-sm';

