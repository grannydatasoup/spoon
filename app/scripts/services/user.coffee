angular.module('thesoupApp').factory('User', ['$http', '$q', '$log', 'Config', ($http, $q, $log, Config) ->
	(
		me: () ->
			email = $q.defer()
			$http.get("#{Config.api}/me").then(
				(r) ->
					if r?.data?.email?
						email.resolve r.data.email
					else
						email.reject "Email expected"
				() ->
					email.reject "Service error"
			)

			email.promise

		accounts: () ->
			accounts = $q.defer()
			$http.get("#{Config.api}/me/accounts").then(
				(r) ->
					accounts.resolve r.data
				(e) ->
					$log.error('Unable to load accounts')
					$log.error(e)
					accounts.reject e
			)

			accounts.promise

		campaigns: (account) ->
			campaigns = $q.defer()
			if not account?
				$http.get("#{Config.api}/me/campaigns").then(
					(r) ->
						campaigns.resolve r.data
					(e) ->
						$log.error('Unable to load campaigns')
						$log.error(e)
						campaigns.reject e
				)
			else
				$http.get("#{Config.api}/me/accounts/#{account}/campaigns").then(
					(r) ->
						campaigns.resolve r.data
					(e) ->
						$log.error('Unable to load campaigns')
						$log.error(e)
						campaigns.reject e
				)
			campaigns.promise
	)
])
