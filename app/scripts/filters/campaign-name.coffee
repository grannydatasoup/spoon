angular.module('thesoupApp').filter('campaignName', (User, $log) ->
  campaigns = null
  User.campaigns().then (c) ->
    $log.debug("Loaded user campaigns")
    $log.debug(c)
    campaigns = c

  (input) ->

    if campaigns?
      campaign = _.find(campaigns, (c) -> c.id.toString() is input)

      if campaign?
        campaign.name
      else
        input
    else
      input
)