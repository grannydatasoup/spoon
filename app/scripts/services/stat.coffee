angular.module('thesoupApp').factory('Stat', ['$http', '$q', '$log', 'Config',
  ($http, $q, $log, Config) ->

    portfolio_actual_diff: (portfolio_id) ->
      ret = $q.defer()

      $http.get("#{Config.api}/me/bids/#{portfolio_id}/diff/actual/histogram").then(
        (r) ->
          ret.resolve(r.data)
        (e) ->
          ret.reject(r.data)
      )
      # ret.resolve([
      #   {"Count": 10, "BidChange": -12.81},
      #   {"Count": 25, "BidChange": -10.325},
      #   {"Count": 92, "BidChange": -7.84},
      #   {"Count": 381, "BidChange": -5.355},
      #   {"Count": 1274, "BidChange": -2.87},
      #   {"Count": 124843, "BidChange": -0.385},
      #   {"Count": 266, "BidChange": 2.1},
      #   {"Count": 72, "BidChange": 4.585},
      #   {"Count": 59, "BidChange": 7.07},
      #   {"Count": 11, "BidChange": 9.555}
      # ])

      ret.promise

    portfolio_scheduled_diff: (portfolio_id) ->
      ret = $q.defer()

      $http.get("#{Config.api}/me/bids/#{portfolio_id}/diff/scheduled/histogram").then(
        (r) ->
          ret.resolve(r.data)
        (e) ->
          ret.reject(r.data)
      )
      # ret.resolve([
      #   {"Count": 10, "BidChange": -12.81},
      #   {"Count": 25, "BidChange": -10.325},
      #   {"Count": 92, "BidChange": -7.84},
      #   {"Count": 381, "BidChange": -5.355},
      #   {"Count": 1274, "BidChange": -2.87},
      #   {"Count": 124843, "BidChange": -0.385},
      #   {"Count": 266, "BidChange": 2.1},
      #   {"Count": 72, "BidChange": 4.585},
      #   {"Count": 59, "BidChange": 7.07},
      #   {"Count": 11, "BidChange": 9.555}
      # ])

      ret.promise

    portfolio_actual: (portfolio_id) ->
      ret = $q.defer()

      $http.get("#{Config.api}/me/bids/#{portfolio_id}/actual/histogram").then(
        (r) ->
          ret.resolve(r.data)
        (e) ->
          ret.reject(r.data)
      )
      #ret.resolve([{"Count": 84.0, "CpcBid": 0.01}, {"Count": 6229.0, "CpcBid": 0.70989999999999998}, {"Count": 1059.0, "CpcBid": 1.4097999999999999}, {"Count": 1296.0, "CpcBid": 2.1097000000000001}, {"Count": 15308.0, "CpcBid": 2.8096000000000001}, {"Count": 1892.0, "CpcBid": 3.5095000000000001}, {"Count": 3151.0, "CpcBid": 4.2093999999999996}, {"Count": 42427.0, "CpcBid": 4.9093}, {"Count": 21274.0, "CpcBid": 5.6092000000000004}, {"Count": 9212.0, "CpcBid": 6.3090999999999999}, {"Count": 6596.0, "CpcBid": 7.0090000000000003}, {"Count": 21915.0, "CpcBid": 7.7088999999999999}, {"Count": 4856.0, "CpcBid": 8.4087999999999994}, {"Count": 252.0, "CpcBid": 9.1087000000000007}, {"Count": 9121.0, "CpcBid": 9.8086000000000002}, {"Count": 161.0, "CpcBid": 10.5085}, {"Count": 189.0, "CpcBid": 11.208399999999999}, {"Count": 3750.0, "CpcBid": 11.908300000000001}, {"Count": 137.0, "CpcBid": 12.6082}, {"Count": 125.0, "CpcBid": 13.3081}, {"Count": 21.0, "CpcBid": 14.007999999999999}, {"Count": 987.0, "CpcBid": 14.7079}, {"Count": 53.0, "CpcBid": 15.4078}, {"Count": 6.0, "CpcBid": 16.107700000000001}, {"Count": 12.0, "CpcBid": 16.807600000000001}, {"Count": 362.0, "CpcBid": 17.5075}, {"Count": 2.0, "CpcBid": 18.2074}, {"Count": 5.0, "CpcBid": 18.907299999999999}, {"Count": 0.0, "CpcBid": 19.607199999999999}, {"Count": 4.0, "CpcBid": 20.307099999999998}, {"Count": 138.0, "CpcBid": 21.007000000000001}, {"Count": 1.0, "CpcBid": 21.706900000000001}, {"Count": 0.0, "CpcBid": 22.4068}, {"Count": 0.0, "CpcBid": 23.1067}, {"Count": 0.0, "CpcBid": 23.8066}, {"Count": 0.0, "CpcBid": 24.506499999999999}, {"Count": 61.0, "CpcBid": 25.206399999999999}, {"Count": 0.0, "CpcBid": 25.906300000000002}, {"Count": 0.0, "CpcBid": 26.606200000000001}, {"Count": 0.0, "CpcBid": 27.306100000000001}, {"Count": 3.0, "CpcBid": 28.006}, {"Count": 0.0, "CpcBid": 28.7059}, {"Count": 0.0, "CpcBid": 29.405799999999999}, {"Count": 78.0, "CpcBid": 30.105699999999999}, {"Count": 0.0, "CpcBid": 30.805599999999998}, {"Count": 0.0, "CpcBid": 31.505500000000001}, {"Count": 0.0, "CpcBid": 32.205399999999997}, {"Count": 0.0, "CpcBid": 32.905299999999997}, {"Count": 0.0, "CpcBid": 33.605200000000004}, {"Count": 0.0, "CpcBid": 34.305100000000003}, {"Count": 0.0, "CpcBid": 35.005000000000003}, {"Count": 0.0, "CpcBid": 35.704900000000002}, {"Count": 18.0, "CpcBid": 36.404800000000002}, {"Count": 0.0, "CpcBid": 37.104700000000001}, {"Count": 0.0, "CpcBid": 37.804600000000001}, {"Count": 0.0, "CpcBid": 38.5045}, {"Count": 0.0, "CpcBid": 39.2044}, {"Count": 0.0, "CpcBid": 39.904299999999999}, {"Count": 0.0, "CpcBid": 40.604199999999999}, {"Count": 0.0, "CpcBid": 41.304099999999998}, {"Count": 0.0, "CpcBid": 42.003999999999998}, {"Count": 0.0, "CpcBid": 42.703899999999997}, {"Count": 0.0, "CpcBid": 43.403799999999997}, {"Count": 2.0, "CpcBid": 44.103700000000003}, {"Count": 0.0, "CpcBid": 44.803600000000003}, {"Count": 0.0, "CpcBid": 45.503500000000003}, {"Count": 0.0, "CpcBid": 46.203400000000002}, {"Count": 0.0, "CpcBid": 46.903300000000002}, {"Count": 0.0, "CpcBid": 47.603200000000001}, {"Count": 0.0, "CpcBid": 48.303100000000001}, {"Count": 0.0, "CpcBid": 49.003}, {"Count": 0.0, "CpcBid": 49.7029}, {"Count": 0.0, "CpcBid": 50.402799999999999}, {"Count": 0.0, "CpcBid": 51.102699999999999}, {"Count": 0.0, "CpcBid": 51.802599999999998}, {"Count": 0.0, "CpcBid": 52.502499999999998}, {"Count": 0.0, "CpcBid": 53.202399999999997}, {"Count": 0.0, "CpcBid": 53.902299999999997}, {"Count": 0.0, "CpcBid": 54.602200000000003}, {"Count": 0.0, "CpcBid": 55.302100000000003}, {"Count": 0.0, "CpcBid": 56.002000000000002}, {"Count": 0.0, "CpcBid": 56.701900000000002}, {"Count": 0.0, "CpcBid": 57.401800000000001}, {"Count": 0.0, "CpcBid": 58.101700000000001}, {"Count": 0.0, "CpcBid": 58.801600000000001}, {"Count": 0.0, "CpcBid": 59.5015}, {"Count": 0.0, "CpcBid": 60.2014}, {"Count": 0.0, "CpcBid": 60.901299999999999}, {"Count": 0.0, "CpcBid": 61.601199999999999}, {"Count": 0.0, "CpcBid": 62.301099999999998}, {"Count": 0.0, "CpcBid": 63.000999999999998}, {"Count": 0.0, "CpcBid": 63.700899999999997}, {"Count": 0.0, "CpcBid": 64.400800000000004}, {"Count": 0.0, "CpcBid": 65.100700000000003}, {"Count": 0.0, "CpcBid": 65.800600000000003}, {"Count": 0.0, "CpcBid": 66.500500000000002}, {"Count": 0.0, "CpcBid": 67.200400000000002}, {"Count": 0.0, "CpcBid": 67.900300000000001}, {"Count": 0.0, "CpcBid": 68.600200000000001}, {"Count": 1.0, "CpcBid": 69.3001}])

      ret.promise
])
