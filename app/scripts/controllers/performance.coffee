angular.module('thesoupApp').controller('PerformanceCtrl', ($scope, $log, $resource, Config) ->

    $scope.portfolio = {}
    Portfolio = $resource("#{Config.api}/portfolio/:portfolioName", portfolioName: '@name')
    $scope.portfolios = Portfolio.query()

    $scope.$watch(
        () ->
            $scope.portfolio.selected
        () ->
            $log.debug($scope.portfolio.selected)
    )

)
