angular.module('thesoupApp').controller('MainCtrl', ($scope, $log, Auth, User) ->

	$scope.me = null
	$scope.inProgress = false
	$scope.retry = false

	$scope.again = () ->
		$scope.retry = true

	$scope.auth = () ->
		$scope.inProgress = true
		Auth().then(
			(r) ->
				User.me().then((e) -> $scope.me = e)
				$scope.inProgress = false				
			(e) ->
				$scope.inProgress = false
				$log.warn e
		)

)