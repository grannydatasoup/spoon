angular.module('thesoupApp').factory('Auth', ['$window', '$q', '$log', '$timeout', 'Config', ($window, $q, $log, $timeout, Config) ->
	() ->
		result = $q.defer()
		
		w = $window.open("#{Config.api}/auth", "_blank", "toolbar=no, scrollbars=no, resizable=np, width=400, height=400");
		$window._result = result

		t = $timeout(
			() -> 
				result.reject false, 
			60000
		)

		result.promise.then(
			() -> 
			t.cancel
		)

		result.promise
])