angular.module('thesoupApp').controller('AccountsCtrl', ($scope, $log, $timeout, User) ->

	$scope.init = () ->
		User.accounts().then(
			(graph) ->
				links = graph.links
				accounts = _.object(
					_.map(graph.entries, (e) -> e.customerId),
					graph.entries
				)

				parents = {}
				children = {}

				_.each(links, (l) ->
					(parents[l.clientCustomerId] = []) unless parents[l.clientCustomerId]?
					(children[l.managerCustomerId] = []) unless children[l.managerCustomerId]?

					parents[l.clientCustomerId].push(l.managerCustomerId)
					children[l.managerCustomerId].push(l.clientCustomerId)
				)


				rootClientId = _.find(_.keys(accounts), (clientId) -> not parents[clientId]?)

				if rootClientId
					$log.debug("Root client id is #{rootClientId}")

					visit = (clientId) ->
						builder = {}
						builder['clientId'] = clientId
						builder['name'] = accounts[clientId].name

						_children = []

						if children[clientId]?
							_children = _.map(children[clientId], (childClientId) -> visit(childClientId))

						builder['children'] = _children

						builder

					tree = visit(rootClientId)

					$log.debug("Restored account tree")
					$log.debug(tree)

					$scope.accounts = [tree]
				else
					$log.warn("Was unable to define root client id")
		)
)