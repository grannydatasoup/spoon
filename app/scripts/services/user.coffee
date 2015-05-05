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
	)
])