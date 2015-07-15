angular.module('thesoupApp').factory(
  'PortfolioAccount',
  ['$http', '$q', '$log', 'Config',
    ($http, $q, $log, Config) ->
      api = Config.api

      (
        query: (portfolioName) ->
          ret = $q.defer()
          $http.get "#{api}/portfolio/#{portfolioName}/accounts"
            .success (data) ->
              ret.resolve data
            .error () ->
              ret.reject()

          ret.promise

        save: (portfolioName, accountId) ->
          $log.debug("Linking #{portfolioName} with #{accountId}")
          $http.post "#{api}/portfolio/#{portfolioName}/accounts/#{accountId}"

        remove: (portfolioName, accountId) ->
          $http.delete "#{api}/portfolio/#{portfolioName}/accounts/#{accountId}"
      )
  ]
)
