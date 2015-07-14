angular.module('thesoupApp').factory(
  'PortfolioAccount',
  ['$http', '$q', '$log', 'Config',
    ($http, $q, $log, Config) ->
      api = Config.api

      (
        query: (portfolioName) ->
          ret = $q.defer()
          $http.get "#{api}/#{portfolioName}"
            .success (data) ->
              ret.resolve data
            .error () ->
              ret.reject()

          ret.promise

        save: (portfolioName, accountId) ->
          $http.post "#{api}/#{portfolioName}/#{accountId}"

        remove: (portfolioName, accountId) ->
          $http.delete "#{api}/#{portfolioName}/#{accountId}"
      )
  ]
)
