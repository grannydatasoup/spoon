angular.module('thesoupApp').factory(
  'PortfolioCampaign',
  ['$http', '$q', '$log', 'Config',
    ($http, $q, $log, Config) ->
      api = Config.api

      (
        query: (portfolioName) ->
          ret = $q.defer()
          $http.get "#{api}/portfolio/#{portfolioName}/campaigns"
            .success (data) ->
              ret.resolve data
            .error () ->
              ret.reject()

          ret.promise

        save: (portfolioName, campaignIds) ->
          $log.debug("Linking #{portfolioName} with #{campaignIds}")
          if campaignIds.length is 1
            $http.post "#{api}/portfolio/#{portfolioName}/campaigns/#{campaignIds[0]}"
          else
            $http.post  "#{api}/portfolio/#{portfolioName}/campaigns", campaignIds

        remove: (portfolioName, campaignId) ->
          $http.delete "#{api}/portfolio/#{portfolioName}/campaigns/#{campaignId}"
      )
  ]
)
