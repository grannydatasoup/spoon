angular.module('thesoupApp').filter('accountName', () ->

  (input, accounts) ->
    if accounts?
      account = _.find(accounts, (c) -> c.customerId.toString() is input)
      if account?
       account.name
      else
        input
    else
      input
)