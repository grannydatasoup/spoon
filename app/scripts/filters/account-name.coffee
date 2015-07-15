angular.module('thesoupApp').filter('accountName', ($log) ->

  (input, accounts) ->
    if accounts?
      account = _.find(accounts, (c) -> c.customerId.toString() is input.toString())
      if account?
       account.name
      else
        input
    else
      input
)